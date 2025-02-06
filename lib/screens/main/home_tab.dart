import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/geocoding_provider.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/select_place_page.dart';
import 'package:letsmerge/screens/search/search_place_page.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_preview_page.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_detail_card.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final selectedLocation = ref.watch(reverseGeocodingProvider);

    return AnnotatedRegion(
      value: isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
            ),
      child: Scaffold(
        appBar: AppBar(
          title: SizedBox(
            width: 32,
            height: 32,
            child: isDarkMode
                ? SvgPicture.asset('assets/imgs/logo_grey10.svg')
                : SvgPicture.asset('assets/imgs/logo_grey100.svg'),
          ),
          actions: [
            CInkWell(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => SearchPlacePage(),
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: ThemeModel.surface(isDarkMode),
                    width: double.maxFinite,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                            Expanded(
                              child: CInkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (context) => SelectPlacePage(
                                          mode: GeocodingMode.departure),
                                    ),
                                  );
                                },
                                child: Text(
                                  selectedLocation[GeocodingMode.departure]
                                              ?.place ==
                                          null
                                      ? "출발지 선택"
                                      : selectedLocation[
                                              GeocodingMode.departure]!
                                          .place,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: selectedLocation[
                                                    GeocodingMode.departure]
                                                ?.place ==
                                            null
                                        ? ThemeModel.hintText(isDarkMode)
                                        : ThemeModel.text(isDarkMode),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32, 8, 0, 8),
                          child: Divider(
                            color: ThemeModel.sub1(isDarkMode),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                            Expanded(
                              child: CInkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (context) => SelectPlacePage(
                                          mode: GeocodingMode.destination),
                                    ),
                                  );
                                },
                                child: Text(
                                  selectedLocation[GeocodingMode.destination]
                                              ?.place ==
                                          null
                                      ? "목적지 선택"
                                      : selectedLocation[
                                              GeocodingMode.destination]!
                                          .place,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: selectedLocation[
                                                    GeocodingMode.destination]
                                                ?.place ==
                                            null
                                        ? ThemeModel.hintText(isDarkMode)
                                        : ThemeModel.text(isDarkMode),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    '내 근처 택시팟',
                    style: TextStyle(
                      color: ThemeModel.text(isDarkMode),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CInkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => TaxiGroupPreviewPage(),
                        ),
                      );
                    },
                    child: TaxiGroupDetailCard(
                      remainingSeats: 1,
                      closingTime: 5,
                      startLocation: '가천대역 수인분당선',
                      startTime: '10:30',
                      startWalkingTime: 3,
                      destinationLocation: '가천대학교 AI관',
                      destinationTime: '10:35',
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CInkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => TaxiGroupPreviewPage(),
                        ),
                      );
                    },
                    child: TaxiGroupDetailCard(
                      remainingSeats: 3,
                      closingTime: 5,
                      startLocation: '가천대역 수인분당선',
                      startTime: '10:30',
                      startWalkingTime: 3,
                      destinationLocation: '가천대학교 AI관',
                      destinationTime: '10:35',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
