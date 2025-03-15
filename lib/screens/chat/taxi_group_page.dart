import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/location_model.dart';
import 'package:letsmerge/models/taxi_group/chats/chat.dart';
import 'package:letsmerge/models/taxi_group/taxi_group.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/group_provider.dart';
import 'package:letsmerge/provider/taxi_group_fetch_notifier.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/provider/user_fetch_notifier.dart';
import 'package:letsmerge/screens/chat/taxi_group_chat_widget.dart';
import 'package:letsmerge/screens/main/main_page.dart';
import 'package:letsmerge/screens/report_page.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_open_app_page.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_request_money_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_dialog.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_list_tile.dart';
import 'package:letsmerge/widgets/c_map_widget.dart';
import 'package:letsmerge/widgets/c_popup_menu.dart';
import 'package:letsmerge/widgets/c_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaxiGroupPage extends ConsumerStatefulWidget {
  final TaxiGroup taxiGroup;

  const TaxiGroupPage({super.key, required this.taxiGroup});

  @override
  ConsumerState<TaxiGroupPage> createState() => _TaxiGroupPageState();
}

final SupabaseClient _supabase = Supabase.instance.client;
final User? user = _supabase.auth.currentUser;

class _TaxiGroupPageState extends ConsumerState<TaxiGroupPage> {
  final GlobalKey<CPopupMenuState> popupMenuKey = GlobalKey<CPopupMenuState>();
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final messages = ref.watch(chatMessagesProvider(widget.taxiGroup));

    return Hero(
      tag: 'taxiGroup',
      child: Scaffold(
        appBar: _buildAppBar(isDarkMode),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Expanded(
                  child: messages.isNotEmpty
                      ? ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          itemCount: messages.length,
                          itemBuilder: (context, index) => _buildMessageItem(
                            context,
                            index,
                            isDarkMode,
                            message: messages[index],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '택시팟 멤버들과 대화해보세요!',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: ThemeModel.highlightText(isDarkMode),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  '아동, 청소년, 그리고 성인을 대상으로 한 성범죄, 전기통신 금융 사기, 불법 음란·도박 정보 유통 등 명백한 불법행위와 '
                                  '렛츠머지 서비스의 안정성과 신뢰성을 위협하는 악의적인 이용 행위에 대해서는 즉시 렛츠머지 전체 서비스 이용이 '
                                  '영구적으로 제한될 수 있습니다.',
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: ThemeModel.sub5(isDarkMode),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                      builder: (context) => const ReportPage(),
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
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildMessageItem(BuildContext context, int index, bool isDarkMode,
      {required Chat message}) {
    final bool isUser = message.senderId == user!.id;
    debugPrint('$isUser');
    final DateTime createdAt = DateTime.parse(message.createdAt);
    final String formattedTime =
        DateFormat('a hh:mm', 'ko_KR').format(createdAt);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: isUser
            ? _buildMyMessage(message, formattedTime, isDarkMode)
            : _buildOtherMessage(message, formattedTime, isDarkMode),
      ),
    );
  }

  Widget _buildMyMessage(Chat message, String formattedTime, bool isDarkMode) {
    final String messageType = message.messageType;
    switch (messageType) {
      case 'account':
        return MyMessage(
          formattedTime: formattedTime,
          content: RequestMoneyMessage(),
        );
      case 'location':
        return MyMessage(
          formattedTime: formattedTime,
          content: LocationMessage(
            locationModel: LocationModel.fromJson(
              json.decode(
                message.content,
              ),
            ),
          ),
        );
      default:
        return MyMessage(
          formattedTime: formattedTime,
          content: TextMessage(
            content: message.content,
          ),
        );
    }
  }

  Widget _buildOtherMessage(
      Chat message, String formattedTime, bool isDarkMode) {
    final String messageType = message.messageType;
    final senderUser = ref.watch(userInfoProvider(message.senderId));
    final senderNickname = senderUser.nickname!;
    if (senderNickname == null) {

    }

    switch (messageType) {
      case 'account':
        return OtherMessage(
          senderNickname: senderNickname,
          formattedTime: formattedTime,
          content: RequestMoneyMessage(),
        );
      case 'location':
        return OtherMessage(
          senderNickname: senderNickname,
          formattedTime: formattedTime,
          content: LocationMessage(
            locationModel: LocationModel.fromJson(
              json.decode(
                message.content,
              ),
            ),
          ),
        );
      default:
        return OtherMessage(
          senderNickname: senderNickname,
          formattedTime: formattedTime,
          content: TextMessage(
            content: message.content,
          ),
        );
    }
  }

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

  void _showBottomSheet() {
    final isDarkMode = ref.read(themeProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ThemeModel.background(isDarkMode),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(0),
        ),
      ),
      builder: (BuildContext context) => _buildBottomSheetContent(isDarkMode),
    );
  }

  Widget _buildBottomSheetContent(bool isDarkMode) {
    return SafeArea(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                        TaxiGroupOpenAppPage(),
                                  ),
                                );
                              },
                              title: '택시 앱 열기',
                              icon: Icons.local_taxi,
                            ),
                            CListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        TaxiGroupRequestMoneyPage(),
                                  ),
                                );
                              },
                              title: '정산하기',
                              icon: Icons.attach_money,
                            ),
                            CListTile(
                              onTap: () {
                                _showLocationInputDialog(isDarkMode);
                              },
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

  void _showLocationInputDialog(bool isDarkMode) async {
    Position pos;
    try {
      pos = await Geolocator.getCurrentPosition();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('위치 조회에 실패했습니다: $e')),
      );
      return;
    }

    final locationModel = LocationModel(
      latitude: pos.latitude,
      longitude: pos.longitude,
      address: '',
      place: '',
    );

    // 팝업에서 위치 미리보기 + 공유 여부 확인
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return CDialog(
          title: '실시간 위치 공유',
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '정확한 위치와 오차가 발생할 수 있으니 주의하세요.',
                style: TextStyle(
                  fontSize: 12,
                  color: white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              CMapWidget(
                isDarkMode: isDarkMode,
                width: double.maxFinite,
                height: 200,
                initialLatitude: locationModel.latitude,
                initialLongitude: locationModel.longitude,
              ),
              const SizedBox(height: 8),
            ],
          ),
          buttons: [
            CButton(
              style: CButtonStyle.secondary(isDarkMode),
              size: CButtonSize.extraLarge,
              label: '취소',
              onTap: () => Navigator.pop(context),
            ),
            CButton(
              size: CButtonSize.extraLarge,
              label: '확인',
              onTap: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // LocationModel을 JSON으로 변환하여 전송
      _sendCustomMessage(jsonEncode(locationModel.toJson()), "location");
    }
  }

  void _sendCustomMessage(String text, String messageType) async {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
    );
    await ref.read(taxiGroupProvider.notifier).sendChatMessage(
          widget.taxiGroup,
          text,
          messageType,
          DateTime.now().toIso8601String(),
        );
  }

  void _sendMessage() async {
    if (_chatController.text.isNotEmpty) {
      final text = _chatController.text;
      const messageType = "text";
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
      );
      await ref.read(taxiGroupProvider.notifier).sendChatMessage(
          widget.taxiGroup,
          text,
          messageType,
          DateTime.now().toIso8601String());
      _chatController.clear();
    }
  }
}
