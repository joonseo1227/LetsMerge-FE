import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/geocoding_provider.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_create_page.dart';
import 'package:letsmerge/widgets/c_button.dart';

class GeocodingPage extends ConsumerStatefulWidget {
  final GeocodingMode mode;

  const GeocodingPage({super.key, required this.mode});

  @override
  ConsumerState<GeocodingPage> createState() => _GeocodingPageState();
}

class _GeocodingPageState extends ConsumerState<GeocodingPage> {
  NaverMapController? _mapController;
  Position? _currentPosition;
  Position? _initialPosition;
  StreamSubscription<Position>? _positionStream;
  bool _isLoading = true;
  String _selectedAddress = '위치를 가져오는 중...';

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

  /// 위치 변화 감지
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

      String newAddress = await ref
          .read(reverseGeocodingProvider.notifier)
          .fetchAddress(
              cameraPosition.target.latitude, cameraPosition.target.longitude);

      if (mounted) {
        setState(() {
          _selectedAddress = newAddress;
        });
      }
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
    final double bottomContainerHeight = 150;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return AnnotatedRegion(
      value: isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
            ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: Stack(
          children: [
            if (_initialPosition != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: screenHeight - bottomContainerHeight,
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
              ),
            Positioned(
              top: (screenHeight - bottomContainerHeight) / 2 - 30,
              left: screenWidth / 2 - 30,
              child: SizedBox(
                width: 60,
                height: 60,
                child: SvgPicture.asset('assets/imgs/marker.svg'),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: bottomContainerHeight,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: ThemeModel.surface(isDarkMode),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedAddress,
                      style: TextStyle(
                          fontSize: 18, color: ThemeModel.text(isDarkMode)),
                      textAlign: TextAlign.center,
                    ),
                    Spacer(),
                    CButton(
                      onTap: () {
                        ref
                            .read(reverseGeocodingProvider.notifier)
                            .setAddress(widget.mode, _selectedAddress);

                        final selectedLocations =
                            ref.read(reverseGeocodingProvider);

                        //출발지와 목적지가 모두 설정된 경우 이동
                        if (selectedLocations[GeocodingMode.departure]!
                                .isNotEmpty &&
                            selectedLocations[GeocodingMode.destination]!
                                .isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TaxiGroupCreatePage(),
                            ),
                          );
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      size: CButtonSize.large,
                      label: widget.mode == GeocodingMode.departure
                          ? '출발지 설정'
                          : '목적지 설정',
                      width: double.maxFinite,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: bottomContainerHeight + 16,
              right: 16,
              child: CButton(
                style: CButtonStyle.secondary(isDarkMode),
                icon: Icons.my_location,
                onTap: _goToCurrentLocation,
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
