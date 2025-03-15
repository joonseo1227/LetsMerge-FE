// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatImpl _$$ChatImplFromJson(Map<String, dynamic> json) => _$ChatImpl(
      groupId: json['group_id'] as String,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      isRead: json['is_read'] as bool,
      messageType: json['message_type'] as String,
      createdAt: json['created_at'] as String,
      messageId: json['message_id'] as String,
    );

Map<String, dynamic> _$$ChatImplToJson(_$ChatImpl instance) =>
    <String, dynamic>{
      'group_id': instance.groupId,
      'sender_id': instance.senderId,
      'content': instance.content,
      'is_read': instance.isRead,
      'message_type': instance.messageType,
      'created_at': instance.createdAt,
      'message_id': instance.messageId,
    };
