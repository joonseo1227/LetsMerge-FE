import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class Account {
  final String accountNumber;
  final String bankName;

  Account({
    required this.accountNumber,
    required this.bankName,
  });
}

class UserDTO {
  final String uid;
  final String email;
  final String? displayName;
  final List<Account> accounts;

  UserDTO({
    required this.uid,
    required this.email,
    this.displayName,
    this.accounts = const [],
  });

  // Firebase User 객체를 UserDTO로 변환
  factory UserDTO.fromFirebaseUser(firebase_auth.User firebaseUser) {
    return UserDTO(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
    );
  }

  UserDTO copyWith({
    String? uid,
    String? email,
    String? displayName,
    List<Account>? accounts,
  }) {
    return UserDTO(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      accounts: accounts ?? this.accounts,
    );
  }
}
