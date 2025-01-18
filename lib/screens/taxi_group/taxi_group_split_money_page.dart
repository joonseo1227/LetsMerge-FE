import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/main/main_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_text_field.dart';

class TaxiGroupSplitMoneyPage extends ConsumerStatefulWidget {
  const TaxiGroupSplitMoneyPage({super.key});

  @override
  ConsumerState<TaxiGroupSplitMoneyPage> createState() => _MapTabState();
}

class _MapTabState extends ConsumerState<TaxiGroupSplitMoneyPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CTextField(
                  keyboardType: TextInputType.number,
                  label: '택시비',
                ),
                Text('1인당 택시비: 1,600원'),
                Text('3,200원 절약'),
                Text('대표자 계좌번호: '),
                CButton(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: '계좌번호'));
                  },
                  style: CButtonStyle.ghost(isDarkMode),
                  size: CButtonSize.small,
                  label: '계좌번호 복사',
                  icon: Icons.copy,
                ),
                Text('참여자 평가하기'),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: blue60,
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: SafeArea(
          child: CButton(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(builder: (context) => MainPage()),
                (Route<dynamic> route) => false,
              );
            },
            size: CButtonSize.extraLarge,
            label: '정산 완료',
            icon: Icons.navigate_next,
            width: double.maxFinite,
          ),
        ),
      ),
    );
  }
}
