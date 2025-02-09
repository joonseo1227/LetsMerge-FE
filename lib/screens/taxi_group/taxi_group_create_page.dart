import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/directions_provider.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/provider/geocoding_provider.dart';
import 'package:letsmerge/screens/main/main_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_datetime_picker.dart';
import 'package:letsmerge/widgets/c_dialog.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_popup_menu.dart';
import 'package:letsmerge/widgets/c_skeleton_loader.dart';
import 'package:letsmerge/widgets/c_text_field.dart';

class TaxiGroupCreatePage extends ConsumerStatefulWidget {
  const TaxiGroupCreatePage({super.key});

  @override
  ConsumerState<TaxiGroupCreatePage> createState() =>
      _TaxiGroupCreatePageState();
}

class _TaxiGroupCreatePageState extends ConsumerState<TaxiGroupCreatePage> {
  NaverMapController? _mapController;
  bool _showSkeleton = true;
  final _mapKey = UniqueKey();
  final TextEditingController _clothingController = TextEditingController();
  final GlobalKey<CPopupMenuState> popupMenuKey = GlobalKey<CPopupMenuState>();
  final List<String> _clothingTags = [];
  int? selectedMemberCount;
  DateTime? selectedDateTime;

  // 옷차림 태그 추가 함수
  void _addClothingTag(String tag) {
    if (tag.isNotEmpty && !_clothingTags.contains(tag)) {
      setState(() {
        _clothingTags.add(tag);
      });
      _clothingController.clear();
    }
  }

  // 옷차림 태그 제거 함수
  void _removeClothingTag(String tag) {
    setState(() {
      _clothingTags.remove(tag);
    });
  }

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

      debugPrint("경로 오버레이 추가 및 카메라 업데이트");
    }
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

    // directionsProvider 상태 변경 시 지도 오버레이를 업데이트합니다.
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

                              await Future.delayed(
                                const Duration(milliseconds: 800),
                              );
                              if (mounted) {
                                setState(() {
                                  _showSkeleton = false;
                                });
                              }
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
                              Text(
                                selectedLocations[GeocodingMode.departure]!
                                    .place,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeModel.text(isDarkMode),
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
                              Text(
                                selectedLocations[GeocodingMode.destination]!
                                    .place,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeModel.text(isDarkMode),
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
                                const SizedBox(
                                  height: 4,
                                ),
                                if (selectedMemberCount != null &&
                                    taxiFare != null)
                                  Text(
                                    // 인원수에 따라 택시비 분할
                                    "1인당 ${NumberFormat('#,###', 'ko_KR').format((taxiFare / (selectedMemberCount! + 1)).round())}원",
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
                        color: ThemeModel.text(isDarkMode),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      color: ThemeModel.surface(isDarkMode),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(3, (index) {
                          final count = index + 1;
                          final isSelected = selectedMemberCount == count;

                          return Expanded(
                            child: CButton(
                              style: isSelected
                                  ? CButtonStyle.primary(isDarkMode)
                                  : CButtonStyle.ghost(isDarkMode),
                              onTap: () {
                                setState(() {
                                  selectedMemberCount = count;
                                });
                              },
                              label: '$count명',
                            ),
                          );
                        }),
                      ),
                    ),
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
                        color: ThemeModel.text(isDarkMode),
                      ),
                    ),
                    const SizedBox(height: 4),
                    CDateTimePicker(
                      onDateTimeSelected: (dateTime) {
                        setState(() {
                          selectedDateTime = dateTime;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 내 옷차림 입력 영역
                Text(
                  '내 옷차림',
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeModel.text(isDarkMode),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CTextField(
                        hint: "예: 검정 코트, 청바지",
                        controller: _clothingController,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 태그 추가 버튼
                    CButton(
                      onTap: () {
                        _addClothingTag(_clothingController.text.trim());
                      },
                      style: CButtonStyle.secondary(isDarkMode),
                      icon: Icons.add,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "옷차림은 다른 사람이 알아보기 쉽게 작성해 주세요.",
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeModel.highlightText(isDarkMode),
                  ),
                ),
                const SizedBox(height: 16),
                // 옷차림 태그 리스트
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 8,
                    children: _clothingTags.map(
                      (tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: ShapeDecoration(
                            color: ThemeModel.surface(isDarkMode),
                            shape: const StadiumBorder(),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                tag,
                                style: TextStyle(
                                  color: ThemeModel.text(isDarkMode),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              CInkWell(
                                onTap: () => _removeClothingTag(tag),
                                child: Icon(
                                  Icons.close,
                                  size: 18,
                                  color: ThemeModel.text(isDarkMode),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ).toList(),
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
              Navigator.pop(context);
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
