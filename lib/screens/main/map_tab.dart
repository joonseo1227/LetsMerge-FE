import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_skeleton_loader.dart';

class MapTab extends ConsumerStatefulWidget {
  const MapTab({super.key});

  @override
  ConsumerState<MapTab> createState() => _MapTabState();
}

class _MapTabState extends ConsumerState<MapTab> {
  NaverMapController? _mapController;
  Position? _currentPosition;
  Position? _initialPosition;
  StreamSubscription<Position>? _positionStream;
  bool _showSkeleton = true;

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
    return AnnotatedRegion(
      value: isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
            ),
      child: Scaffold(
        body: Stack(
          children: [
            if (_initialPosition != null)
              NaverMap(
                onMapReady: _onMapReady,
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
