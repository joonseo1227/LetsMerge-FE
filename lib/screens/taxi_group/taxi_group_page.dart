import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/main/main_page.dart';
import 'package:letsmerge/screens/report_page.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_split_money_page.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_list_tile.dart';
import 'package:letsmerge/widgets/c_popup_menu.dart';
import 'package:letsmerge/widgets/c_text_field.dart';

class TaxiGroupPage extends ConsumerStatefulWidget {
  const TaxiGroupPage({super.key});

  @override
  ConsumerState<TaxiGroupPage> createState() => _TaxiGroupPageState();
}

class _TaxiGroupPageState extends ConsumerState<TaxiGroupPage> {
  final GlobalKey<CPopupMenuState> popupMenuKey = GlobalKey<CPopupMenuState>();

  List<Map<String, dynamic>> messages = [
    {
      'sender': '홍길동',
      'text': 'nulla pariatur.',
      'time': DateTime.now().subtract(Duration(minutes: 1)),
    },
    {
      'sender': '홍길동',
      'text': 'Excepteur sint occaecat cupidatat non proident.',
      'time': DateTime.now().subtract(Duration(minutes: 1)),
    },
    {
      'sender': '홍동',
      'text':
          'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
      'time': DateTime.now().subtract(Duration(minutes: 2)),
    },
    {
      'sender': '홍길자',
      'text':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean id accumsan augue.',
      'time': DateTime.now().subtract(Duration(minutes: 10)),
    },
  ];

  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Hero(
      tag: 'taxiGroup',
      child: Scaffold(
        appBar: _buildAppBar(isDarkMode),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // 채팅 메시지 영역
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    itemCount: messages.length,
                    itemBuilder: (context, index) =>
                        _buildMessageItem(context, index, isDarkMode),
                  ),
                ),
                // 메시지 입력 영역
                _buildChatInput(isDarkMode),
              ],
            );
          },
        ),
      ),
    );
  }

  /// 앱바 위젯 생성 메서드
  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    return AppBar(
      titleSpacing: 0,
      leading: CInkWell(
        onTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  MainPage(),
            ),
            (route) => false,
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
                        builder: (context) => const ReportPage()),
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
        const SizedBox(width: 16),
      ],
    );
  }

  /// 메시지 아이템 생성 메서드
  Widget _buildMessageItem(BuildContext context, int index, bool isDarkMode) {
    final message = messages[index];
    final bool isUser = message['sender'] == 'user';
    final String formattedTime =
        DateFormat('a hh:mm', 'ko_KR').format(message['time']);

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: isUser
            ? _buildUserMessage(message, formattedTime, isDarkMode)
            : _buildOtherMessage(message, formattedTime, isDarkMode),
      ),
    );
  }

  /// 본인(사용자) 메시지 UI 생성 메서드
  Widget _buildUserMessage(
      Map<String, dynamic> message, String formattedTime, bool isDarkMode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 메시지 전송 시각
            Text(
              formattedTime,
              style: TextStyle(
                color: ThemeModel.sub3(isDarkMode),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
            const SizedBox(width: 8),
            // 메시지 박스
            IntrinsicWidth(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ThemeModel.highlight(isDarkMode),
                ),
                child: Text(
                  message['text']!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 상대방 메시지 UI 생성 메서드
  Widget _buildOtherMessage(
      Map<String, dynamic> message, String formattedTime, bool isDarkMode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 프로필 영역
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Container(
            width: 40,
            height: 40,
            decoration: const ShapeDecoration(
              color: blue20,
              shape: CircleBorder(),
            ),
          ),
        ),
        // 메시지 및 이름 영역
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 보낸 사람 이름
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                message['sender']!,
                style: TextStyle(
                  color: ThemeModel.sub6(isDarkMode),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 메시지 박스
                IntrinsicWidth(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ThemeModel.surface(isDarkMode),
                    ),
                    child: Text(
                      message['text']!,
                      style: TextStyle(
                        fontSize: 16,
                        color: ThemeModel.text(isDarkMode),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // 메시지 전송 시각
                Text(
                  formattedTime,
                  style: TextStyle(
                    color: ThemeModel.sub3(isDarkMode),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// 메시지 입력 UI 생성 메서드
  Widget _buildChatInput(bool isDarkMode) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            CInkWell(
              onTap: _showBottomSheet,
              child: SizedBox(
                width: 64,
                height: 32,
                child: Icon(
                  Icons.add,
                  size: 28,
                  color: ThemeModel.text(isDarkMode),
                ),
              ),
            ),
            Expanded(
              child: CTextField(
                controller: _chatController,
                hint: '메시지 입력',
              ),
            ),
            CInkWell(
              onTap: _sendMessage,
              child: SizedBox(
                width: 64,
                height: 32,
                child: Icon(
                  Icons.send,
                  size: 28,
                  color: ThemeModel.highlightText(isDarkMode),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 메시지 전송 함수
  void _sendMessage() {
    if (_chatController.text.isNotEmpty) {
      // 스크롤을 맨 아래로 이동
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
      );

      setState(() {
        messages.insert(0, {
          'sender': 'user',
          'text': _chatController.text,
          'time': DateTime.now(),
        });
      });
      _chatController.clear();
    }
  }

  /// 하단 모달 시트 호출 함수
  void _showBottomSheet() {
    final isDarkMode = ref.read(themeProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ThemeModel.background(isDarkMode),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (BuildContext context) => _buildBottomSheetContent(isDarkMode),
    );
  }

  /// 모달 시트 내부 콘텐츠 생성 메서드
  Widget _buildBottomSheetContent(bool isDarkMode) {
    return SafeArea(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 시트 상단 바
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: ThemeModel.sub3(isDarkMode),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Container(
                        color: ThemeModel.surface(isDarkMode),
                        child: Column(
                          children: [
                            CListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        TaxiGroupSplitMoneyPage(),
                                  ),
                                );
                              },
                              title: '정산하기',
                              icon: Icons.attach_money,
                            ),
                            CListTile(
                              onTap: () {},
                              title: '실시간 위치 공유',
                              icon: Icons.location_on,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
