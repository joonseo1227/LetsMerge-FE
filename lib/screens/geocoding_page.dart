import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/geocoding_provider.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/main/main_page.dart';
import 'package:letsmerge/screens/search_page.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_create_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_skeleton_loader.dart';
import 'package:letsmerge/widgets/c_text_field.dart';

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
  bool isCameraIdle = true;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();

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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('GPS 상태를 확인하세요.'),
          ),
        );
      }
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
    if (!isCameraIdle || _mapController == null) return;
    isCameraIdle = false;

    NCameraPosition cameraPosition = await _mapController!.getCameraPosition();

    String newAddress = await ref
        .read(reverseGeocodingProvider.notifier)
        .fetchAddress(
            cameraPosition.target.latitude, cameraPosition.target.longitude);

    debugPrint(
        "_onCameraIdle 실행됨: (${cameraPosition.target.latitude}, ${cameraPosition.target.longitude})");

    if (mounted) {
      setState(() {
        _selectedAddress = newAddress;
      });
    }

    Future.delayed(Duration(milliseconds: 500), () {
      isCameraIdle = true;
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

  void _showPlaceBottomSheet() async {
    final isDarkMode = ref.read(themeProvider);

    NCameraPosition cameraPosition = await _mapController!.getCameraPosition();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ThemeModel.background(isDarkMode),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(0),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: ThemeModel.sub3(isDarkMode),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Text(
                      '선택한 위치의 장소 이름을 입력하세요',
                      style: TextStyle(
                        color: ThemeModel.text(isDarkMode),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '장소명은 알아보기 쉽도록 적어주세요.',
                      style: TextStyle(
                        color: ThemeModel.text(isDarkMode),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 24),
                    CTextField(
                      controller: _placeController,
                      hint: '예: 강남역 1번 출구, 스타벅스 앞',
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                    CButton(
                      onTap: _placeController.text.isEmpty
                          ? null
                          : () {
                              ref
                                  .read(reverseGeocodingProvider.notifier)
                                  .setPlaceAndAddress(
                                    mode: widget.mode,
                                    address: _selectedAddress,
                                    place: _placeController.text,
                                    lat: cameraPosition.target.latitude,
                                    lng: cameraPosition.target.longitude,
                                  );

                              final selectedLocations =
                                  ref.read(reverseGeocodingProvider);

                              if (selectedLocations[GeocodingMode.departure]
                                          ?.place !=
                                      null &&
                                  selectedLocations[GeocodingMode.destination]
                                          ?.place !=
                                      null) {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        const TaxiGroupCreatePage(),
                                  ),
                                );
                              } else {
                                Navigator.of(context).pushAndRemoveUntil(
                                  CupertinoPageRoute(
                                    builder: (context) => MainPage(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              }
                            },
                      label: '확인',
                      icon: Icons.navigate_next,
                      width: double.maxFinite,
                    ),
                    SizedBox(height: MediaQuery.of(context).padding.bottom),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle:
            isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          CInkWell(
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => SearchPage(),
                ),
              );
            },
            child: SizedBox(
              width: 32,
              height: 32,
              child: Icon(
                Icons.search,
                size: 28,
                color: ThemeModel.text(isDarkMode),
              ),
            ),
          ),
          SizedBox(
            width: 16,
          ),
        ],
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
              _selectedAddress,
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
                onTap: _showPlaceBottomSheet,
                size: CButtonSize.extraLarge,
                label: widget.mode == GeocodingMode.departure
                    ? '출발지 설정'
                    : '목적지 설정',
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
    _addressController.dispose();
    super.dispose();
  }
}
