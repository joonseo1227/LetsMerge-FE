import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/main/main_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_tag.dart';
import 'package:letsmerge/widgets/c_text_field.dart';

class TaxiGroupRequestMoneyPage extends ConsumerStatefulWidget {
  const TaxiGroupRequestMoneyPage({super.key});

  @override
  ConsumerState<TaxiGroupRequestMoneyPage> createState() =>
      _TaxiGroupRequestMoneyPageState();
}

class _TaxiGroupRequestMoneyPageState
    extends ConsumerState<TaxiGroupRequestMoneyPage> {
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
                    CTextField(
                      keyboardType: TextInputType.number,
                      label: '택시비',
                      hint: '총 금액 입력(원)',
                      focusNode: _focusNode,
                    ),

                    SizedBox(height: 16),

                    CButton(
                      onTap: () {},
                      style: CButtonStyle.ghost(isDarkMode),
                      size: CButtonSize.small,
                      label: '영수증 첨부(선택)',
                      icon: Icons.receipt,
                    ),

                    SizedBox(height: 16),

                    Text(
                      '정산 인원',
                      style: TextStyle(
                        color: ThemeModel.text(isDarkMode),
                      ),
                    ),

                    SizedBox(height: 4),

                    /// 참여자 정보
                    Container(
                      color: ThemeModel.surface(isDarkMode),
                      width: double.maxFinite,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: ShapeDecoration(
                                  color: blue20,
                                  shape: CircleBorder(),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                '홍길동',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeModel.text(isDarkMode),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              CTag(
                                text: '나',
                                color: TagColor.blue,
                              ),
                              Spacer(),
                              Icon(
                                Icons.star,
                                size: 16,
                                color: ThemeModel.sub2(isDarkMode),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                '4.5/5.0',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeModel.sub4(isDarkMode),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: ShapeDecoration(
                                  color: blue20,
                                  shape: CircleBorder(),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                '홍길자',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeModel.text(isDarkMode),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Spacer(),
                              Icon(
                                Icons.star,
                                size: 16,
                                color: ThemeModel.sub2(isDarkMode),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                '4.5/5.0',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeModel.sub4(isDarkMode),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: ShapeDecoration(
                                  color: blue20,
                                  shape: CircleBorder(),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                '홍동',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeModel.text(isDarkMode),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Spacer(),
                              Icon(
                                Icons.star,
                                size: 16,
                                color: ThemeModel.sub2(isDarkMode),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                '4.5/5.0',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeModel.sub4(isDarkMode),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                label: '정산 요청',
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
