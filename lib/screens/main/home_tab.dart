import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/dev_page.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_search_bar.dart';
import 'package:letsmerge/widgets/c_tag.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return AnnotatedRegion(
      value:
          isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 목적지 검색
                  CInkWell(
                    onTap: () {},
                    child: CSearchBar(
                      hint: '목적지 검색',
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CInkWell(
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.home,
                                  size: 20,
                                  color: ThemeModel.sub5(isDarkMode),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  '집',
                                  style: TextStyle(
                                    color: ThemeModel.sub5(isDarkMode),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                          child: VerticalDivider(
                            thickness: 1,
                            color: ThemeModel.sub2(isDarkMode),
                          ),
                        ),
                        CInkWell(
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.apartment,
                                  size: 20,
                                  color: ThemeModel.sub5(isDarkMode),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  '회사',
                                  style: TextStyle(
                                    color: ThemeModel.sub5(isDarkMode),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                          child: VerticalDivider(
                            thickness: 1,
                            color: ThemeModel.sub2(isDarkMode),
                          ),
                        ),
                        CInkWell(
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              '가천대학교 AI관',
                              style: TextStyle(
                                color: ThemeModel.sub5(isDarkMode),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                          child: VerticalDivider(
                            thickness: 1,
                            color: ThemeModel.sub2(isDarkMode),
                          ),
                        ),
                        CInkWell(
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              '가천대역 수인분당선',
                              style: TextStyle(
                                color: ThemeModel.sub5(isDarkMode),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 16,
                  ),

                  Row(
                    children: [
                      /// DEV 버튼
                      Expanded(
                        child: CInkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DevPage(),
                              ),
                            );
                          },
                          child: Container(
                            color: ThemeModel.surface(isDarkMode),
                            height: 120,
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'DEV',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeModel.text(isDarkMode),
                                  ),
                                ),
                                Spacer(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CTag(
                                      text: 'DEV',
                                      color: TagColor.blue,
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.navigate_next,
                                      color: ThemeModel.text(isDarkMode),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        width: 8,
                      ),

                      /// 예약하기 버튼
                      Expanded(
                        child: CInkWell(
                          onTap: () {},
                          child: Container(
                            color: ThemeModel.surface(isDarkMode),
                            height: 120,
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '예약하기',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeModel.text(isDarkMode),
                                  ),
                                ),
                                Spacer(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CTag(
                                      text: 'NEW',
                                      color: TagColor.green,
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.navigate_next,
                                      color: ThemeModel.text(isDarkMode),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 8,
                  ),

                  Row(
                    children: [
                      /// TEMP 버튼
                      Expanded(
                        child: CInkWell(
                          onTap: () {},
                          child: Container(
                            color: ThemeModel.surface(isDarkMode),
                            height: 120,
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TEMP',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeModel.text(isDarkMode),
                                  ),
                                ),
                                Spacer(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CTag(
                                      text: 'NEW',
                                      color: TagColor.green,
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.navigate_next,
                                      color: ThemeModel.text(isDarkMode),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        width: 8,
                      ),

                      /// TEMP 버튼
                      Expanded(
                        child: CInkWell(
                          onTap: () {},
                          child: Container(
                            color: ThemeModel.surface(isDarkMode),
                            height: 120,
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'TEMP',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeModel.text(isDarkMode),
                                  ),
                                ),
                                Spacer(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CTag(
                                      text: 'NEW',
                                      color: TagColor.green,
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.navigate_next,
                                      color: ThemeModel.text(isDarkMode),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
                    onTap: () {},
                    child: Container(
                      color: ThemeModel.surface(isDarkMode),
                      width: double.maxFinite,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '1자리 남음',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeModel.sub3(isDarkMode),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                                child: VerticalDivider(
                                  thickness: 1,
                                  color: ThemeModel.sub2(isDarkMode),
                                ),
                              ),
                              Text(
                                '5분 후 마감',
                                style: TextStyle(
                                  fontSize: 14,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                margin: EdgeInsets.all(6),
                                decoration: ShapeDecoration(
                                  color: ThemeModel.sub2(isDarkMode),
                                  shape: CircleBorder(),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '가천대역 수인분당선',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: ThemeModel.text(isDarkMode),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.access_time_filled,
                                        size: 14,
                                        color: ThemeModel.sub2(isDarkMode),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '10:30',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: ThemeModel.sub3(isDarkMode),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                        child: VerticalDivider(
                                          thickness: 1,
                                          color: ThemeModel.sub2(isDarkMode),
                                        ),
                                      ),
                                      Text(
                                        '현재 위치에서 도보 3분',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: ThemeModel.sub3(isDarkMode),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                margin: EdgeInsets.all(6),
                                decoration: ShapeDecoration(
                                  color: ThemeModel.highlight(isDarkMode),
                                  shape: CircleBorder(),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '가천대학교 AI관',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: ThemeModel.text(isDarkMode),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.access_time_filled,
                                        size: 14,
                                        color: ThemeModel.sub2(isDarkMode),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '10:35',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: ThemeModel.sub3(isDarkMode),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 8,
                  ),

                  CInkWell(
                    onTap: () {},
                    child: Container(
                      color: ThemeModel.surface(isDarkMode),
                      width: double.maxFinite,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '1자리 남음',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeModel.sub3(isDarkMode),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                                child: VerticalDivider(
                                  thickness: 1,
                                  color: ThemeModel.sub2(isDarkMode),
                                ),
                              ),
                              Text(
                                '5분 후 마감',
                                style: TextStyle(
                                  fontSize: 14,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                margin: EdgeInsets.all(6),
                                decoration: ShapeDecoration(
                                  color: ThemeModel.sub2(isDarkMode),
                                  shape: CircleBorder(),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '가천대역 수인분당선',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: ThemeModel.text(isDarkMode),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.access_time_filled,
                                        size: 14,
                                        color: ThemeModel.sub2(isDarkMode),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '10:30',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: ThemeModel.sub3(isDarkMode),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                        child: VerticalDivider(
                                          thickness: 1,
                                          color: ThemeModel.sub2(isDarkMode),
                                        ),
                                      ),
                                      Text(
                                        '현재 위치에서 도보 3분',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: ThemeModel.sub3(isDarkMode),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                margin: EdgeInsets.all(6),
                                decoration: ShapeDecoration(
                                  color: ThemeModel.highlight(isDarkMode),
                                  shape: CircleBorder(),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '가천대학교 AI관',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: ThemeModel.text(isDarkMode),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.access_time_filled,
                                        size: 14,
                                        color: ThemeModel.sub2(isDarkMode),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '10:35',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: ThemeModel.sub3(isDarkMode),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
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
