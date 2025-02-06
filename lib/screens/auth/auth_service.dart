import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse> signInWithEmailPassword(
      String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmailPassword(
      String email, String password, String name) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'name': name,
      }
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<void> deleteUser(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        debugPrint("로그인 실패: 이메일 또는 비밀번호가 일치하지 않습니다.");
        return;
      } else {
        await _supabase.from('userinfo').delete().eq('id', user.id);
        await _supabase.auth.signOut();
      }
    } catch (e) {
      debugPrint("error: delete a user failure");
      debugPrint("$e");
    }
  }
}