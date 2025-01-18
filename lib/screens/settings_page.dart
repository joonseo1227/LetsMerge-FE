import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/provider/auth_provider.dart';
import 'package:letsmerge/screens/auth/log_in_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_dialog.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_switch.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 다크 모드
                Container(
                  color: ThemeModel.surface(isDarkMode),
                  child: Column(
                    children: [
                      CInkWell(
                        onTap: () {
                          ref.read(themeProvider.notifier).toggleTheme();
                        },
                        child: Container(
                          color: ThemeModel.surface(isDarkMode),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Text(
                                '다크 모드',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeModel.text(isDarkMode),
                                ),
                              ),
                              const Spacer(),
                              CSwitch(
                                value: isDarkMode,
                                onChanged: (_) {
                                  ref
                                      .read(themeProvider.notifier)
                                      .toggleTheme();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  color: ThemeModel.surface(isDarkMode),
                  child: Column(
                    children: [
                      /// 로그아웃
                      CInkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CDialog(
                                title: '로그아웃',
                                content: '로그아웃하시겠습니까?',
                                buttons: [
                                  CButton(
                                    style: CButtonStyle.secondary(isDarkMode),
                                    size: CButtonSize.extraLarge,
                                    label: '취소',
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  CButton(
                                    size: CButtonSize.extraLarge,
                                    label: '로그아웃',
                                    onTap: () async {
                                      try {
                                        await ref
                                            .read(authProvider.notifier)
                                            .signOut();
                                        if (context.mounted) {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            CupertinoPageRoute(
                                              builder: (context) => LogInPage(),
                                            ),
                                            (Route<dynamic> route) => false,
                                          );
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '로그아웃에 실패했습니다: $e',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          color: ThemeModel.surface(isDarkMode),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Text(
                                '로그아웃',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeModel.text(isDarkMode),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),

                      /// 계정 탈퇴
                      CInkWell(
                        onTap: () {},
                        child: Container(
                          color: ThemeModel.surface(isDarkMode),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Text(
                                '계정 탈퇴',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeModel.text(isDarkMode),
                                ),
                              ),
                              const Spacer(),
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
    );
  }
}
