import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/main/main_page.dart';
import 'package:letsmerge/widgets/c_button.dart';

class TaxiGroupSplitMoneyPage extends ConsumerStatefulWidget {
  const TaxiGroupSplitMoneyPage({super.key});

  @override
  ConsumerState<TaxiGroupSplitMoneyPage> createState() =>
      _TaxiGroupSplitMoneyPageState();
}

class _TaxiGroupSplitMoneyPageState
    extends ConsumerState<TaxiGroupSplitMoneyPage> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // FocusNode 초기화
    _focusNode = FocusNode();
    // 화면이 로드될 때 포커스 요청
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    // FocusNode 해제
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('정산하기'),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          // 스크롤 가능한 콘텐츠
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '홍길동 님에게 1,200원 송금해 주세요.',
                      style: TextStyle(
                        color: ThemeModel.text(isDarkMode),
                      ),
                    ),
                    Text(
                      '토스뱅크 123456789012345',
                      style: TextStyle(
                        color: ThemeModel.text(isDarkMode),
                      ),
                    ),
                    CButton(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(
                            text: '토스뱅크 123456789012345',
                          ),
                        );
                      },
                      style: CButtonStyle.ghost(isDarkMode),
                      size: CButtonSize.small,
                      label: '계좌번호 복사',
                      icon: Icons.copy,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 버튼 영역
          Container(
            color: ThemeModel.highlight(isDarkMode),
            child: SafeArea(
              top: false,
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
        ],
      ),
    );
  }
}
