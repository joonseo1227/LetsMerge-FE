// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountsImpl _$$AccountsImplFromJson(Map<String, dynamic> json) =>
    _$AccountsImpl(
      userId: json['user_id'] as String,
      bankName: json['bank'] as String,
      account: json['account'] as String,
      isDefault: json['default'] as bool,
    );

Map<String, dynamic> _$$AccountsImplToJson(_$AccountsImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'bank': instance.bankName,
      'account': instance.account,
      'default': instance.isDefault,
    };
