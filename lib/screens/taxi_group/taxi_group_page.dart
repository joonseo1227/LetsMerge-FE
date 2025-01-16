import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_detail_card.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_split_money_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_popup_menu.dart';
import 'package:letsmerge/widgets/c_skeleton_loader.dart';
import 'package:letsmerge/widgets/c_tag.dart';

class TaxiGroupPage extends ConsumerStatefulWidget {
  const TaxiGroupPage({super.key});

  @override
  ConsumerState<TaxiGroupPage> createState() => _MapTabState();
}

class _MapTabState extends ConsumerState<TaxiGroupPage> {
  NaverMapController? _mapController;
  Position? _currentPosition;
  bool _showSkeleton = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // 내 위치 가져오기
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

      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: CInkWell(
          onTap: () {},
          child: SizedBox(
            width: 32,
            height: 32,
            child: Icon(
              Icons.close,
              size: 24,
              color: ThemeModel.text(isDarkMode),
            ),
          ),
        ),
        actions: [
          CPopupMenu(
            button: SizedBox(
              width: 32,
              height: 32,
              child: Icon(
                Icons.more_vert,
                size: 24,
                color: ThemeModel.text(isDarkMode),
              ),
            ),
            dropdownWidth: 200,
            dropdown: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CInkWell(
                  onTap: () {},
                  child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      size: 24,
                      color: ThemeModel.text(isDarkMode),
                    ),
                    title: Text(
                      '그룹 나가기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ThemeModel.text(isDarkMode),
                      ),
                    ),
                  ),
                ),
                CInkWell(
                  onTap: () {},
                  child: ListTile(
                    leading: Icon(
                      Icons.flag_outlined,
                      size: 24,
                      color: ThemeModel.text(isDarkMode),
                    ),
                    title: Text(
                      '신고',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ThemeModel.text(isDarkMode),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 16,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 지도
                SizedBox(
                  height: 400,
                  child: Stack(children: [
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
                            controller.setLocationTrackingMode(
                                NLocationTrackingMode.follow);
                            Future.delayed(const Duration(milliseconds: 800),
                                () {
                              setState(() {
                                _showSkeleton = false;
                              });
                            });
                          },
                        ),
                      ),
                    if (_showSkeleton) const CSkeleton(),
                  ]),
                ),

                SizedBox(
                  height: 16,
                ),

                /// 기본 정보
                TaxiGroupDetailCard(
                  remainingSeats: 1,
                  closingTime: 5,
                  startLocation: '가천대역 수인분당선',
                  startTime: '10:30',
                  startWalkingTime: 3,
                  destinationLocation: '가천대학교 AI관',
                  destinationTime: '10:35',
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
                              color: ThemeModel.sub3(isDarkMode),
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
                              color: ThemeModel.sub3(isDarkMode),
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
                              color: ThemeModel.sub3(isDarkMode),
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
                        '4,800원 - 3,200원',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ThemeModel.sub3(isDarkMode),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        '1,600원 예상',
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
        color: blue60,
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: SafeArea(
          child: CButton(
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => TaxiGroupSplitMoneyPage(),
                ),
              );
            },
            label: '정산하기',
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
