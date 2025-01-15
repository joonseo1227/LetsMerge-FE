import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/group_detail_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_skeleton_loader.dart';

class MapTab extends ConsumerStatefulWidget {
  const MapTab({super.key});

  @override
  ConsumerState<MapTab> createState() => _MapTabState();
}

class _MapTabState extends ConsumerState<MapTab> {
  double _currentExtent = 0.1; // 초기 바텀시트 위치 비율
  double _widgetHeight = 0; // 위젯 높이
  double _buttonPosition = 0; // FAB 위치
  final double _buttonPositionPadding = 16;
  bool _isButtonVisible = true;
  bool _showSkeleton = true;

  NaverMapController? _mapController;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 레이아웃 계산 후 size를 안전하게 처리
      if (context.size != null) {
        setState(() {
          _widgetHeight = context.size!.height;
          _buttonPosition =
              _currentExtent * _widgetHeight + _buttonPositionPadding;
        });
      }
    });
    _getCurrentLocation();
  }

  // 내 위치 가져오기
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    // 현재 위치 가져오기
    Position position = await Geolocator.getCurrentPosition();

    // 위치를 저장하고 지도 초기화
    setState(() {
      _currentPosition = position;
    });

    // 초기 위치로 지도 이동
    if (_mapController != null && _currentPosition != null) {
      _mapController!.updateCamera(
        NCameraUpdate.scrollAndZoomTo(
          target:
              NLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 15.0,
        ),
      );
    }
  }

  // 내 위치로 이동하기
  Future<void> _goToCurrentLocation() async {
    if (_mapController != null && _currentPosition != null) {
      _mapController!.updateCamera(
        NCameraUpdate.scrollAndZoomTo(
          target:
              NLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 15.0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Stack(
          children: [
            if (_currentPosition != null)
              AnimatedOpacity(
                opacity: _showSkeleton ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: NaverMap(
                  options: NaverMapViewOptions(
                    initialCameraPosition: NCameraPosition(
                      target: _currentPosition != null
                          ? NLatLng(
                              _currentPosition!.latitude,
                              _currentPosition!.longitude,
                            )
                          : NLatLng(37.5665, 126.9780),
                      zoom: 15.0,
                    ),
                  ),
                  onMapReady: (controller) {
                    debugPrint('Naver Map is ready');
                    _mapController = controller;
                    controller
                        .setLocationTrackingMode(NLocationTrackingMode.follow);
                    Future.delayed(const Duration(milliseconds: 800), () {
                      setState(() {
                        _showSkeleton = false;
                      });
                    });
                  },
                ),
              ),
            if (_showSkeleton) const CSkeleton(),
            // 지도를 Positioned로 배치
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              // _widgetHeight를 사용하여 계산
              bottom: _currentExtent <= 0.4
                  ? _currentExtent * _widgetHeight
                  : 0.4 * _widgetHeight,
              child: NaverMap(
                options: NaverMapViewOptions(
                  initialCameraPosition: NCameraPosition(
                    target: NLatLng(_currentPosition!.latitude,
                        _currentPosition!.longitude),
                    zoom: 15.0,
                  ),
                ),
                onMapReady: (controller) {
                  debugPrint('Naver Map is ready');
                  _mapController = controller;
                  controller
                      .setLocationTrackingMode(NLocationTrackingMode.follow);
                },
              ),
            ),
            // 바텀시트
            SafeArea(
              child: DraggableScrollableSheet(
                snap: true,
                snapSizes: const [0.1, 0.4, 1],
                initialChildSize: 0.1,
                minChildSize: 0.1,
                maxChildSize: 1,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return NotificationListener<DraggableScrollableNotification>(
                    onNotification: (notification) {
                      setState(() {
                        _currentExtent = notification.extent;
                        if (context.size != null) {
                          _widgetHeight = context.size!.height;
                          _buttonPosition = _currentExtent * _widgetHeight +
                              _buttonPositionPadding;
                        }
                        _isButtonVisible = _currentExtent <= 0.4;
                      });
                      return true;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: ThemeModel.background(isDarkMode),
                        boxShadow: [
                          BoxShadow(
                            color: black.withAlpha(20),
                            blurRadius: 16,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // 드래그 핸들
                          Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: ShapeDecoration(
                              color: ThemeModel.sub2(isDarkMode),
                              shape: const StadiumBorder(),
                            ),
                          ),
                          // 리스트 내용
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: 10,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                                  child: CInkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              GroupDetailPage(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      color: ThemeModel.surface(isDarkMode),
                                      width: double.maxFinite,
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '1자리 남음',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: ThemeModel.sub3(
                                                      isDarkMode),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 16,
                                                child: VerticalDivider(
                                                  thickness: 1,
                                                  color: ThemeModel.sub2(
                                                      isDarkMode),
                                                ),
                                              ),
                                              Text(
                                                '5분 후 마감',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: ThemeModel.sub3(
                                                      isDarkMode),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 8,
                                                height: 8,
                                                margin: EdgeInsets.all(6),
                                                decoration: ShapeDecoration(
                                                  color: ThemeModel.sub2(
                                                      isDarkMode),
                                                  shape: CircleBorder(),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '가천대역 수인분당선',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: ThemeModel.text(
                                                          isDarkMode),
                                                    ),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .access_time_filled,
                                                        size: 14,
                                                        color: ThemeModel.sub2(
                                                            isDarkMode),
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        '10:30',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              ThemeModel.sub3(
                                                                  isDarkMode),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 16,
                                                        child: VerticalDivider(
                                                          thickness: 1,
                                                          color:
                                                              ThemeModel.sub2(
                                                                  isDarkMode),
                                                        ),
                                                      ),
                                                      Text(
                                                        '현재 위치에서 도보 3분',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              ThemeModel.sub3(
                                                                  isDarkMode),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 8,
                                                height: 8,
                                                margin: EdgeInsets.all(6),
                                                decoration: ShapeDecoration(
                                                  color: ThemeModel.highlight(
                                                      isDarkMode),
                                                  shape: CircleBorder(),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '가천대학교 AI관',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: ThemeModel.text(
                                                          isDarkMode),
                                                    ),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .access_time_filled,
                                                        size: 14,
                                                        color: ThemeModel.sub2(
                                                            isDarkMode),
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        '10:35',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              ThemeModel.sub3(
                                                                  isDarkMode),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: _buttonPosition,
              right: 16,
              child: AnimatedOpacity(
                opacity: _isButtonVisible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 150),
                child: CButton(
                  style: CButtonStyle.secondary(isDarkMode),
                  icon: Icons.my_location,
                  onTap: () async {
                    debugPrint('move to current location');
                    await _goToCurrentLocation();
                  },
                ),
              ),
            ),
          ],
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
