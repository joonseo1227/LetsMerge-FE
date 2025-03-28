import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/models/userinfo/userinfo.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserNotifier extends StateNotifier<List<UserInfo>> {
  UserNotifier() : super([]);
  final SupabaseClient _supabase = Supabase.instance.client;
  final User? user = Supabase.instance.client.auth.currentUser;

  Future<void> _updateUserInfo(
      BuildContext context, WidgetRef ref, String field, String data) async {
    if (user == null) {
      debugPrint('유저가 로그인되지 않았습니다.');
      return;
    }

    runWithErrorHandling(context, ref, () async {
      await _supabase
          .from('userinfo')
          .upsert({'id': user!.id, field: data}).single();

      debugPrint('데이터 업데이트 성공: {$field: $data}');
    });
  }

  Future<void> updateUserNickname(
          BuildContext context, WidgetRef ref, String nickname) =>
      _updateUserInfo(context, ref, 'nickname', nickname);

  Future<void> updateUserProfileImg(
          BuildContext context, WidgetRef ref, String profileUrl) =>
      _updateUserInfo(context, ref, 'avatar_url', profileUrl);

  Future<void> insertUserAccount(BuildContext context, WidgetRef ref,
      String bank, String account, bool isdefault) async {
    if (user == null) {
      debugPrint('유저가 로그인되지 않았습니다.');
      return;
    }

    await runWithErrorHandling(context, ref, () async {
      await _supabase.from('accounts').insert({
        'user_id': user!.id,
        'bank': bank,
        'account': account,
        'default': isdefault
      });

      debugPrint('데이터 삽입 성공');
    });
  }

  Future<T?> runWithErrorHandling<T>(
    BuildContext context,
    WidgetRef ref,
    Future<T> Function() operation,
  ) async {
    try {
      return await operation();
    } on FormatException {
      alertDialog(context, ref, "데이터 형식 오류");
    } on SocketException {
      alertDialog(context, ref, "네트워크 연결 상태를 확인하세요.");
    } on PostgrestException catch (e) {
      alertDialog(context, ref, "데이터 처리 오류: ${e.message}");
      debugPrint("$e");
      debugPrint(user!.id);
    } on Exception catch (e) {
      alertDialog(context, ref, "알 수 없는 오류가 발생했습니다: $e");
    }
    return null;
  }

  void alertDialog(BuildContext context, WidgetRef ref, String content) {
    final isDarkMode = ref.watch(themeProvider);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CDialog(
          title: '에러',
          content: Text(
            content,
            style: TextStyle(
              color: ThemeModel.text(isDarkMode),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          buttons: [
            CButton(
              size: CButtonSize.extraLarge,
              label: '확인',
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

final userProvider = StateNotifierProvider<UserNotifier, List<UserInfo>>((ref) {
  return UserNotifier();
});
