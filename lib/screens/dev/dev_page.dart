import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/group_provider.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/dev/button_gallery_page.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_request_money_page.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_split_money_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_checkbox.dart';
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
  bool _isAgreed1 = true;
  bool _isAgreed2 = false;

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
                  title: '어두운 테마',
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
                CCheckbox(
                  value: _isAgreed1,
                  onChanged: (value) {
                    setState(() {
                      _isAgreed1 = value;
                    });
                  },
                  label: "체크박스 레이블",
                ),
                SizedBox(height: 32),
                CCheckbox(
                  value: _isAgreed2,
                  onChanged: (value) {
                    setState(() {
                      _isAgreed2 = value;
                    });
                  },
                ),
                SizedBox(height: 32),
                CCheckbox(
                  value: true,
                  onChanged: null,
                  label: "비활성화된 체크박스",
                ),
                SizedBox(height: 32),
                CCheckbox(
                  value: false,
                  onChanged: null,
                  label: "비활성화된 체크박스",
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
                SizedBox(height: 16),
                CButton(
                  label: 'TaxiGroupListScreen',
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => TaxiGroupListScreen(),
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

class TaxiGroupListScreen extends ConsumerWidget {
  const TaxiGroupListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('택시 그룹 목록')),
      body: Column(
        children: [
          CButton(
            onTap: () {
              // 데이터 새로고침
              ref.read(taxiGroupProvider.notifier).fetchTaxiGroups();
            },
            label: '새로고침',
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final taxiGroups = ref.watch(taxiGroupProvider);

                if (taxiGroups.isEmpty) {
                  return const Center(
                    child: Text('택시 그룹이 없습니다.'),
                  );
                }

                return ListView.builder(
                  itemCount: taxiGroups.length,
                  itemBuilder: (context, index) {
                    final group = taxiGroups[index];
                    return ListTile(
                      title: Text(
                          '${group.departurePlace} → ${group.arrivalPlace}'),
                      subtitle: Text(
                        '예상 요금: ${group.estimatedFare}원\n'
                        '출발 시간: ${group.departureTime ?? "미정"}',
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
