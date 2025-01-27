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
import 'package:letsmerge/screens/taxi_group/taxi_group_create_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_skeleton_loader.dart';

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
  bool _showSkeleton = true;
  String _selectedAddress = '위치를 가져오는 중...';

  @override
  void initState() {
    super.initState();
    _initializeInitialPosition();
    _startLocationStream();
  }

  Future<void> _initializeInitialPosition() async {
    try {
      final pos = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _initialPosition = pos;
          _showSkeleton = false;
        });
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

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

  void _onMapReady(NaverMapController controller) {
    _mapController = controller;
    controller.setLocationTrackingMode(NLocationTrackingMode.noFollow);
    if (_initialPosition != null) {
      controller.updateCamera(
        NCameraUpdate.scrollAndZoomTo(
          target:
              NLatLng(_initialPosition!.latitude, _initialPosition!.longitude),
          zoom: 15.0,
        ),
      );
    }
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _showSkeleton = false;
        });
      }
    });
  }

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
          Expanded(
            child: Stack(
              children: [
                if (_initialPosition != null)
                  SizedBox(
                    child: NaverMap(
                      onMapReady: _onMapReady,
                      onCameraIdle: _onCameraIdle,
                      options: NaverMapViewOptions(
                        mapType: NMapType.navi,
                        nightModeEnable: isDarkMode,
                        initialCameraPosition: NCameraPosition(
                          target: NLatLng(
                            _initialPosition!.latitude,
                            _initialPosition!.longitude,
                          ),
                          zoom: 15.0,
                        ),
                      ),
                    ),
                  ),
                if (_showSkeleton) const CSkeleton(),
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
                          color: ThemeModel.highlight(isDarkMode),
                          padding: EdgeInsets.all(8),
                          child: Text(
                            widget.mode == GeocodingMode.departure
                                ? '출발지'
                                : '목적지',
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
                          color: ThemeModel.highlight(isDarkMode),
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
            color: ThemeModel.highlight(isDarkMode),
            child: SafeArea(
              top: false,
              child: CButton(
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
