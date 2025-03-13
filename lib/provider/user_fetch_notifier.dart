import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/userinfo/accounts/accounts.dart';
import 'package:letsmerge/models/userinfo/userinfo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserInfoNotifier extends StateNotifier<UserInfo> {
  final SupabaseClient _supabase;
  final String userId;
  StreamSubscription<List<Map<String, dynamic>>>? _subscription;

  UserInfoNotifier(this._supabase, this.userId)
      : super(UserInfo(
          userId: '',
          email: '',
          name: '',
          nickname: '',
          avatarUrl: '',
          createdAt: '',
        )) {
    _watchUserInfo();
  }

  void _watchUserInfo() {
    _subscription = _supabase
        .from('userinfo')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .listen((data) {
          if (data.isEmpty) {
            state;
          } else {
            state = UserInfo.fromJson(data.first);
          }
        });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class UserAccountsNotifier extends StateNotifier<List<Accounts>> {
  final SupabaseClient _supabase;
  final String userId;
  StreamSubscription<List<Map<String, dynamic>>>? _subscription;

  UserAccountsNotifier(this._supabase, this.userId) : super([]) {
    _watchUserInfo();
  }

  void _watchUserInfo() {
    _subscription = _supabase
        .from('accounts')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .listen((data) {
          state = data.map((e) => Accounts.fromJson(e)).toList();
        });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final supabaseProvider = Provider((ref) => Supabase.instance.client);

final userInfoProvider =
    StateNotifierProvider.family<UserInfoNotifier, UserInfo, String>(
  (ref, userId) {
    final supabase = ref.watch(supabaseProvider);
    return UserInfoNotifier(supabase, userId);
  },
);

final userAccountsProvider =
    StateNotifierProvider.family<UserAccountsNotifier, List<Accounts>, String>(
  (ref, userId) {
    final supabase = ref.watch(supabaseProvider);
    return UserAccountsNotifier(supabase, userId);
  },
);
