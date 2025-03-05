import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/taxi_group/taxi_group.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaxiGroupNotifier extends StateNotifier<List<TaxiGroup>> {
  TaxiGroupNotifier() : super([]);

  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> fetchTaxiGroups() async {
    final User? user = _supabase.auth.currentUser;

    if (user != null) {
      final response = await _supabase.from('taxigroups')
          .select()
          .eq('host_id', user.id);

      debugPrint('데이터 가져오기 성공: $response');
    }
  }

  Future<void> createTaxiGroup(TaxiGroup taxiGroup) async {
    final Map<String, dynamic> data = taxiGroup.toJson();

    try {
      await _supabase.from('taxigroups').insert(data);

      debugPrint('택시 그룹 생성 성공');
    } on FormatException catch (e) {
      debugPrint('데이터 형식 오류: $e');
    } on SocketException catch (_) {
      debugPrint('네트워크 연결을 확인해주세요.');
    } on TimeoutException catch (_) {
      debugPrint('요청 시간이 초과되었습니다. 다시 시도해주세요.');
    }  catch(e) {
      debugPrint('알 수 없는 이유로 그룹 생성 실패: $e');
    }
  }
}

final taxiGroupProvider =
    StateNotifierProvider<TaxiGroupNotifier, List<TaxiGroup>>((ref) {
  return TaxiGroupNotifier();
});
