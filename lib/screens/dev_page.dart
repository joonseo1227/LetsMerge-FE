import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/auth/log_in_page.dart';
import 'package:letsmerge/screens/auth/sign_up_page.dart';
import 'package:letsmerge/screens/settings_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_search_bar.dart';
import 'package:letsmerge/widgets/c_switch.dart';
import 'package:letsmerge/widgets/c_tag.dart';
import 'package:letsmerge/widgets/c_text_field.dart';

class DevPage extends ConsumerStatefulWidget {
  const DevPage({super.key});

  @override
  ConsumerState<DevPage> createState() => _DevPageState();
}

class _DevPageState extends ConsumerState<DevPage> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('DEV'),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            ref.read(themeProvider.notifier).toggleTheme();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                CTextField(
                  label: 'CTextField',
                  hint: 'hint',
                ),
                SizedBox(height: 16),
                CSearchBar(
                  hint: 'hint',
                ),
                SizedBox(height: 16),
                CSwitch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                CButton(
                  label: 'Default Button',
                  onTap: () {
                    debugPrint('Default Button Clicked');
                  },
                ),
                SizedBox(height: 16),
                CButton(
                  style: CButtonStyle.primary(isDarkMode),
                  label: 'Primary Button',
                  icon: Icons.home,
                  width: 300,
                  onTap: () {
                    debugPrint('Primary Button Clicked');
                  },
                ),
                SizedBox(height: 16),
                CButton(
                  style: CButtonStyle.secondary(isDarkMode),
                  icon: Icons.settings,
                  size: CButtonSize.medium,
                  onTap: () {
                    debugPrint('Secondary Button Clicked');
                  },
                ),
                SizedBox(height: 16),
                CButton(
                  style: CButtonStyle.tertiary(isDarkMode),
                  label: 'Tertiary Button',
                  icon: Icons.info,
                  size: CButtonSize.medium,
                  onTap: () {
                    debugPrint('Tertiary Button Clicked');
                  },
                ),
                SizedBox(height: 16),
                CButton(
                  style: CButtonStyle.danger(isDarkMode),
                  label: 'Danger Button',
                  size: CButtonSize.x2Large,
                  onTap: () {
                    debugPrint('Danger Button Clicked');
                  },
                ),
                SizedBox(height: 16),
                CButton(
                  style: CButtonStyle.ghost(isDarkMode),
                  label: 'Ghost Button',
                  onTap: () {
                    debugPrint('Ghost Button Clicked');
                  },
                ),
                SizedBox(height: 16),
                CButton(
                  style: CButtonStyle.primary(isDarkMode),
                  label: 'Small Button',
                  size: CButtonSize.small,
                  onTap: () {
                    debugPrint('Small Button Clicked');
                  },
                ),
                SizedBox(height: 16),
                CButton(
                  style: CButtonStyle.secondary(isDarkMode),
                  label: 'Extra Large Button',
                  size: CButtonSize.extraLarge,
                  onTap: () {
                    debugPrint('Extra Large Button Clicked');
                  },
                ),
                SizedBox(height: 16),
                CButton(
                  style: CButtonStyle.tertiary(isDarkMode),
                  label: 'Custom Width',
                  icon: Icons.star,
                  width: 250,
                  onTap: () {
                    debugPrint('Custom Width Button Clicked');
                  },
                ),
                SizedBox(height: 16),
                CInkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LogInPage(),
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
                          '로그인',
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
                SizedBox(
                  height: 16,
                ),
                CInkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SignUpPage(),
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
                          '계정 생성',
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
                SizedBox(
                  height: 16,
                ),
                CInkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
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
                          '설정',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
