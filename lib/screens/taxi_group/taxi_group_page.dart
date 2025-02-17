import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/main/main_page.dart';
import 'package:letsmerge/screens/report_page.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_split_money_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_popup_menu.dart';

class TaxiGroupPage extends ConsumerStatefulWidget {
  const TaxiGroupPage({super.key});

  @override
  ConsumerState<TaxiGroupPage> createState() => _TaxiGroupPageState();
}

class _TaxiGroupPageState extends ConsumerState<TaxiGroupPage> {
  final GlobalKey<CPopupMenuState> popupMenuKey = GlobalKey<CPopupMenuState>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: CInkWell(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => MainPage(),
              ),
              (Route<dynamic> route) => false,
            );
          },
          child: SizedBox(
            width: 32,
            height: 32,
            child: Icon(
              Icons.close,
              size: 28,
              color: ThemeModel.text(isDarkMode),
            ),
          ),
        ),
        actions: [
          CPopupMenu(
            key: popupMenuKey,
            button: SizedBox(
              width: 32,
              height: 32,
              child: Icon(
                Icons.more_vert,
                size: 28,
                color: ThemeModel.text(isDarkMode),
              ),
            ),
            dropdownWidth: 200,
            dropdown: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CInkWell(
                  onTap: () {
                    popupMenuKey.currentState?.hideDropdown();
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      size: 24,
                      color: ThemeModel.text(isDarkMode),
                    ),
                    title: Text(
                      '택시팟 나가기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ThemeModel.text(isDarkMode),
                      ),
                    ),
                  ),
                ),
                CInkWell(
                  onTap: () {
                    popupMenuKey.currentState?.hideDropdown();
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => ReportPage(),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.flag_outlined,
                      size: 24,
                      color: ThemeModel.danger(isDarkMode),
                    ),
                    title: Text(
                      '신고',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ThemeModel.danger(isDarkMode),
                      ),
                    ),
                  ),
                ),
              ],
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
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TODO: 다른 참여자 실시간 위치 표시, 채팅 기능
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: ThemeModel.highlight(isDarkMode),
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: SafeArea(
          child: CButton(
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => TaxiGroupSplitMoneyPage(),
                ),
              );
            },
            size: CButtonSize.extraLarge,
            label: '정산하기',
            icon: Icons.navigate_next,
            width: double.maxFinite,
          ),
        ),
      ),
    );
  }
}
