import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/user_model.dart';

class UserNotifier extends StateNotifier<UserDTO?> {
  UserNotifier() : super(UserDTO(uid: '123', email: 'test@example.com'));

  void addAccount(Account account) {
    if (state != null) {
      state = state!.copyWith(
        accounts: [...state!.accounts, account],
      );
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserDTO?>((ref) {
  return UserNotifier();
});