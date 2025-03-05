// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      userId: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      nickname: json['nickname'] as String,
      avatarUrl: json['avatar_url'] as String,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.userId,
      'email': instance.email,
      'name': instance.name,
      'nickname': instance.nickname,
      'avatar_url': instance.avatarUrl,
      'created_at': instance.createdAt,
    };
