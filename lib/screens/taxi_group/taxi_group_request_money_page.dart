import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/taxi_group/taxi_group.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/group_provider.dart';
import 'package:letsmerge/provider/taxi_group_fetch_notifier.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/provider/user_fetch_notifier.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_checkbox.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaxiGroupRequestMoneyPage extends ConsumerStatefulWidget {
  final TaxiGroup taxiGroup;

  const TaxiGroupRequestMoneyPage({
    super.key,
    required this.taxiGroup,
  });

  @override
  ConsumerState<TaxiGroupRequestMoneyPage> createState() =>
      _TaxiGroupRequestMoneyPageState();
}

class _TaxiGroupRequestMoneyPageState
    extends ConsumerState<TaxiGroupRequestMoneyPage> {
  final User? user = Supabase.instance.client.auth.currentUser;
  late FocusNode _focusNode;
  Map<String, bool> selectedParticipants = {};
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    amountController = TextEditingController();

    // 참가자 목록을 불러온 후 초기 상태 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final participants = ref.read(participantsProvider(widget.taxiGroup));

      // 모든 참가자 초기 상태는 true로 설정 (모두 선택된 상태)
      if (widget.taxiGroup.creatorUserId != null) {
        selectedParticipants[widget.taxiGroup.creatorUserId!] = true;
      }

      // 다른 참가자들 상태 설정
      for (final participant in participants) {
        selectedParticipants[participant.userId] = true;
      }

      // 상태 업데이트
      setState(() {});

      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    amountController.dispose();
    super.dispose();
  }

  // 체크박스 상태 변경 핸들러
  void toggleParticipantSelection(String userId) {
    setState(() {
      selectedParticipants[userId] = !(selectedParticipants[userId] ?? false);
    });
  }

  // 선택된 참가자 수
  int get selectedCount =>
      selectedParticipants.values.where((selected) => selected).length;

  // 1인당 금액 계산
  double getAmountPerPerson() {
    if (selectedCount == 0 || amountController.text.isEmpty) return 0;

    // 콤마 제거 후 금액 파싱
    final totalAmount =
        int.tryParse(amountController.text.replaceAll(',', '')) ?? 0;
    return totalAmount / selectedCount;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final participants = ref.watch(participantsProvider(widget.taxiGroup));
    final isMe = false;

    List<String> participantsWithCreator = [];

    if (widget.taxiGroup.creatorUserId != null) {
      participantsWithCreator.add(widget.taxiGroup.creatorUserId!);
    }

    for (final participant in participants) {
      participantsWithCreator.add(participant.userId);
    }

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
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              backgroundColor:
                                  ThemeModel.background(isDarkMode),
                              hint: '총 금액 입력(원)',
                              onChanged: (value) {
                                // 숫자만 남기고 모든 문자 제거
                                String numericValue =
                                    value.replaceAll(RegExp(r'[^0-9]'), '');

                                if (numericValue.isEmpty) {
                                  amountController.text = '';
                                  setState(() {});
                                  return;
                                }

                                // 숫자를 정수로 파싱
                                int amount = int.parse(numericValue);

                                // 천 단위 구분자와 함께 포맷팅
                                String formattedValue = amount
                                    .toString()
                                    .replaceAllMapped(
                                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                        (Match m) => '${m[1]},');

                                // 현재 커서 위치 저장
                                int cursorPosition =
                                    amountController.selection.start;

                                // 이전 문자열과 새 문자열의 길이 차이 계산
                                int oldLength = amountController.text.length;

                                // 컨트롤러 텍스트 업데이트
                                amountController.text = formattedValue;

                                // 커서 위치 조정
                                int newPosition = cursorPosition -
                                    (oldLength - formattedValue.length);
                                if (newPosition < 0) newPosition = 0;
                                if (newPosition > formattedValue.length) {
                                  newPosition = formattedValue.length;
                                }

                                amountController.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(offset: newPosition),
                                );

                                setState(() {});
                              },
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
                          '$selectedCount명',
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
                        children: participantsWithCreator.map((participant) {
                          final userinfo =
                              ref.watch(userInfoProvider(participant));

                          return Column(
                            children: [
                              _buildUserItem(
                                userinfo.nickname!,
                                selectedParticipants[userinfo.userId] ?? false,
                                isMe,
                                userinfo.userId,
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
                          // 요약 항목
                          _buildSummaryItem(
                              '총 택시비',
                              '${amountController.text.isEmpty ? '-' : amountController.text}원',
                              isDarkMode),
                          SizedBox(height: 8),
                          _buildSummaryItem(
                              '참여 인원', '$selectedCount명', isDarkMode),
                          SizedBox(height: 12),
                          Divider(),
                          SizedBox(height: 12),
                          _buildSummaryItem(
                              '1인당 정산금액',
                              '${amountController.text.isEmpty ? '-' : NumberFormat('#,###', 'ko_KR').format(getAmountPerPerson())}원',
                              isDarkMode,
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
                onTap: (selectedCount == 0 || amountController.text.isEmpty)
                    ? null
                    : () async {
                        Map<String, dynamic> settlementInfo = {
                          'totalAmount': int.parse(
                              amountController.text.replaceAll(',', '')),
                          'amountPerPerson': getAmountPerPerson(),
                          'payers': selectedParticipants.entries
                              .where((entry) => entry.value)
                              .map((entry) => entry.key)
                              .toList(),
                          'requestedByUserId': user?.id,
                          'settlementTime': DateTime.now().toIso8601String(),
                        };

                        await ref
                            .read(taxiGroupProvider.notifier)
                            .sendChatMessage(
                              widget.taxiGroup,
                              jsonEncode(settlementInfo),
                              'request_money',
                            );
                        Navigator.pop(context);
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
  Widget _buildUserItem(
    String name,
    bool isSelected,
    bool isMe,
    String userId,
  ) {
    final isDarkMode = ref.watch(themeProvider);

    return CInkWell(
      onTap: () => toggleParticipantSelection(userId),
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
                value: selectedParticipants[userId] ?? false,
                onChanged: (_) => toggleParticipantSelection(userId),
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
