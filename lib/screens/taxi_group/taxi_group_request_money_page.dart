import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/main/main_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_checkbox.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
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

  List<Map<String, dynamic>> participants = [
    {'name': '홍길동', 'isSelected': true, 'isMe': true},
    {'name': '김철수', 'isSelected': true, 'isMe': false},
    {'name': '이영희', 'isSelected': true, 'isMe': false},
  ];

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
        title: Text(
          '정산하기',
        ),
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
                    // 섹션 제목
                    _buildSectionHeader('택시비 금액', isDarkMode),
                    SizedBox(height: 8),

                    // 비용 입력 섹션
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 32),
                      decoration: BoxDecoration(
                        color: ThemeModel.surface(isDarkMode),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 금액 입력 필드
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: CTextField(
                              focusNode: _focusNode,
                              keyboardType: TextInputType.number,
                              hint: '총 금액 입력(원)',
                            ),
                          ),
                          Divider(),
                          // 리스트 타일
                          CInkWell(
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.receipt_long,
                                    size: 24,
                                    color: ThemeModel.sub3(isDarkMode),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      '영수증 첨부 (선택)',
                                      style: TextStyle(
                                        color: ThemeModel.text(isDarkMode),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.navigate_next,
                                    size: 24,
                                    color: ThemeModel.sub3(isDarkMode),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 섹션 제목
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionHeader('정산 인원', isDarkMode),
                        Text(
                          '총 3명',
                          style: TextStyle(
                            color: ThemeModel.sub4(isDarkMode),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    // 정산 인원 섹션
                    Container(
                      margin: EdgeInsets.only(bottom: 32),
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                      decoration: BoxDecoration(
                        color: ThemeModel.surface(isDarkMode),
                      ),
                      child: Column(
                        children: participants.map((participant) {
                          return Column(
                            children: [
                              _buildUserItem(
                                participant['name'],
                                participant['isSelected'],
                                isDarkMode,
                                isMe: participant['isMe'],
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    participant['isSelected'] =
                                        newValue ?? false;
                                  });
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),

                    // 정산 알림 카드
                    _buildSectionHeader('정산 요약', isDarkMode),
                    SizedBox(height: 8),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ThemeModel.surface(isDarkMode),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 요약 금액 항목
                          _buildSummaryItem('총 택시비', '3,600원', isDarkMode),
                          SizedBox(height: 8),
                          _buildSummaryItem('참여 인원', '3명', isDarkMode),
                          SizedBox(height: 12),
                          Divider(),
                          SizedBox(height: 12),
                          _buildSummaryItem('1인당 정산금액', '1,200원', isDarkMode,
                              isHighlighted: true),
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

// 섹션 헤더
  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        color: ThemeModel.sub6(isDarkMode),
      ),
    );
  }

// 사용자 항목
  Widget _buildUserItem(String name, bool isSelected, bool isDarkMode,
      {bool isMe = false, required Function(bool?) onChanged}) {
    return CInkWell(
      onTap: () {
        onChanged(!isSelected);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          children: [
            // 아바타
            Container(
              width: 40,
              height: 40,
              decoration: ShapeDecoration(
                color: blue20,
                shape: CircleBorder(),
              ),
            ),
            SizedBox(width: 16),

            // 사용자 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ThemeModel.text(isDarkMode),
                        ),
                      ),
                      if (isMe)
                        Text(
                          ' (나)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: ThemeModel.sub3(isDarkMode),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    isSelected ? '정산 참여' : '정산 불참',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? ThemeModel.highlightText(isDarkMode)
                          : ThemeModel.sub4(isDarkMode),
                    ),
                  ),
                ],
              ),
            ),

            // 체크박스
            Padding(
              padding: const EdgeInsets.all(12),
              child: CCheckbox(
                value: isSelected,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }

// 요약 항목
  Widget _buildSummaryItem(String label, String value, bool isDarkMode,
      {bool isHighlighted = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: ThemeModel.sub4(isDarkMode),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isHighlighted
                ? ThemeModel.highlightText(isDarkMode)
                : ThemeModel.text(isDarkMode),
            fontSize: 16,
            fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
