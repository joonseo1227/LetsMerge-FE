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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _draggableController.animateTo(
        0.4,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
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
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: _currentExtent <= 0.4
                    ? _currentExtent * _widgetHeight
                    : 0.4 * _widgetHeight,
                child: NaverMap(
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
                  onMapReady: _onMapReady,
                ),
              ),
            if (_showSkeleton) const CSkeleton(),
            SafeArea(
              child: DraggableScrollableSheet(
                controller: _draggableController,
                snap: true,
                snapSizes: const [0.1, 0.4, 1],
                initialChildSize: 0.1,
                minChildSize: 0.1,
                maxChildSize: 1,
                builder: (context, scrollController) {
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
                          Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: ShapeDecoration(
                              color: ThemeModel.sub2(isDarkMode),
                              shape: const StadiumBorder(),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: 10,
                              itemBuilder: (context, index) {
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
            Positioned(
              bottom: _buttonPosition,
              right: 16,
              child: AnimatedOpacity(
                opacity: _isButtonVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: CButton(
                  style: CButtonStyle.secondary(isDarkMode),
                  icon: Icons.my_location,
                  onTap: _goToCurrentLocation,
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
