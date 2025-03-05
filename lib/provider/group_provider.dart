import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/taxi_group/taxi_group.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaxiGroupNotifier extends StateNotifier<List<TaxiGroup>> {
  TaxiGroupNotifier() : super([]);

  final SupabaseClient _supabase = Supabase.instance.client;
  RealtimeChannel? _subscription;

  void initializeRealtimeSubscription() {
    _subscription = _supabase
        .channel('public:taxigroups')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'taxigroups',
          callback: (payload) {
            fetchTaxiGroups();
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    _subscription?.unsubscribe();
    super.dispose();
  }

  Future<void> fetchTaxiGroups() async {
    try {
      final response = await _supabase.from('taxigroups').select();

      if (response == null) {
        state = [];
        return;
      }

      debugPrint('전체 응답: $response');

      // 각 항목의 모든 필드 출력
      for (var item in response) {
        debugPrint('=== 항목 상세 정보 ===');
        item.forEach((key, value) {
          debugPrint('$key: $value (${value.runtimeType})');
        });
        debugPrint('=====================');
      }

      final List<TaxiGroup> groups = [];
      for (var item in response) {
        try {
          // 데이터 변환 전에 host_clothes 처리
          if (item['host_clothes'] != null && item['host_clothes'] is String) {
            try {
              item['host_clothes'] = jsonDecode(item['host_clothes'] as String);
            } catch (e) {
              debugPrint('host_clothes JSON 파싱 실패: $e');
              item['host_clothes'] = [];
            }
          }

          final group = TaxiGroup.fromJson(Map<String, dynamic>.from(item));
          groups.add(group);
        } catch (e, stack) {
          debugPrint('항목 파싱 실패: $e');
          debugPrint('스택 트레이스:\n$stack');
        }
      }

      state = groups;
      debugPrint('성공적으로 로드된 그룹 수: ${groups.length}');
    } catch (e, stackTrace) {
      debugPrint('택시 그룹 조회 실패: $e');
      debugPrint('스택 트레이스: $stackTrace');
      rethrow;
    }
  }

  Future<void> createTaxiGroup(TaxiGroup taxiGroup) async {
    final Map<String, dynamic> data = taxiGroup.toJson();

    final response = await _supabase.from('taxigroups').insert(data);
    if (response.error != null) {
      debugPrint('택시 그룹 삽입 실패: ${response.error!.message}');
    } else {
      debugPrint('택시 그룹 삽입 성공: $response');
    }
  }
}

final taxiGroupProvider =
    StateNotifierProvider<TaxiGroupNotifier, List<TaxiGroup>>((ref) {
  return TaxiGroupNotifier();
});
