import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/customer_support_page.dart';
import 'package:letsmerge/screens/dev/dev_page.dart';
import 'package:letsmerge/screens/history_page.dart';
import 'package:letsmerge/screens/my_account_number_page.dart';
import 'package:letsmerge/screens/profile_page.dart';
import 'package:letsmerge/screens/settings_page.dart';
import 'package:letsmerge/screens/terms_and_policies_page.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AllTab extends ConsumerStatefulWidget {
  const AllTab({super.key});

  @override
  ConsumerState<AllTab> createState() => _AllTabState();
}

class _AllTabState extends ConsumerState<AllTab> {
  final supabase = Supabase.instance.client;

  String? userName() {
    final User? user = supabase.auth.currentUser;
    final Map<String, dynamic>? metadata = user?.userMetadata;
    return metadata?['name'];
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return AnnotatedRegion(
      value: isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
            ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('전체'),
          actions: [
            CInkWell(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => SettingsPage(),
                  ),
                );
              },
              child: SizedBox(
                width: 32,
                height: 32,
                child: Icon(
                  Icons.settings,
                  size: 28,
                  color: ThemeModel.sub3(isDarkMode),
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
                children: [
                  CInkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => ProfilePage(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      color: ThemeModel.surface(isDarkMode),
                      child: Row(
                        children: [
                          Container(
                            height: 64,
                            width: 64,
                            decoration: ShapeDecoration(
                              color: blue20,
                              shape: CircleBorder(),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            userName() ?? '사용자 이름 없음',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: ThemeModel.text(isDarkMode),
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.navigate_next,
                            color: ThemeModel.sub3(isDarkMode),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    color: ThemeModel.surface(isDarkMode),
                    child: Column(
                      children: [
                        /// DEV
                        CInkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => DevPage(),
                              ),
                            );
                          },
                          child: Container(
                            color: ThemeModel.surface(isDarkMode),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.code,
                                  size: 24,
                                  color: ThemeModel.sub4(isDarkMode),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  'DEV',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeModel.text(isDarkMode),
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.navigate_next,
                                  color: ThemeModel.sub3(isDarkMode),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    color: ThemeModel.surface(isDarkMode),
                    child: Column(
                      children: [
                        /// 내 계좌번호
                        CInkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => MyAccountNumberPage(),
                              ),
                            );
                          },
                          child: Container(
                            color: ThemeModel.surface(isDarkMode),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.wallet,
                                  size: 24,
                                  color: ThemeModel.sub4(isDarkMode),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  '내 계좌번호',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeModel.text(isDarkMode),
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.navigate_next,
                                  color: ThemeModel.sub3(isDarkMode),
                                ),
                              ],
                            ),
                          ),
                        ),

                        /// 이용 내역
                        CInkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => HistoryPage(),
                              ),
                            );
                          },
                          child: Container(
                            color: ThemeModel.surface(isDarkMode),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.receipt,
                                  size: 24,
                                  color: ThemeModel.sub4(isDarkMode),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  '이용 내역',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeModel.text(isDarkMode),
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.navigate_next,
                                  color: ThemeModel.sub3(isDarkMode),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    color: ThemeModel.surface(isDarkMode),
                    child: Column(
                      children: [
                        /// 고객 지원
                        CInkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => CustomerSupportPage(),
                              ),
                            );
                          },
                          child: Container(
                            color: ThemeModel.surface(isDarkMode),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.help,
                                  size: 24,
                                  color: ThemeModel.sub4(isDarkMode),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  '고객 지원',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeModel.text(isDarkMode),
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.navigate_next,
                                  color: ThemeModel.sub3(isDarkMode),
                                ),
                              ],
                            ),
                          ),
                        ),

                        /// 약관 및 정책
                        CInkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => TermsAndPoliciesPage(),
                              ),
                            );
                          },
                          child: Container(
                            color: ThemeModel.surface(isDarkMode),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info,
                                  size: 24,
                                  color: ThemeModel.sub4(isDarkMode),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  '약관 및 정책',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeModel.text(isDarkMode),
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.navigate_next,
                                  color: ThemeModel.sub3(isDarkMode),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
