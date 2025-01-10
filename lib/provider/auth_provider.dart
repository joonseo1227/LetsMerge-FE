import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<User?> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthNotifier() : super(null) {
    _initializeUser();
    _auth.authStateChanges().listen((user) {
      state = user;
    });
  }

  // 현재 사용자 초기화
  void _initializeUser() {
    state = _auth.currentUser;
  }

  // 이메일 및 비밀번호로 로그인
  Future<void> signInWithEmail(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = result.user;
    } catch (e) {
      print('로그인 실패: $e');
      rethrow;
    }
  }

  // 이메일 및 비밀번호로 회원가입 + 닉네임 설정
  Future<void> signUpWithEmail(String email, String password, String nickname) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      if (user != null) {
        await user.updateDisplayName(nickname);
        await user.reload();
        state = _auth.currentUser;
      }
    } catch (e) {
      print('회원가입 실패: $e');
      rethrow;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      state = null;
    } catch (e) {
      print('로그아웃 실패: $e');
      rethrow;
    }
  }

  // 닉네임 업데이트
  Future<void> updateNickname(String nickname) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(nickname);
        await user.reload();
        state = _auth.currentUser;
      }
    } catch (e) {
      print('닉네임 업데이트 실패: $e');
      rethrow;
    }
  }

  // 회원탈퇴 (이메일 재인증 후 삭제)
  Future<void> deleteAccount(String email, String password) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
        await user.delete();
        state = null;
      }
    } catch (e) {
      print('회원탈퇴 실패: $e');
      rethrow;
    }
  }
}