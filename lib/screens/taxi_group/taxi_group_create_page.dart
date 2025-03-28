import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:letsmerge/models/taxi_group/taxi_group.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/directions_provider.dart';
import 'package:letsmerge/provider/geocoding_provider.dart';
import 'package:letsmerge/provider/group_provider.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/main/main_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_datetime_picker.dart';
import 'package:letsmerge/widgets/c_dialog.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_popup_menu.dart';
import 'package:letsmerge/widgets/c_skeleton_loader.dart';
import 'package:letsmerge/widgets/c_toggle_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaxiGroupCreatePage extends ConsumerStatefulWidget {
  const TaxiGroupCreatePage({super.key});

  @override
  ConsumerState<TaxiGroupCreatePage> createState() =>
      _TaxiGroupCreatePageState();
}

class _TaxiGroupCreatePageState extends ConsumerState<TaxiGroupCreatePage> {
  NaverMapController? _mapController;
  bool _showSkeleton = true;
  final SupabaseClient _supabase = Supabase.instance.client;
  final _mapKey = UniqueKey();
  final TextEditingController _clothingController = TextEditingController();
  final GlobalKey<CPopupMenuState> popupMenuKey = GlobalKey<CPopupMenuState>();
  int selectedMemberCount = 3;
  DateTime? selectedDateTime;

  // 에러 메시지 표시 여부 (출발 시각 미선택 시)
  bool _showDateTimeError = false;

  // directionsProvider를 통해 경로 요청하는 함수
  void _fetchDirections() async {
    final selectedLocations = ref.read(reverseGeocodingProvider);
    final directionsNotifier = ref.read(directionsProvider.notifier);

    final departure = selectedLocations[GeocodingMode.departure];
    final destination = selectedLocations[GeocodingMode.destination];

    if (departure == null || destination == null) {
      debugPrint("출발지 또는 목적지 정보가 없음.");
      return;
    }

    // 동일한 위치인지 확인 후 경로 요청
    final checkFetchDirections = await directionsNotifier.checkFetchDirections(
      departure.latitude,
      departure.longitude,
      destination.latitude,
      destination.longitude,
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

  Future<void> submitTaxiGroup(WidgetRef ref) async {
    final directionsState = ref.watch(directionsProvider);
    final User? user = _supabase.auth.currentUser;
    final taxiFare = directionsState.taxiFare;

    final geocodingData = ref.read(reverseGeocodingProvider);
    final departureData = geocodingData[GeocodingMode.departure];
    final destinationData = geocodingData[GeocodingMode.destination];

    if (departureData == null || destinationData == null) {
      debugPrint('출발지 또는 도착지 정보가 누락되었습니다.');
      return;
    }

    final taxiGroup = TaxiGroup(
      creatorUserId: user!.id,
      departurePlace: departureData.place,
      departureAddress: departureData.address,
      departureLat: departureData.latitude,
      departureLon: departureData.longitude,
      arrivalPlace: destinationData.place,
      arrivalAddress: destinationData.address,
      arrivalLat: destinationData.latitude,
      arrivalLon: destinationData.longitude,
      estimatedFare: taxiFare!,
      departureTime: selectedDateTime!,
      remainingSeats: selectedMemberCount,
    );

    await ref.read(taxiGroupProvider.notifier).createTaxiGroup(taxiGroup);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final selectedLocations = ref.watch(reverseGeocodingProvider);
    final directionsState = ref.watch(directionsProvider);
    final taxiFare = directionsState.taxiFare;
    final formattedTaxiFare = taxiFare != null
        ? NumberFormat('#,###', 'ko_KR').format(taxiFare)
        : '-';
    final fareMoney = (taxiFare != null)
        ? NumberFormat('#,###', 'ko_KR')
            .format((taxiFare / selectedMemberCount).round())
        : '-';

    // directionsProvider 상태 변경 시 지도 오버레이를 업데이트
    ref.listen<DirectionsState>(directionsProvider, (prev, next) {
      _addPolylineOverlay();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("택시팟 생성"),
        titleSpacing: 0,
        leading: CInkWell(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(builder: (context) => MainPage()),
              (Route<dynamic> route) => false,
            );
          },
          child: SizedBox(
            width: 32,
            height: 32,
            child: Icon(
              Icons.close,
              size: 28,
              color: ThemeModel.text(isDarkMode),
            ),
          ),
        ),
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
                      if (selectedLocations[GeocodingMode.departure] != null &&
                          selectedLocations[GeocodingMode.destination] != null)
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

                SizedBox(height: 16),

                // 출발지와 목적지 정보 영역
                Container(
                  color: ThemeModel.surface(isDarkMode),
                  width: double.maxFinite,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.all(6),
                                decoration: ShapeDecoration(
                                  color: ThemeModel.sub2(isDarkMode),
                                  shape: const CircleBorder(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Text(
                                  selectedLocations[GeocodingMode.departure]!
                                      .place,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeModel.text(isDarkMode),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 32),
                              Flexible(
                                child: Text(
                                  selectedLocations[GeocodingMode.departure]!
                                      .address,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeModel.sub4(isDarkMode),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.all(6),
                                decoration: ShapeDecoration(
                                  color: ThemeModel.highlight(isDarkMode),
                                  shape: const CircleBorder(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Text(
                                  selectedLocations[GeocodingMode.destination]!
                                      .place,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeModel.text(isDarkMode),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 32),
                              Flexible(
                                child: Text(
                                  selectedLocations[GeocodingMode.destination]!
                                      .address,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeModel.sub4(isDarkMode),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// 비용 정보 영역
                Container(
                  color: ThemeModel.surface(isDarkMode),
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "예상 택시비",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ThemeModel.sub4(isDarkMode),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Stack(
                        children: [
                          AnimatedOpacity(
                            opacity:
                                _showSkeleton || taxiFare == null ? 0.0 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$formattedTaxiFare원",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeModel.text(isDarkMode),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (taxiFare != null)
                                  Text(
                                    "1인당 $fareMoney원",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          ThemeModel.highlightText(isDarkMode),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (_showSkeleton || taxiFare == null)
                            SizedBox(
                              height: 32,
                              child: const CSkeleton(),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 모집 인원 선택 영역
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '모집 인원',
                      style: TextStyle(
                        fontSize: 14,
                        color: ThemeModel.sub6(isDarkMode),
                      ),
                    ),
                    const SizedBox(height: 4),
                    CToggleButton(
                      buttonCount: 3,
                      initialSelectedIndex: selectedMemberCount - 1,
                      labels: ['1명', '2명', '3명'],
                      onToggle: (index) {
                        setState(() {
                          selectedMemberCount = index + 1;
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(height: 16),

                // 출발 시각 선택 영역
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '출발 시각',
                      style: TextStyle(
                        fontSize: 14,
                        color: ThemeModel.sub6(isDarkMode),
                      ),
                    ),
                    const SizedBox(height: 4),
                    CDateTimePicker(
                      error: selectedDateTime == null && _showDateTimeError,
                      errorText: "출발 시각을 선택해주세요.",
                      onDateTimeSelected: (dateTime) {
                        setState(() {
                          selectedDateTime = dateTime;
                          _showDateTimeError = false;
                        });
                      },
                    ),
                  ],
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
            onTap: () async {
              if (selectedDateTime == null) {
                setState(() {
                  _showDateTimeError = true;
                });
                return;
              }
              await submitTaxiGroup(ref);
              Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(
                  builder: (context) => MainPage(),
                ),
                (Route<dynamic> route) => false,
              );
            },
            size: CButtonSize.extraLarge,
            label: '택시팟 만들기',
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
    _clothingController.dispose();
    super.dispose();
  }
}
