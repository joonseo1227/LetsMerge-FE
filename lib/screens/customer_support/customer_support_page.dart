import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/customer_support/inquiry_page.dart';
import 'package:letsmerge/widgets/c_list_tile.dart';

class CustomerSupportPage extends ConsumerStatefulWidget {
  const CustomerSupportPage({super.key});

  @override
  ConsumerState<CustomerSupportPage> createState() =>
      _CustomerSupportPageState();
}

class _CustomerSupportPageState extends ConsumerState<CustomerSupportPage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('고객 지원'),
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 32, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '자주 묻는 질문',
                  style: TextStyle(
                    color: ThemeModel.text(isDarkMode),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                _buildFAQList(),
                const SizedBox(height: 32),
                Text(
                  '찾는 내용이 없나요?',
                  style: TextStyle(
                    color: ThemeModel.text(isDarkMode),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                CListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => InquiryPage(),
                      ),
                    );
                  },
                  title: '문의하기',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // FAQ 리스트
  Widget _buildFAQList() {
    final isDarkMode = ref.watch(themeProvider);

    final List<Map<String, String>> faqData = [
      {'Q': '택시팟은 어떻게 찾나요?', 'A': '홈 화면에서 주변 택시팟을 검색할 수 있습니다.'},
      {'Q': '정산은 어떻게 하나요?', 'A': '머지 완료 후 자동으로 택시비가 계산됩니다.'},
      {'Q': '신고는 어떻게 하나요?', 'A': '고객 지원 페이지에서 신고할 수 있습니다.'},
      {
        'Q': '머지를 취소할 수 있나요?',
        'A': '출발 전이라면 언제든지 취소할 수 있습니다. 단, 너무 잦은 취소는 제재될 수 있습니다.'
      },
      {'Q': '택시팟에 몇 명까지 참여할 수 있나요?', 'A': '최대 4명까지 한 팀으로 택시팟을 구성할 수 있습니다.'},
      {
        'Q': '합승자는 어떻게 선택되나요?',
        'A': '출발지와 목적지가 비슷한 이용자들끼리 자동으로 매칭됩니다. 또한, 매너 레벨이 고려됩니다.'
      },
      {
        'Q': '매너 레벨은 어떻게 결정되나요?',
        'A': '이용자 후기와 신고 내역을 바탕으로 자동 산정됩니다. 좋은 평가를 받을수록 매너 레벨이 올라갑니다.'
      },
      {
        'Q': '정기 합승은 어떻게 설정하나요?',
        'A': '자주 이용하는 시간대에 정기 머지를 설정하면 매일 같은 시간에 자동으로 합승을 신청할 수 있습니다.'
      },
      {
        'Q': '출발 시간이 지나면 어떻게 되나요?',
        'A': '출발 시간이 지나면 해당 택시팟은 자동으로 종료됩니다. 참여하지 않은 경우, 불참 기록이 누적될 수 있습니다.'
      },
      {
        'Q': '택시비는 어떻게 나눠지나요?',
        'A': '전체 택시비를 탑승 인원 수대로 균등하게 나눕니다. 탑승 후 정산 화면에서 최종 요금을 확인할 수 있습니다.'
      },
      {
        'Q': '카드 결제는 가능한가요?',
        'A': '현재는 직접 현금 또는 개인 간 송금 방식으로 정산해야 합니다. 추후 카드 결제 기능이 추가될 예정입니다.'
      },
      {
        'Q': '위치 공유는 어떻게 사용하나요?',
        'A': '머지 시작 후 참여자들은 실시간 위치를 공유할 수 있으며, 이를 통해 서로 쉽게 만날 수 있습니다.'
      },
      {
        'Q': '머지 도중에 다른 곳에서 내릴 수 있나요?',
        'A': '원칙적으로는 목적지까지 함께 이동해야 하지만, 사전에 합의된 경우 중간에 하차할 수 있습니다.'
      },
      {
        'Q': '탑승 후 불쾌한 경험이 있으면 어떻게 하나요?',
        'A': '머지 완료 후 후기를 남길 수 있으며, 심각한 경우 신고 기능을 이용해주세요.'
      },
      {
        'Q': '내가 만든 택시팟을 삭제할 수 있나요?',
        'A': '아직 참여자가 없다면 언제든지 삭제할 수 있습니다. 참여자가 있다면 먼저 나머지 인원에게 취소 요청을 해야 합니다.'
      },
      {
        'Q': '운전기사를 직접 선택할 수 있나요?',
        'A': '렛츠머지는 택시 호출 서비스가 아니라 합승 플랫폼이므로, 운전기사는 별도로 선택할 수 없습니다.'
      },
      {
        'Q': '장거리 이동도 가능한가요?',
        'A':
            '네, 장거리 이동도 가능합니다. 다만, 일정 거리를 초과하는 경우 요금과 합승 규칙이 달라질 수 있으니 확인 후 이용해주세요.'
      },
      {
        'Q': '머지에 참여하지 않으면 불이익이 있나요?',
        'A': '사전 취소 없이 불참하는 경우, 신뢰도 점수가 낮아질 수 있습니다.'
      },
      {'Q': '고객센터는 몇 시까지 운영되나요?', 'A': '고객센터는 24시간 운영되며, 신고 접수는 항상 가능합니다.'},
    ];

    return Column(
      children: faqData.asMap().entries.map((entry) {
        final int index = entry.key;
        final Map<String, String> faq = entry.value;
        final bool isLastItem = index == faqData.length - 1;

        return ExpansionTile(
          collapsedShape: isLastItem
              ? Border(
                  bottom: BorderSide.none,
                )
              : Border(
                  bottom: BorderSide(
                    color: ThemeModel.sub1(isDarkMode),
                  ),
                ),
          shape: isLastItem
              ? Border(
                  bottom: BorderSide.none,
                )
              : Border(
                  bottom: BorderSide(
                    color: ThemeModel.sub1(isDarkMode),
                  ),
                ),
          collapsedBackgroundColor: ThemeModel.surface(isDarkMode),
          backgroundColor: ThemeModel.surface(isDarkMode),
          collapsedIconColor: ThemeModel.sub3(isDarkMode),
          iconColor: ThemeModel.sub3(isDarkMode),
          childrenPadding: EdgeInsets.all(16),
          title: Text(
            faq['Q']!,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: ThemeModel.text(isDarkMode),
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                faq['A']!,
                style: TextStyle(
                  fontSize: 16,
                  color: ThemeModel.text(isDarkMode),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
