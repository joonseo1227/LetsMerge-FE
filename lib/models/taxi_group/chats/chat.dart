import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

@freezed
class Chat with _$Chat {
  const factory Chat({
    @JsonKey(name: 'group_id') required String groupId,
    @JsonKey(name: 'sender_id') required String senderId,
    @JsonKey(name: 'content') required String content,
    @JsonKey(name: 'is_read') required bool isRead,
    @JsonKey(name: 'message_type') required String messageType,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
}
