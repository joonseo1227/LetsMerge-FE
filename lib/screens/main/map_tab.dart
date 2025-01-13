import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';

class MapTab extends ConsumerStatefulWidget {
  const MapTab({super.key});

  @override
  ConsumerState<MapTab> createState() => _MapTabState();
}

class _MapTabState extends ConsumerState<MapTab> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      body: Stack(
        children: [
          NaverMap(
            options: NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                target: NLatLng(37.451039959670574, 127.12875330395157),
                // 초기 위치
                zoom: 15.2, // 초기 줌 레벨
              ),
              locationButtonEnable: true
            ),
            onMapReady: (controller) {
              debugPrint('Naver Map is ready');
              controller.setLocationTrackingMode(NLocationTrackingMode.follow);
            },
          ),
          SafeArea(
            child: DraggableScrollableSheet(
              initialChildSize: 0.1,
              minChildSize: 0.1,
              maxChildSize: 1,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Stack(
                  children: [
                    // 그림자 효과를 위한 장식용 Container
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: black.withAlpha(20),
                            blurRadius: 16,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    // 실제 내용을 담는 Container
                    Container(
                      decoration: BoxDecoration(
                        color: ThemeModel.surface(isDarkMode),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            decoration: ShapeDecoration(
                              color: ThemeModel.sub2(isDarkMode),
                              shape: StadiumBorder(),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: 10,
                              itemBuilder: (BuildContext context, int index) {
                                return CInkWell(
                                  onTap: () {
                                    debugPrint('옵션 $index 클릭됨');
                                  },
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.place,
                                      color: ThemeModel.text(isDarkMode),
                                    ),
                                    title: Text(
                                      '옵션 $index',
                                      style: TextStyle(
                                        color: ThemeModel.text(isDarkMode),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
