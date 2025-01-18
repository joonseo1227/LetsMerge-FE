import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_detail_card.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_preview_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_skeleton_loader.dart';

class MapTab extends ConsumerStatefulWidget {
  const MapTab({super.key});

  @override
  ConsumerState<MapTab> createState() => _MapTabState();
}

class _MapTabState extends ConsumerState<MapTab> {
  final DraggableScrollableController _draggableController =
      DraggableScrollableController();

  double _currentExtent = 0.1;
  double _widgetHeight = 0;
  double _buttonPosition = 0;
  final double _buttonPositionPadding = 16;
  bool _isButtonVisible = true;
  bool _showSkeleton = true;
  NaverMapController? _mapController;
  Position? _currentPosition;
  StreamSubscription<Position>? _positionStream;
  final _mapKey = UniqueKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 바텀시트 애니메이션
      _draggableController.animateTo(
        0.4,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });

    // 위치 스트림 시작
    _startLocationStream();
  }

  /// 위치 스트림 시작
  void _startLocationStream() {
    try {
      _positionStream = Geolocator.getPositionStream().listen(
        (Position position) {
          if (mounted) {
            setState(() {
              _currentPosition = position;
            });
          }
          debugPrint('Updated position: $position');
        },
      );
    } catch (e) {
      debugPrint('Error starting location stream: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('GPS 상태를 확인하세요.'),
        ),
      );
    }
  }

  void _onMapReady(NaverMapController controller) {
    debugPrint('Naver Map Ready');
    _mapController = controller;

    // 위치 추적 모드 설정
    controller.setLocationTrackingMode(NLocationTrackingMode.noFollow);

    // 지도 초기화 시 현재 위치로 이동
    _goToCurrentLocation();

    // 최초 로딩이 완료되면 Skeleton 해제
    if (_showSkeleton) {
      Future.delayed(
        const Duration(milliseconds: 800),
        () {
          if (mounted) {
            setState(() {
              _showSkeleton = false;
            });
          }
        },
      );
    }
  }

  /// 내 위치로 이동
  Future<void> _goToCurrentLocation() async {
    debugPrint('Move to current location');

    if (_mapController != null && _currentPosition != null) {
      _mapController!.updateCamera(
        NCameraUpdate.scrollAndZoomTo(
          target: NLatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          zoom: 15.0,
        ),
      );
    } else {
      debugPrint('Failed to get current location');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('GPS 상태를 확인하세요.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return AnnotatedRegion(
      value: isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
            ),
      child: Scaffold(
        body: Stack(
          children: [
            /// 지도
            if (_currentPosition != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: _currentExtent <= 0.4
                    ? _currentExtent * _widgetHeight
                    : 0.4 * _widgetHeight,
                child: AnimatedOpacity(
                  opacity: _showSkeleton ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: NaverMap(
                    key: _mapKey,
                    options: NaverMapViewOptions(
                      mapType: NMapType.navi,
                      nightModeEnable: isDarkMode,
                      initialCameraPosition: NCameraPosition(
                        target: NLatLng(
                          _currentPosition!.latitude,
                          _currentPosition!.longitude,
                        ),
                        zoom: 15.0,
                      ),
                    ),
                    onMapReady: _onMapReady,
                  ),
                ),
              ),
            if (_showSkeleton) const CSkeleton(),

            /// 바텀시트
            SafeArea(
              child: DraggableScrollableSheet(
                // 위에서 선언한 controller를 연결
                controller: _draggableController,
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

                        _isButtonVisible = _currentExtent <= 0.41;
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
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                  child: CInkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              const TaxiGroupPreviewPage(),
                                        ),
                                      );
                                    },
                                    child: const TaxiGroupDetailCard(
                                      remainingSeats: 1,
                                      closingTime: 5,
                                      startLocation: '가천대역 수인분당선',
                                      startTime: '10:30',
                                      startWalkingTime: 3,
                                      destinationLocation: '가천대학교 AI관',
                                      destinationTime: '10:35',
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

            /// 현재 위치 버튼
            Positioned(
              bottom: _buttonPosition,
              right: 16,
              child: AnimatedOpacity(
                opacity: _isButtonVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: CButton(
                  style: CButtonStyle.secondary(isDarkMode),
                  icon: Icons.my_location,
                  onTap: () async {
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
    _positionStream?.cancel();
    _mapController?.dispose();
    super.dispose();
  }
}
