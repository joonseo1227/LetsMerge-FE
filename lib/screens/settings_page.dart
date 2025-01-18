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
import 'package:letsmerge/widgets/c_text_field.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  Future<String> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return '${packageInfo.version} (${packageInfo.buildNumber})';
  }

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
                Container(
                  color: ThemeModel.surface(isDarkMode),
                  child: Column(
                    children: [
                      /// 다크 모드
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
                      /// 앱 버전
                      FutureBuilder<String>(
                        future: _getAppVersion(),
                        builder: (context, snapshot) {
                          String versionText = '';
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              versionText = snapshot.data!;
                            } else {
                              versionText = '버전 정보를 가져올 수 없습니다.';
                            }
                          }
                          return Container(
                            color: ThemeModel.surface(isDarkMode),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Text(
                                  '앱 버전',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeModel.text(isDarkMode),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  versionText,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeModel.sub4(isDarkMode),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
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
                                content: Text(
                                  '로그아웃하시겠습니까?',
                                  style: TextStyle(
                                    color: ThemeModel.text(isDarkMode),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
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

                      /// 계정 삭제
                      CInkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              final emailController = TextEditingController();
                              final passwordController =
                                  TextEditingController();
                              String? emailError;
                              String? passwordError;

                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return CDialog(
                                    title: '계정 재인증 필요',
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '계정을 삭제하려면 보안을 위해 이메일과 암호로 재인증해야 합니다. 아래에 로그인 정보를 입력해 주세요.',
                                          style: TextStyle(
                                            color: ThemeModel.text(isDarkMode),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        // 이메일 입력 필드
                                        CTextField(
                                          backgroundColor:
                                              ThemeModel.background(isDarkMode),
                                          label: '이메일',
                                          controller: emailController,
                                          errorText: emailError,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          hint: 'example@example.com',
                                        ),
                                        const SizedBox(height: 16),
                                        // 비밀번호 입력 필드
                                        CTextField(
                                          backgroundColor:
                                              ThemeModel.background(isDarkMode),
                                          label: '암호',
                                          controller: passwordController,
                                          errorText: passwordError,
                                          obscureText: true,
                                        ),
                                      ],
                                    ),
                                    buttons: [
                                      // 취소 버튼
                                      CButton(
                                        label: '취소',
                                        style:
                                            CButtonStyle.secondary(isDarkMode),
                                        size: CButtonSize.large,
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      // 계정 삭제 버튼
                                      CButton(
                                        style: CButtonStyle.danger(isDarkMode),
                                        label: '계정 삭제',
                                        size: CButtonSize.large,
                                        onTap: () async {
                                          final email =
                                              emailController.text.trim();
                                          final password =
                                              passwordController.text.trim();

                                          setState(() {
                                            emailError = email.isEmpty
                                                ? '이메일을 입력하십시오.'
                                                : null;
                                            passwordError = password.isEmpty
                                                ? '암호를 입력하십시오.'
                                                : null;
                                          });

                                          if (emailError == null &&
                                              passwordError == null) {
                                            try {
                                              await ref
                                                  .read(authProvider.notifier)
                                                  .deleteAccount(
                                                      email, password);
                                              if (context.mounted) {
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LogInPage(),
                                                  ),
                                                  (route) => false,
                                                );
                                              }
                                            } catch (e) {
                                              setState(() {
                                                if (e.toString().contains(
                                                    'invalid-email')) {
                                                  emailError =
                                                      '이메일 형식을 확인하십시오.';
                                                } else {
                                                  passwordError =
                                                      '이메일 또는 암호를 확인하십시오.';
                                                }
                                              });
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                },
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
                                '계정 삭제',
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
