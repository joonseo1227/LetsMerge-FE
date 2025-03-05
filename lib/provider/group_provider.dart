import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/taxi_group/taxi_group.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaxiGroupNotifier extends StateNotifier<List<TaxiGroup>> {
  TaxiGroupNotifier() : super([]);

  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> fetchTaxiGroups() async {}

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
