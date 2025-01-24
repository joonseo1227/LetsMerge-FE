import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/geocoding_provider.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_button.dart';

class GeocodingPage extends ConsumerStatefulWidget {
  const GeocodingPage({super.key});

  @override
  ConsumerState<GeocodingPage> createState() => _GeocodingPageState();
}

class _GeocodingPageState extends ConsumerState<GeocodingPage> {
  NaverMapController? _mapController;
  Position? _currentPosition;
  Position? _initialPosition;
  StreamSubscription<Position>? _positionStream;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeInitialPosition();
    _startLocationStream();
  }

  /// 현재 위치 가져오기
  Future<void> _initializeInitialPosition() async {
    try {
      final pos = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _initialPosition = pos;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('위치 정보를 가져오지 못했습니다: $e');
    }
  }

  /// 위치 변화 감지 (스트리밍)
  void _startLocationStream() {
    try {
      _positionStream = Geolocator.getPositionStream().listen((pos) {
        _currentPosition = pos;
      });
    } catch (e) {
      debugPrint('$e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('GPS 상태를 확인하세요.'),
        ),
      );
    }
  }

  /// 지도 이동이 멈춘 후 주소 요청
  void _onCameraIdle() async {
    if (_mapController != null) {
      NCameraPosition cameraPosition =
          await _mapController!.getCameraPosition();
      ref.read(reverseGeocodingProvider.notifier).fetchAddress(
          cameraPosition.target.latitude, cameraPosition.target.longitude);
    }
  }

  /// 내 위치로 이동
  Future<void> _goToCurrentLocation() async {
    if (_mapController != null && _currentPosition != null) {
      await _mapController!.updateCamera(
        NCameraUpdate.scrollAndZoomTo(
          target: NLatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          zoom: 15.0,
        ),
      );
    } else {
      debugPrint('현재 위치를 가져오지 못했습니다.');
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
    final selectedAddress = ref.watch(reverseGeocodingProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle:
            isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          if (_initialPosition != null)
            Expanded(
              child: Stack(
                children: [
                  SizedBox(
                    child: NaverMap(
                      onMapReady: (controller) {
                        _mapController = controller;
                        _mapController!.updateCamera(
                          NCameraUpdate.scrollAndZoomTo(
                            target: NLatLng(
                              _initialPosition!.latitude,
                              _initialPosition!.longitude,
                            ),
                            zoom: 15.0,
                          ),
                        );
                      },
                      options: NaverMapViewOptions(
                        mapType: NMapType.navi,
                        nightModeEnable: isDarkMode,
                        initialCameraPosition: NCameraPosition(
                          target: NLatLng(
                            _initialPosition?.latitude ?? 37.5665,
                            _initialPosition?.longitude ?? 126.9780,
                          ),
                          zoom: 15.0,
                        ),
                      ),
                      onCameraIdle: _onCameraIdle,
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: CButton(
                      style: CButtonStyle.secondary(isDarkMode),
                      icon: Icons.my_location,
                      onTap: _goToCurrentLocation,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            color: isDarkMode ? grey70 : grey80,
                            padding: EdgeInsets.all(8),
                            child: Text(
                              '출발지',
                              style: TextStyle(
                                color: white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            width: 4,
                            height: 16,
                            color: isDarkMode ? grey70 : grey80,
                          ),
                          SizedBox(
                            height: 48,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: EdgeInsets.all(16),
            width: double.infinity,
            height: 96,
            decoration: BoxDecoration(
              color: ThemeModel.surface(isDarkMode),
            ),
            child: Text(
              selectedAddress,
              maxLines: 2,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: ThemeModel.text(isDarkMode),
              ),
            ),
          ),
          Container(
            color: blue60,
            child: SafeArea(
              top: false,
              child: CButton(
                onTap: () {
                  Navigator.pop(context);
                },
                size: CButtonSize.extraLarge,
                label: '출발지 설정',
                icon: Icons.navigate_next,
                width: double.maxFinite,
              ),
            ),
          ),
        ],
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
