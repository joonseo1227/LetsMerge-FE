import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:letsmerge/models/taxi_group/taxi_group.dart';

final supabaseProvider =
    Provider<SupabaseClient>((ref) => Supabase.instance.client);

final nearbyTaxiGroupsProvider =
    StateNotifierProvider<NearbyTaxiGroupsNotifier, List<TaxiGroup>>((ref) {
  final supabase = ref.watch(supabaseProvider);
  final notifier = NearbyTaxiGroupsNotifier(supabase, ref);
  notifier.getCurrentLocation();
  return notifier;
});

class NearbyTaxiGroupsNotifier extends StateNotifier<List<TaxiGroup>> {
  final SupabaseClient _supabase;
  final Ref _ref;

  NearbyTaxiGroupsNotifier(this._supabase, this._ref) : super([]) {
    getCurrentLocation();
  }

  Future<void> updateGroups(double lat, double lng, {int radius = 1000}) async {
    final data = await _supabase.rpc('get_nearby_taxi_groups',
        params: {'lat': lat, 'lon': lng, 'radius': radius}).select();

    state = data.map<TaxiGroup>((json) => TaxiGroup.fromJson(json)).toList();
  }

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      final pos = await Geolocator.getCurrentPosition();
      await updateGroups(pos.latitude, pos.longitude);
    } catch (e) {
      debugPrint('Error getCurrentLocation: $e');
    }
  }

  Future<List<NClusterableMarker>> buildTaxiGroupMarkers(
      BuildContext context) async {
    bool isDarkMode = _ref.read(themeProvider);
    List<NClusterableMarker> markers = [];
    for (var group in state) {
      // 각 그룹별 아이콘 생성
      NOverlayImage icon = await NOverlayImage.fromWidget(
        widget: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ThemeModel.surface(isDarkMode),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_taxi,
                    color: ThemeModel.highlightText(isDarkMode),
                    size: 32,
                  ),
                  const SizedBox(width: 10,),
                  Text(
                    '${group.remainingSeats}석 남음',
                    style: TextStyle(
                      fontSize: 16,
                      color: ThemeModel.text(isDarkMode),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Spacer(),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 100),
                child: Text(
                  group.arrivalPlace,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: ThemeModel.text(isDarkMode),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
        size: NSize(120, 80),
        context: context,
      );
      markers.add(
        NClusterableMarker(
          id: group.groupId!,
          position: NLatLng(group.departureLat, group.departureLon),
          icon: icon,
        )..setOnTapListener((cm) {
            debugPrint("그룹 마커 클릭: ${cm.info.id}");
          }),
      );
    }
    return markers;
  }
}
