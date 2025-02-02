import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/directions_provider.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/provider/geocoding_provider.dart';
import 'package:letsmerge/screens/main/main_page.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_skeleton_loader.dart';

class TaxiGroupCreatePage extends ConsumerStatefulWidget {
  const TaxiGroupCreatePage({super.key});

  @override
  ConsumerState<TaxiGroupCreatePage> createState() => _TaxiGroupCreatePageState();
}

class _TaxiGroupCreatePageState extends ConsumerState<TaxiGroupCreatePage> {
  NaverMapController? _mapController;
  bool _showSkeleton = true;
  final _mapKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchDirections());
  }

  void _fetchDirections() async {
    final selectedLocations = ref.read(reverseGeocodingProvider);

    final departure = selectedLocations[GeocodingMode.departure];
    final destination = selectedLocations[GeocodingMode.destination];

    if (departure == null || destination == null) {
      debugPrint("🚨 출발지 또는 목적지 정보가 없음.");
      return;
    }

    if (departure.latitude == destination.latitude && departure.longitude == destination.longitude) {
      debugPrint("🚨 출발지와 목적지가 동일하여 요청을 중단합니다.");
      return;
    }

    ref.read(directionsProvider.notifier).fetchDirections(
      departure.latitude,
      departure.longitude,
      destination.latitude,
      destination.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final selectedLocations = ref.watch(reverseGeocodingProvider);
    final routePoints = ref.watch(directionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("택시팟 생성"),
        titleSpacing: 0,
        leading: CInkWell(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => MainPage(),
              ),
                  (Route<dynamic> route) => false,
            );
          },
          child: SizedBox(
            width: 32,
            height: 32,
            child: Icon(
              Icons.close,
              size: 28,
              color: ThemeModel.text(isDarkMode),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 지도
                SizedBox(
                  height: 400,
                  child: Stack(
                    children: [
                      if (selectedLocations[GeocodingMode.departure] != null &&
                          selectedLocations[GeocodingMode.destination] != null)
                        AnimatedOpacity(
                          opacity: _showSkeleton ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: NaverMap(
                            key: _mapKey,
                            options: NaverMapViewOptions(
                              mapType: NMapType.navi,
                              nightModeEnable: isDarkMode,
                              initialCameraPosition: NCameraPosition(
                                target: selectedLocations[GeocodingMode.departure] != null
                                    ? NLatLng(
                                  selectedLocations[GeocodingMode.departure]!.latitude,
                                  selectedLocations[GeocodingMode.departure]!.longitude,
                                )
                                    : NLatLng(37.5665, 126.9780),
                                zoom: 13.0,
                              ),
                            ),
                            onMapReady: (controller) async {
                              debugPrint('Naver Map Ready');
                              _mapController = controller;
                              controller.setLocationTrackingMode(NLocationTrackingMode.follow);

                              _fetchDirections();

                              await Future.delayed(const Duration(milliseconds: 800));
                              if (mounted) {
                                setState(() {
                                  _showSkeleton = false;
                                });
                              }

                              if (routePoints.isNotEmpty) {
                                controller.addOverlay(NPolylineOverlay(
                                  id: "directions",
                                  coords: routePoints.map((p) => NLatLng(p.latitude, p.longitude)).toList(),
                                  color: ThemeModel.highlight(isDarkMode),
                                  width: 9,
                                ));
                              }
                            },
                          ),
                        ),
                      if (_showSkeleton) const CSkeleton(),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                /// 출발지 정보
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.all(6),
                      decoration: ShapeDecoration(
                        color: ThemeModel.sub2(isDarkMode),
                        shape: const CircleBorder(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      selectedLocations[GeocodingMode.departure]!.address,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ThemeModel.text(isDarkMode),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                /// 도착지 정보
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.all(6),
                      decoration: ShapeDecoration(
                        color: ThemeModel.highlight(isDarkMode),
                        shape: const CircleBorder(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      selectedLocations[GeocodingMode.destination]!.address,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ThemeModel.text(isDarkMode),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}