import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/dev/button_gallery_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_dialog.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_search_bar.dart';
import 'package:letsmerge/widgets/c_switch.dart';
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
                  label: 'Show Dialog',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CDialog(
                          title: 'Title',
                          content:
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean id accumsan augue.',
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
                              label: '확인',
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 16),
                CButton(
                  label: 'ButtonGalleryPage',
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => ButtonGalleryPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
