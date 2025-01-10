import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:letsmerge/models/user_model.dart';

final authProvider = StateNotifierProvider<AuthNotifier, UserDTO?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<UserDTO?> {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  AuthNotifier() : super(null) {
    _initializeUser();
    _auth.authStateChanges().listen((firebaseUser) {
      state =
          firebaseUser != null ? UserDTO.fromFirebaseUser(firebaseUser) : null;
    });
  }

  // 현재 사용자 초기화
  void _initializeUser() {
    final firebaseUser = _auth.currentUser;
    state =
        firebaseUser != null ? UserDTO.fromFirebaseUser(firebaseUser) : null;
  }

  // 이메일 및 암호로 로그인
  Future<void> signInWithEmail(String email, String password) async {
    try {
      final firebase_auth.UserCredential result =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = UserDTO.fromFirebaseUser(result.user!);
    } catch (e) {
      print('로그인 실패: $e');
      rethrow;
    }
  }

  // 이메일 및 암호로 회원가입 + 이름 설정
  Future<void> signUpWithEmail(
      String email, String password, String name) async {
    try {
      final firebase_auth.UserCredential result =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = result.user;
      if (firebaseUser != null) {
        await firebaseUser.updateDisplayName(name);
        await firebaseUser.reload();
        state = UserDTO.fromFirebaseUser(firebaseUser);
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

  // 이름 업데이트
  Future<void> updateName(String name) async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        await firebaseUser.updateDisplayName(name);
        await firebaseUser.reload();
        state = UserDTO.fromFirebaseUser(firebaseUser);
      }
    } catch (e) {
      print('이름 업데이트 실패: $e');
      rethrow;
    }
  }
}
