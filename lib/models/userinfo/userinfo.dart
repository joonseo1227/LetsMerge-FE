import 'package:freezed_annotation/freezed_annotation.dart';

part 'userinfo.freezed.dart';
part 'userinfo.g.dart';

@freezed
class UserInfo with _$UserInfo {
  const factory UserInfo({
    @JsonKey(name: 'id') required String userId,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'nickname') required String nickname,
    @JsonKey(name: 'avatar_url') required String? avatarUrl,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _UserInfo;

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
}
