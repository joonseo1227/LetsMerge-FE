import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserDTO {
  final String uid;
  final String email;
  final String? displayName;

  UserDTO({
    required this.uid,
    required this.email,
    this.displayName,
  });

  // Firebase User 객체를 UserDTO로 변환하는 팩토리 메서드
  factory UserDTO.fromFirebaseUser(firebase_auth.User firebaseUser) {
    return UserDTO(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
    );
  }
}