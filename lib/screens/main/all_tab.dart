import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/account_number/my_account_number_page.dart';
import 'package:letsmerge/screens/customer_support/customer_support_page.dart';
import 'package:letsmerge/screens/dev/dev_page.dart';
import 'package:letsmerge/screens/history_page.dart';
import 'package:letsmerge/screens/profile_page.dart';
import 'package:letsmerge/screens/settings_page.dart';
import 'package:letsmerge/screens/terms_and_policies_page.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_list_tile.dart';
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
                  CListTile(
                    leading: Container(
                      height: 64,
                      width: 64,
                      decoration: ShapeDecoration(
                        color: blue20,
                        shape: CircleBorder(),
                      ),
                    ),
                    label: userName() ?? '사용자 이름 없음',
                    subtitle: 'asdf',
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => ProfilePage(),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  CListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => DevPage(),
                        ),
                      );
                    },
                    label: 'DEV',
                    icon: Icons.code,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  CListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => MyAccountNumberPage(),
                        ),
                      );
                    },
                    label: '내 계좌번호',
                    icon: Icons.wallet,
                  ),
                  CListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => HistoryPage(),
                        ),
                      );
                    },
                    label: '이용 내역',
                    icon: Icons.receipt,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  CListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => CustomerSupportPage(),
                        ),
                      );
                    },
                    label: '고객 지원',
                    icon: Icons.help,
                  ),
                  CListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => TermsAndPoliciesPage(),
                        ),
                      );
                    },
                    label: '약관 및 정책',
                    icon: Icons.info,
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
