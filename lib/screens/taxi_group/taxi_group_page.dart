import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/taxi_group/taxi_group.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/group_provider.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/main/main_page.dart';
import 'package:letsmerge/screens/report_page.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_open_app_page.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_split_money_page.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_list_tile.dart';
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
    final taxiGroupNotifier = ref.read(taxiGroupProvider.notifier);

    return Hero(
      tag: 'taxiGroup',
      child: Scaffold(
        appBar: _buildAppBar(isDarkMode),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream:
                        taxiGroupNotifier.chatMessagesStream(widget.taxiGroup),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final messages = snapshot.data!;
                      print(snapshot.data);
                      return messages.isNotEmpty
                          ? ListView.builder(
                              controller: _scrollController,
                              reverse: true,
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                              itemCount: messages.length,
                              itemBuilder: (context, index) =>
                                  _buildMessageItem(
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
                                      color:
                                          ThemeModel.highlightText(isDarkMode),
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  Text(
                                    '아동 · 청소년 및 성인을 대상으로 한 성범죄, 전기통신금융사기, 불법적인 음란 · 도박 정보 유통 등 '
                                    '명백한 불법행위 및 카카오톡 서비스의 안정성 및 신뢰성을 위협하는 악의적인 서비스 이용행위에 대해서는 '
                                    '즉시 카카오톡 전체 서비스에 대한 이용을 영구적으로 제한할 수 있습니다.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: ThemeModel.sub5(isDarkMode),
                                    ),
                                  ),
                                ],
                              ),
                            );
                    },
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

  Widget _buildMessageItem(BuildContext context, int index, bool isDarkMode,
      {required Map<String, dynamic> message}) {
    final bool isUser =
        message['sender_id'] == user!.id;
    final DateTime createdAt = DateTime.parse(message['created_at']);
    final String formattedTime =
        DateFormat('a hh:mm', 'ko_KR').format(createdAt);
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
                  message['content']!,
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

  Widget _buildOtherMessage(
      Map<String, dynamic> message, String formattedTime, bool isDarkMode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Container(
            width: 40,
            height: 40,
            decoration:
                const ShapeDecoration(color: blue20, shape: CircleBorder()),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                message['sender_id']!,
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
                      message['content']!,
                      style: TextStyle(
                        fontSize: 16,
                        color: ThemeModel.text(isDarkMode),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
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

  void _sendMessage() async {
    if (_chatController.text.isNotEmpty) {
      final text = _chatController.text;
      final messageType = "text";
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

  void _showBottomSheet() {
    final isDarkMode = ref.read(themeProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ThemeModel.background(isDarkMode),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
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
                              icon: Icons.attach_money,
                            ),
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
