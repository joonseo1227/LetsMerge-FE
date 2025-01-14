import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';

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
            NaverMap(
              options: NaverMapViewOptions(
                initialCameraPosition: NCameraPosition(
                  target: NLatLng(
                      _currentPosition!.latitude, _currentPosition!.longitude),
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
            SafeArea(
              child: DraggableScrollableSheet(
                snap: true,
                snapSizes: const [0.1, 0.3, 1],
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
                        _isButtonVisible = _currentExtent < 0.4;
                      });
                      return true;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: ThemeModel.surface(isDarkMode),
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
                                return CInkWell(
                                  onTap: () {
                                    debugPrint('옵션 $index 클릭됨');
                                  },
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.place,
                                      color: ThemeModel.text(isDarkMode),
                                    ),
                                    title: Text(
                                      '옵션 $index',
                                      style: TextStyle(
                                        color: ThemeModel.text(isDarkMode),
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
}
