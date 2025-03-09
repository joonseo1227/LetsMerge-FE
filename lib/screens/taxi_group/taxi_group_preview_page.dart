import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/taxi_group/taxi_group.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/directions_provider.dart';
import 'package:letsmerge/provider/group_provider.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/main/main_page.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_detail_card.dart';
import 'package:letsmerge/screens/chat/taxi_group_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_dialog.dart';
import 'package:letsmerge/widgets/c_skeleton_loader.dart';
import 'package:letsmerge/widgets/c_tag.dart';

class TaxiGroupPreviewPage extends ConsumerStatefulWidget {
  final TaxiGroup taxiGroup;

  const TaxiGroupPreviewPage({
    super.key,
    required this.taxiGroup,
  });

  @override
  ConsumerState<TaxiGroupPreviewPage> createState() =>
      _TaxiGroupPreviewPageState();
}

class _TaxiGroupPreviewPageState extends ConsumerState<TaxiGroupPreviewPage> {
  NaverMapController? _mapController;
  Position? _currentPosition;
  bool _showSkeleton = true;
  final _mapKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      Position position = await Geolocator.getCurrentPosition();

      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    } catch (e) {
      debugPrint('Error _getCurrentLocation: $e');
    }
  }

  // directionsProvider를 통해 경로 요청하는 함수
  void _fetchDirections() async {
    final directionsNotifier = ref.read(directionsProvider.notifier);

    // 동일한 위치인지 확인 후 경로 요청
    final checkFetchDirections = await directionsNotifier.checkFetchDirections(
      widget.taxiGroup.departureLat,
      widget.taxiGroup.departureLon,
      widget.taxiGroup.arrivalLat,
      widget.taxiGroup.arrivalLon,
    );

    if (!checkFetchDirections) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CDialog(
            title: '출발지와 목적지가 같아요',
            content: Text(
              '확인 후 다시 지정해주세요.',
              style: TextStyle(
                color: ThemeModel.text(ref.read(themeProvider)),
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
                    CupertinoPageRoute(builder: (context) => MainPage()),
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

    // 정상적인 경우 경로 오버레이 추가
    _addPolylineOverlay();
  }

  // 지도에 경로 오버레이 추가 및 카메라 업데이트 함수
  void _addPolylineOverlay() async {
    final routePoints = ref.read(directionsProvider).routePoints;

    if (_mapController != null && routePoints.isNotEmpty) {
      // 기존 오버레이 모두 제거
      await _mapController!.clearOverlays();

      // 경로 오버레이 추가
      await _mapController!.addOverlay(
        NPolylineOverlay(
          id: "directions",
          coords: routePoints,
          color: ThemeModel.text(ref.watch(themeProvider)),
          width: 4,
        ),
      );

      // 모든 좌표를 포함하는 bounds 계산
      final bounds = NLatLngBounds.from(routePoints);

      // padding을 적용하여 bounds 내 영역을 온전히 보여주는 카메라 업데이트 생성
      final cameraUpdate = NCameraUpdate.fitBounds(
        bounds,
        padding: EdgeInsets.all(40),
      );

      await _mapController!.updateCamera(cameraUpdate);

      setState(() {
        _showSkeleton = false;
      });

      debugPrint("경로 오버레이 추가 및 카메라 업데이트");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final taxiGroup = ref.watch(taxiGroupProvider);


    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 지도 영역
                SizedBox(
                  height: 400,
                  child: Stack(
                    children: [
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
                          },
                        ),
                      ),
                      if (_showSkeleton) const CSkeleton(),
                    ],
                  ),
                ),

                SizedBox(
                  height: 16,
                ),

                /// 기본 정보
                TaxiGroupDetailCard(
                  remainingSeats: 3,
                  departurePlace: widget.taxiGroup.departurePlace,
                  departureAdress: widget.taxiGroup.departureAddress,
                  arrivalPlace: widget.taxiGroup.arrivalPlace,
                  arrivalAddress: widget.taxiGroup.arrivalAddress,
                  startTime: widget.taxiGroup.departureTime!,
                ),

                SizedBox(
                  height: 16,
                ),

                /// 참여자 정보
                Container(
                  color: ThemeModel.surface(isDarkMode),
                  width: double.maxFinite,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: ShapeDecoration(
                              color: blue20,
                              shape: CircleBorder(),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            '홍길동',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: ThemeModel.text(isDarkMode),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          CTag(
                            text: '대표',
                            color: TagColor.blue,
                          ),
                          Spacer(),
                          Icon(
                            Icons.star,
                            size: 16,
                            color: ThemeModel.sub2(isDarkMode),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            '4.5/5.0',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: ThemeModel.sub4(isDarkMode),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: ShapeDecoration(
                              color: blue20,
                              shape: CircleBorder(),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            '홍길자',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: ThemeModel.text(isDarkMode),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Spacer(),
                          Icon(
                            Icons.star,
                            size: 16,
                            color: ThemeModel.sub2(isDarkMode),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            '4.5/5.0',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: ThemeModel.sub4(isDarkMode),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: ShapeDecoration(
                              color: blue20,
                              shape: CircleBorder(),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            '홍동',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: ThemeModel.text(isDarkMode),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Spacer(),
                          Icon(
                            Icons.star,
                            size: 16,
                            color: ThemeModel.sub2(isDarkMode),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            '4.5/5.0',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: ThemeModel.sub4(isDarkMode),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 16,
                ),

                /// 비용 정보
                Container(
                  color: ThemeModel.surface(isDarkMode),
                  width: double.maxFinite,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${NumberFormat('#,###', 'ko_KR').format(widget.taxiGroup.estimatedFare)}원 - ?원',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ThemeModel.sub4(isDarkMode),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        '?원 예상',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: ThemeModel.text(isDarkMode),
                        ),
                      ),
                    ],
                  ),
                ),
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
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(builder: (context) => TaxiGroupPage(taxiGroup: widget.taxiGroup)),
                (Route<dynamic> route) => false,
              );
            },
            size: CButtonSize.extraLarge,
            label: '참여 신청',
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
