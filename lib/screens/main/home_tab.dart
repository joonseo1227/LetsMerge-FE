import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/screens/dev_page.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: Container(
                    padding: EdgeInsets.all(16),
                    color: white,
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: grey100,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          '목적지 검색',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: grey50,
                          ),
                        ),
                      ],
                    ),
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
                                color: grey90,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                '집',
                                style: TextStyle(
                                  color: grey90,
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
                          color: grey30,
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
                                color: grey90,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                '회사',
                                style: TextStyle(
                                  color: grey90,
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
                          color: grey30,
                        ),
                      ),
                      CInkWell(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            '가천대학교 AI관',
                            style: TextStyle(
                              color: grey90,
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
                          color: grey30,
                        ),
                      ),
                      CInkWell(
                        onTap: () {},
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            '가천대역 수인분당선',
                            style: TextStyle(
                              color: grey90,
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
                  height: 32,
                ),

                /// DEV 버튼
                CInkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DevPage(),
                      ),
                    );
                  },
                  child: Container(
                    color: white,
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
                            color: grey100,
                          ),
                        ),
                        Spacer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                              decoration: ShapeDecoration(
                                color: blue20,
                                shape: StadiumBorder(),
                              ),
                              child: Text(
                                'DEV',
                                style: TextStyle(
                                  color: blue70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.navigate_next,
                              color: grey100,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 16,
                ),

                /// 예약하기 버튼
                CInkWell(
                  onTap: () {},
                  child: Container(
                    color: white,
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
                            color: grey100,
                          ),
                        ),
                        Spacer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                              decoration: ShapeDecoration(
                                color: green20,
                                shape: StadiumBorder(),
                              ),
                              child: Text(
                                'NEW',
                                style: TextStyle(
                                  color: green70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.navigate_next,
                              color: grey100,
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
    );
  }
}
