import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/dev/button_gallery_page.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_request_money_page.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_split_money_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_datetime_picker.dart';
import 'package:letsmerge/widgets/c_dialog.dart';
import 'package:letsmerge/widgets/c_dropdown.dart';
import 'package:letsmerge/widgets/c_list_tile.dart';
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
  String? selectedItem;

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
                CListTile(
                  label: '어두운 테마',
                  onTap: () {
                    ref.read(themeProvider.notifier).toggleTheme();
                  },
                  trailing: CSwitch(
                    value: isDarkMode,
                    onChanged: (_) {
                      ref.read(themeProvider.notifier).toggleTheme();
                    },
                  ),
                ),
                SizedBox(height: 32),
                CDropdown<String>(
                  label: 'label',
                  hint: 'hint',
                  items: [
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                    'Option 1',
                    'Option 2',
                    'Option 3',
                    'Option 4'
                  ],
                  initialValue: selectedItem,
                  onChanged: (value) {
                    setState(() {
                      selectedItem = value;
                    });
                  },
                ),
                SizedBox(height: 32),
                CTextField(
                  label: 'label',
                  hint: 'hint',
                ),
                SizedBox(height: 32),
                CSearchBar(
                  hint: 'hint',
                ),
                SizedBox(height: 32),
                CDateTimePicker(
                  onDateTimeSelected: (dateTime) {
                    setState(
                      () {},
                    );
                  },
                ),
                SizedBox(height: 32),
                CSwitch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                    });
                  },
                ),
                SizedBox(height: 32),
                CButton(
                  label: 'Show Dialog',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CDialog(
                          title: 'Title',
                          content: Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean id accumsan augue.',
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
                SizedBox(height: 16),
                CButton(
                  label: 'TaxiGroupSplitMoneyPage\n(내가 대표가 아닐 때->대표에게 송금)',
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => TaxiGroupSplitMoneyPage(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),
                CButton(
                  label: 'TaxiGroupRequestMoneyPage\n(내가 대표일 때->정산 요청)',
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => TaxiGroupRequestMoneyPage(),
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
