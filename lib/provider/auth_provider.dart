import 'package:flutter/foundation.dart';
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

  /// 현재 사용자 초기화
  void _initializeUser() {
    final firebaseUser = _auth.currentUser;
    state =
        firebaseUser != null ? UserDTO.fromFirebaseUser(firebaseUser) : null;
  }

  /// 이메일 및 암호로 로그인
  Future<void> signInWithEmail(String email, String password) async {
    try {
      final firebase_auth.UserCredential result =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = UserDTO.fromFirebaseUser(result.user!);
    } catch (e) {
      debugPrint('Error signInWithEmail: $e');
      rethrow;
    }
  }

  /// 이메일 및 암호로 계정 생성 + 이름 설정
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
        state = UserDTO.fromFirebaseUser(_auth.currentUser!);
      }
    } catch (e) {
      debugPrint('Error signUpWithEmail: $e');
      rethrow;
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      state = null;
    } catch (e) {
      debugPrint('Error signOut: $e');
      rethrow;
    }
  }

  /// 이름 업데이트
  Future<void> updateName(String name) async {
    try {
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        await firebaseUser.updateDisplayName(name);
        await firebaseUser.reload();
        state = UserDTO.fromFirebaseUser(firebaseUser);
      }
    } catch (e) {
      debugPrint('Error updateName: $e');
      rethrow;
    }
  }

  /// 계정 삭제
  Future<void> deleteAccount(String email, String password) async {
    try {
      // 재인증 수행
      await reauthenticate(email, password);

      // 계정 삭제
      final firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        await firebaseUser.delete();
        state = null;
      }
    } catch (e) {
      debugPrint('Error deleting account: $e');
      rethrow;
    }
  }

  /// 재인증
  Future<void> reauthenticate(String email, String password) async {
    try {
      final credential = firebase_auth.EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await _auth.currentUser?.reauthenticateWithCredential(credential);
      debugPrint('Re-authentication successful');
    } catch (e) {
      debugPrint('Error during re-authentication: $e');
      rethrow;
    }
  }
}
