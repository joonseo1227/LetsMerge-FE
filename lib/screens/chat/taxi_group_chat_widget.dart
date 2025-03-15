import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/location_model.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/taxi_group/taxi_group_split_money_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_map_widget.dart';

Color getMessageTextColor(BuildContext context, bool isDarkMode) {
  // 상위 위젯 중에 MyMessage가 있는지 확인
  final isMyMessage =
      context.findAncestorWidgetOfExactType<MyMessage>() != null;

  return isMyMessage
      ? white // MyMessage일 때의 색상
      : ThemeModel.text(isDarkMode); // 기본 색상
}

/// 정산 메시지
class RequestMoneyMessage extends ConsumerStatefulWidget {
  const RequestMoneyMessage({super.key});

  @override
  ConsumerState<RequestMoneyMessage> createState() =>
      _RequestMoneyMessageState();
}

class _RequestMoneyMessageState extends ConsumerState<RequestMoneyMessage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '우리 정산해요💸',
          style: TextStyle(
            fontSize: 16,
            color: getMessageTextColor(context, isDarkMode),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        CButton(
          label: '정산하기',
          width: double.maxFinite,
          size: CButtonSize.medium,
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => TaxiGroupSplitMoneyPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class LocationMessageGlobalKeys {
  static final Map<String, GlobalKey<CMapWidgetState>> _keys = {};

  static GlobalKey<CMapWidgetState> getKey(String messageId) {
    if (!_keys.containsKey(messageId)) {
      _keys[messageId] = GlobalKey<CMapWidgetState>();
    }
    return _keys[messageId]!;
  }

  static void removeKey(String messageId) {
    _keys.remove(messageId);
  }
}

class LocationMessage extends ConsumerStatefulWidget {
  final LocationModel locationModel;
  final String messageId;

  const LocationMessage({
    super.key,
    required this.locationModel,
    required this.messageId,
  });

  @override
  ConsumerState<LocationMessage> createState() => _LocationMessageState();
}

class _LocationMessageState extends ConsumerState<LocationMessage>
    with AutomaticKeepAliveClientMixin {
  late final GlobalKey<CMapWidgetState> _mapKey;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _mapKey = LocationMessageGlobalKeys.getKey(widget.messageId);
  }

  @override
  void dispose() {
    LocationMessageGlobalKeys.removeKey(widget.messageId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDarkMode = ref.watch(themeProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '제 위치예요📍',
          style: TextStyle(
            fontSize: 16,
            color: getMessageTextColor(context, isDarkMode),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        CMapWidget(
          key: _mapKey,
          height: 200,
          width: 300,
          initialLatitude: widget.locationModel.latitude,
          initialLongitude: widget.locationModel.longitude,
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }
}

/// 텍스트 메시지
class TextMessage extends ConsumerStatefulWidget {
  final String content;

  const TextMessage({
    super.key,
    required this.content,
  });

  @override
  ConsumerState<TextMessage> createState() => _TextMessageState();
}

class _TextMessageState extends ConsumerState<TextMessage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    return Text(
      widget.content,
      style: TextStyle(
        fontSize: 16,
        color: getMessageTextColor(context, isDarkMode),
      ),
    );
  }
}

/// 내 메시지
class MyMessage extends ConsumerStatefulWidget {
  final String formattedTime;
  final Widget content;

  const MyMessage({
    super.key,
    required this.formattedTime,
    required this.content,
  });

  @override
  ConsumerState<MyMessage> createState() => _MyMessageState();
}

class _MyMessageState extends ConsumerState<MyMessage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
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
              widget.formattedTime,
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
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: ThemeModel.highlightText(isDarkMode),
                ),
                child: widget.content,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 타인 메시지
class OtherMessage extends ConsumerStatefulWidget {
  final String senderNickname;
  final String formattedTime;
  final Widget content;

  const OtherMessage({
    super.key,
    required this.senderNickname,
    required this.formattedTime,
    required this.content,
  });

  @override
  ConsumerState<OtherMessage> createState() => _OtherMessageState();
}

class _OtherMessageState extends ConsumerState<OtherMessage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 프로필 이미지
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
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 유저 이름
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                widget.senderNickname,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: ThemeModel.surface(isDarkMode),
                    ),
                    child: widget.content,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.formattedTime,
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
}
