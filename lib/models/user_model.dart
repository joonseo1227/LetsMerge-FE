class Account {
  final String accountNumber;
  final String bankName;

  Account({
    required this.accountNumber,
    required this.bankName,
  });
}

class UserDTO {
  final String id;
  final String email;
  final String? name;
  final String? nickname;
  final String? createdAt;
  final String? avatarUrl;
  final List<Account>? accounts;

  UserDTO({
    required this.id,
    required this.email,
    this.name,
    this.nickname,
    this.createdAt,
    this.avatarUrl,
    this.accounts = const [],
  });

  UserDTO copyWith({
    String? id,
    String? email,
    String? name,
    String? nickname,
    String? createdAt,
    String? avatarUrl,
    List<Account>? accounts,
  }) {
    return UserDTO(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      createdAt: createdAt ?? this.createdAt,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      accounts: accounts ?? this.accounts,
    );
  }
}
