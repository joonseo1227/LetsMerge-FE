import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProvider {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// 지정한 필드의 데이터를 가져오는 공통 함수
  Future<T?> _getUserField<T>(String field) async {
    final User? user = _supabase.auth.currentUser;

    if (user == null) {
      debugPrint('유저가 로그인되지 않았습니다.');
      return null;
    }

    try {
      final response = await _supabase
          .from('userinfo')
          .select(field)
          .eq('id', user.id)
          .maybeSingle();

      debugPrint('데이터 가져오기 성공: $response');

      return response?[field] as T?;
    } catch (error) {
      debugPrint('데이터 가져오기 실패: $error');
      return null;
    }
  }

  /// 이메일을 가져오는 함수
  Future<String?> getUserEmail() => _getUserField<String>('email');

  /// 이름을 가져오는 함수
  String? getUserName() {
    final User? user = _supabase.auth.currentUser;
    return user?.userMetadata?['name'];
  }

  /// 닉네임을 가져오는 함수
  Future<String?> getUserNickname() => _getUserField<String>('nickname');

  /// 계정 생성 날짜를 가져오는 함수
  Future<String?> getUserCreatedAt() => _getUserField<String>('created_at');

  /// 프로필 이미지 URL을 가져오는 함수
  Future<String?> getUserProfileImageUrl() =>
      _getUserField<String>('avatar_url');

  Future<void> _updateUserField(String field, String data) async {
    final User? user = _supabase.auth.currentUser;

    if (user == null) {
      debugPrint('유저가 로그인되지 않았습니다.');
      return;
    }

    try {
      await _supabase
          .from('userinfo')
          .update({field: data})
          .eq('id', user.id)
          .maybeSingle();

      debugPrint('데이터 업데이트 성공: {$field: $data}');
    } catch (error) {
      debugPrint('데이터 업데이트 실패: $error');
      return;
    }
  }

  Future<void> updateUserNickname(String nickname) =>
      _updateUserField('nickname', nickname);

  Future<void> updateUserProfileImg(String profileUrl) =>
      _updateUserField('avatar_url', profileUrl);
}
