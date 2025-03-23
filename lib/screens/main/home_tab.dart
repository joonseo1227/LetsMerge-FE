import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/geocoding_provider.dart';
import 'package:letsmerge/provider/taxi_group_fetch_notifier.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/provider/user_fetch_notifier.dart';
import 'package:letsmerge/screens/chat/taxi_group_page.dart';
import 'package:letsmerge/screens/search/search_taxi_group_page.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_detail_card.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_preview_page.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_select_place_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_dialog.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  final User? user = Supabase.instance.client.auth.currentUser;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final selectedLocation = ref.watch(reverseGeocodingProvider);
    final taxiGroups = ref.watch(taxiGroupsProvider(user?.id ?? ''));

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
                    builder: (context) => SearchTaxiGroupPage(),
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
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: ThemeModel.surface(isDarkMode),
                        width: double.maxFinite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CInkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        TaxiGroupSelectPlacePage(
                                      mode: GeocodingMode.departure,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
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
                                      child: Text(
                                        selectedLocation[
                                                        GeocodingMode.departure]
                                                    ?.place ==
                                                null
                                            ? "출발지 선택"
                                            : selectedLocation[
                                                    GeocodingMode.departure]!
                                                .place,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: selectedLocation[GeocodingMode
                                                          .departure]
                                                      ?.place ==
                                                  null
                                              ? ThemeModel.hintText(isDarkMode)
                                              : ThemeModel.text(isDarkMode),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              indent: 48,
                              endIndent: 16,
                            ),
                            CInkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        TaxiGroupSelectPlacePage(
                                      mode: GeocodingMode.destination,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
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
                                      child: Text(
                                        selectedLocation[GeocodingMode
                                                        .destination]
                                                    ?.place ==
                                                null
                                            ? "목적지 선택"
                                            : selectedLocation[
                                                    GeocodingMode.destination]!
                                                .place,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: selectedLocation[GeocodingMode
                                                          .destination]
                                                      ?.place ==
                                                  null
                                              ? ThemeModel.hintText(isDarkMode)
                                              : ThemeModel.text(isDarkMode),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                      // 택시 그룹 리스트
                      if (taxiGroups.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text(
                              '아직 모집 중인 택시팟이 없습니다',
                              style: TextStyle(
                                color: ThemeModel.text(isDarkMode),
                              ),
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: taxiGroups.length,
                          itemBuilder: (context, index) {
                            final group = taxiGroups[index];
                            final participants =
                                ref.watch(participantsProvider(group));
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: CInkWell(
                                onTap: () {
                                  if (group.remainingSeats == 0) {
                                    bool isParticipant =
                                        participants.any((participant) {
                                      final userinfo = ref.watch(
                                          userInfoProvider(participant.userId));
                                      return userinfo.userId == user!.id ||
                                          group.creatorUserId == user!.id;
                                    });

                                    if (isParticipant) {
                                      Navigator.of(context).push(
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              TaxiGroupPreviewPage(
                                                  taxiGroup: group),
                                        ),
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CDialog(
                                            title: '안내',
                                            content: Text(
                                              '그룹 인원이 가득 찼어요.',
                                              style: TextStyle(
                                                color:
                                                    ThemeModel.text(isDarkMode),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            buttons: [
                                              CButton(
                                                size: CButtonSize.extraLarge,
                                                label: '확인',
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  } else {
                                    Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                            TaxiGroupPreviewPage(
                                                taxiGroup: group),
                                      ),
                                    );
                                  }
                                },
                                child: TaxiGroupDetailCard(
                                  remainingSeats: group.remainingSeats,
                                  departurePlace: group.departurePlace,
                                  departureAdress: group.departureAddress,
                                  arrivalPlace: group.arrivalPlace,
                                  arrivalAddress: group.arrivalAddress,
                                  startTime: group.departureTime,
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),

            /// 참여 중인 택시팟 카드
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Builder(
                builder: (context) {
                  // 사용자가 참여 중인 택시팟 가져오기
                  final userTaxiGroups = taxiGroups.where((group) {
                    final participants = ref.watch(participantsProvider(group));
                    return participants.any(
                            (participant) => participant.userId == user?.id) ||
                        group.creatorUserId == user?.id;
                  }).toList();

                  // 참여 중인 택시팟이 없으면 카드를 표시하지 않음
                  if (userTaxiGroups.isEmpty) {
                    return SizedBox.shrink();
                  }

                  // 가장 최근 택시팟 가져오기
                  final latestGroup = userTaxiGroups[0];

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  TaxiGroupPage(
                            taxiGroup: latestGroup,
                          ),
                        ),
                        (route) => false,
                      );
                    },
                    child: Hero(
                      tag: 'taxiGroup',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Container(
                          width: double.maxFinite,
                          color: ThemeModel.highlight(isDarkMode)
                              .withValues(alpha: 0.9),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '참여 중',
                                style: TextStyle(
                                  color: white,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${latestGroup.departurePlace} -> ${latestGroup.arrivalPlace}',
                                style: TextStyle(
                                  color: white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}
