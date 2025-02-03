import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/directions_provider.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/provider/geocoding_provider.dart';
import 'package:letsmerge/screens/main/main_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_dialog.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_skeleton_loader.dart';

class TaxiGroupCreatePage extends ConsumerStatefulWidget {
  const TaxiGroupCreatePage({super.key});

  @override
  ConsumerState<TaxiGroupCreatePage> createState() =>
      _TaxiGroupCreatePageState();
}

class _TaxiGroupCreatePageState extends ConsumerState<TaxiGroupCreatePage> {
  NaverMapController? _mapController;
  bool _showSkeleton = true;
  final _mapKey = UniqueKey();

  void _fetchDirections() async {
    final selectedLocations = ref.read(reverseGeocodingProvider);

    final departure = selectedLocations[GeocodingMode.departure];
    final destination = selectedLocations[GeocodingMode.destination];

    if (departure == null || destination == null) {
      debugPrint("출발지 또는 목적지 정보가 없음.");
      return;
    }

    if (departure.address == destination.address) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CDialog(
            title: '출발지와 목적지가 같아요',
            content: Text(
              '확인 후 다시 지정해주세요.',
              style: TextStyle(
                color: ThemeModel.text(
                  ref.read(themeProvider),
                ),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            buttons: [
              CButton(
                size: CButtonSize.extraLarge,
                label: '확인',
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    CupertinoPageRoute(
                      builder: (context) => MainPage(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          );
        },
      );
      return;
    }

    ref.read(directionsProvider.notifier).fetchDirections(
          departure.latitude,
          departure.longitude,
          destination.latitude,
          destination.longitude,
        );
    _addPolylineOverlay();
  }

  // 경로 오버레이 추가 및 경로 전체 영역을 표시하는 함수
  void _addPolylineOverlay() async {
    final routePoints = ref.read(directionsProvider);

    if (_mapController != null && routePoints.isNotEmpty) {
      // 기존 오버레이 모두 제거
      await _mapController!.clearOverlays();

      // 경로 오버레이 추가
      await _mapController!.addOverlay(
        NPolylineOverlay(
          id: "directions",
          coords: routePoints,
          color: ThemeModel.text(
            ref.watch(themeProvider),
          ),
          width: 4,
        ),
      );

      // routePoints의 모든 좌표를 포함하는 bounds 계산
      final bounds = NLatLngBounds.from(routePoints);

      // padding을 적용하여 bounds 내 영역을 온전히 보여주는 카메라 업데이트 생성
      final cameraUpdate = NCameraUpdate.fitBounds(
        bounds,
        padding: EdgeInsets.all(40),
      );

      await _mapController!.updateCamera(cameraUpdate);

      debugPrint("경로 오버레이 추가 및 카메라 업데이트");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final selectedLocations = ref.watch(reverseGeocodingProvider);
    final taxiFare = ref.watch(directionsProvider.notifier).formattedTaxiFare;

    ref.listen<List<NLatLng>>(directionsProvider, (prev, next) {
      _addPolylineOverlay();
    });

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
                            ),
                            onMapReady: (controller) async {
                              debugPrint('Naver Map Ready');
                              _mapController = controller;

                              _fetchDirections();

                              await Future.delayed(
                                const Duration(milliseconds: 800),
                              );
                              if (mounted) {
                                setState(
                                  () {
                                    _showSkeleton = false;
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      if (_showSkeleton) const CSkeleton(),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                Container(
                  color: ThemeModel.surface(isDarkMode),
                  width: double.maxFinite,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
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
                                selectedLocations[GeocodingMode.departure]!
                                    .place,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeModel.text(isDarkMode),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 32),
                              Flexible(
                                child: Text(
                                  selectedLocations[GeocodingMode.departure]!
                                      .address,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeModel.sub4(isDarkMode),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
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
                                selectedLocations[GeocodingMode.destination]!
                                    .place,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeModel.text(isDarkMode),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 32),
                              Flexible(
                                child: Text(
                                  selectedLocations[GeocodingMode.destination]!
                                      .address,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeModel.sub4(isDarkMode),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                /// 비용 정보
                Container(
                  color: ThemeModel.surface(isDarkMode),
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "예상 택시비",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ThemeModel.sub4(isDarkMode),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Stack(
                        children: [
                          AnimatedOpacity(
                            opacity:
                                _showSkeleton || taxiFare == null ? 0.0 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: Text(
                              "$taxiFare원",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: ThemeModel.text(isDarkMode),
                              ),
                            ),
                          ),
                          if (_showSkeleton || taxiFare == null)
                            SizedBox(
                              height: 32,
                              child: const CSkeleton(),
                            ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: ThemeModel.highlight(isDarkMode),
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: SafeArea(
          child: CButton(
            onTap: () {},
            size: CButtonSize.extraLarge,
            label: '택시팟 만들기',
            icon: Icons.navigate_next,
            width: double.maxFinite,
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
