import 'package:freezed_annotation/freezed_annotation.dart';

part 'accounts.freezed.dart';
part 'accounts.g.dart';

@freezed
class Accounts with _$Accounts {
  const factory Accounts({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'bank') required String bankName,
    @JsonKey(name: 'account') required String account,
    @JsonKey(name: 'default') required bool isDefault,
  }) = _Accounts;

  factory Accounts.fromJson(Map<String, dynamic> json) => _$AccountsFromJson(json);
}
