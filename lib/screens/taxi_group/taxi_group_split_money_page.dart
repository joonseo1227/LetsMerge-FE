import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/provider/user_fetch_notifier.dart';
import 'package:letsmerge/screens/main/main_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_tag.dart';

class TaxiGroupSplitMoneyPage extends ConsumerStatefulWidget {
  final String settlementData;

  const TaxiGroupSplitMoneyPage({
    super.key,
    required this.settlementData,
  });

  @override
  ConsumerState<TaxiGroupSplitMoneyPage> createState() =>
      _TaxiGroupSplitMoneyPageState();
}

class _TaxiGroupSplitMoneyPageState
    extends ConsumerState<TaxiGroupSplitMoneyPage> {
  late FocusNode _focusNode;
  late Map<String, dynamic> settlementInfo;
  late int totalAmount;
  late double amountPerPerson;
  late List<String> payers;
  late String requestedByUserId;
  late DateTime settlementTime;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    parseSettlementData();

    // 화면이 로드될 때 포커스 요청
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void parseSettlementData() {
    try {
      // JSON 문자열을 Map으로 파싱
      settlementInfo = jsonDecode(widget.settlementData);

      // 데이터 추출
      totalAmount = settlementInfo['totalAmount'];
      amountPerPerson = settlementInfo['amountPerPerson'];
      payers = List<String>.from(settlementInfo['payers']);
      requestedByUserId = settlementInfo['requestedByUserId'];
      settlementTime = DateTime.parse(settlementInfo['settlementTime']);
    } catch (e) {
      debugPrint('정산 데이터 파싱 오류: $e');
      // 오류 처리 (기본값 설정 등)
      totalAmount = 0;
      amountPerPerson = 0;
      payers = [];
      requestedByUserId = '';
      settlementTime = DateTime.now();
    }
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 정산 정보 카드
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ThemeModel.surface(isDarkMode),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SizedBox(height: 16),
                          // 상단 아이콘
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: ThemeModel.highlightText(isDarkMode)
                                  .withValues(
                                alpha: 0.1,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.attach_money,
                              size: 40,
                              color: ThemeModel.highlightText(isDarkMode),
                            ),
                          ),
                          SizedBox(height: 20),
                          // 정산 금액 정보
                          Text(
                            () {
                              final userInfo = ref
                                  .watch(userInfoProvider(requestedByUserId));
                              final nickname = userInfo.nickname;
                              final name = userInfo.name;

                              final maskedName = name.length > 1
                                  ? '${name.substring(0, 1)}*${name.length > 2 ? name.substring(2) : ''}'
                                  : name;

                              return '$nickname($maskedName)님에게';
                            }(),
                            style: TextStyle(
                              color: ThemeModel.text(isDarkMode),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${NumberFormat('#,###', 'ko_KR').format(amountPerPerson)}원',
                            style: TextStyle(
                              color: ThemeModel.highlightText(isDarkMode),
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '송금해 주세요',
                            style: TextStyle(
                              color: ThemeModel.text(isDarkMode),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 32),
                          Divider(),
                          SizedBox(height: 16),
                          // 계좌 정보
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CTag(
                                text: '토스뱅크',
                                color: TagColor.blue,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                '123456789012345',
                                style: TextStyle(
                                  color: ThemeModel.text(isDarkMode),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Spacer(),
                              CButton(
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: '토스뱅크 123456789012345',
                                    ),
                                  );
                                },
                                style: CButtonStyle(
                                  backgroundColor: Colors.transparent,
                                  labelColor: ThemeModel.sub4(isDarkMode),
                                  iconColor: ThemeModel.sub4(isDarkMode),
                                ),
                                size: CButtonSize.medium,
                                icon: Icons.copy,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // 안내
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ThemeModel.highlightText(isDarkMode).withValues(
                          alpha: 0.1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: ThemeModel.highlightText(isDarkMode),
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '송금 후 정산 완료 버튼을 눌러주세요.',
                              style: TextStyle(
                                color: ThemeModel.highlightText(isDarkMode),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
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

          // 버튼 영역
          Container(
            color: ThemeModel.highlight(isDarkMode),
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
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
