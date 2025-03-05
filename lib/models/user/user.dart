import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    @JsonKey(name: 'id') required String userId,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'nickname') required String nickname,
    @JsonKey(name: 'avatar_url') required String avatarUrl,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}