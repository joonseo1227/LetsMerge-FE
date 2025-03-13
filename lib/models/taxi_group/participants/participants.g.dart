// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participants.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ParticipantsImpl _$$ParticipantsImplFromJson(Map<String, dynamic> json) =>
    _$ParticipantsImpl(
      userId: json['participant_id'] as String,
      id: (json['id'] as num).toInt(),
      groupId: json['group_id'] as String,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$$ParticipantsImplToJson(_$ParticipantsImpl instance) =>
    <String, dynamic>{
      'participant_id': instance.userId,
      'id': instance.id,
      'group_id': instance.groupId,
      'created_at': instance.createdAt,
    };
