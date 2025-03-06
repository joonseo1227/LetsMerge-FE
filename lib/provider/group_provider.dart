import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/taxi_group/taxi_group.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaxiGroupNotifier extends StateNotifier<List<TaxiGroup>> {
  TaxiGroupNotifier() : super([]);

  final SupabaseClient _supabase = Supabase.instance.client;

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
    } catch (e) {
      debugPrint('알 수 없는 이유로 그룹 생성 실패: $e');
    }
  }

  Future<void> joinGroup(TaxiGroup taxiGroup) async {
    final User? user = _supabase.auth.currentUser;
    if (user == null) {
      debugPrint('로그인한 사용자가 없습니다.');
      return;
    }

    final Map<String, dynamic> taxiGroupData = await _supabase
        .from('taxigroups')
        .select('participants, seater')
        .eq('group_id', taxiGroup.groupId!)
        .single();

    // 기존의 participants 리스트를 불러오고, 없으면 빈 리스트로 초기화
    List<dynamic> currentParticipants = taxiGroupData['participants'] ?? [];
    List<String> participants = currentParticipants.cast<String>();

    int seats = taxiGroupData['remainingSeats'] ?? 0;

    // 그룹 생성자인지 확인
    if (taxiGroup.creatorUserId == user.id) {
      debugPrint('생성자입니다.');
      return;
    }

    // 이미 사용자가 참여 중인지 확인
    if (participants.contains(user.id)) {
      debugPrint('이미 참여한 사용자입니다.');
      return;
    }

    if (seats == 0) {
      debugPrint("남은 좌석이 없습니다.");
    } else {
      // user id를 participants 리스트에 추가
      participants.add(user.id);

      final int remainingSeats = seats - 1;

      // taxiGroup 업데이트
      final updateResponse = await _supabase.from('taxigroups').update({
        'participants': participants,
        'remaining_seats': remainingSeats,
      }).eq('group_id', taxiGroup.groupId!);

      debugPrint('그룹 참가 및 좌석 업데이트 성공: $updateResponse');
    }
  }

  Future<void> leaveGroup(TaxiGroup taxiGroup) async {
    final User? user = _supabase.auth.currentUser;
    if (user == null) {
      debugPrint('로그인한 사용자가 없습니다.');
      return;
    }

    final Map<String, dynamic> taxiGroupData = await _supabase
        .from('taxigroups')
        .select('participants, seater')
        .eq('group_id', taxiGroup.groupId!)
        .single();

    // 기존의 participants 리스트를 불러오고, 없으면 빈 리스트로 초기화
    List<dynamic> currentParticipants = taxiGroupData['participants'] ?? [];
    List<String> participants = currentParticipants.cast<String>();

    int seats = taxiGroupData['remainingSeats'] ?? 0;

    if (seats == 0) {
      print("떠날 유저 정보가 없습니다.");
    } else {
      // user id를 participants 리스트에서 제거
      participants.remove(user.id);

      final int remainingSeats = seats + 1;

      // taxiGroup 업데이트
      final updateResponse = await _supabase.from('taxigroups').update({
        'participants': participants,
        'remaining_seats': remainingSeats,
      }).eq('group_id', taxiGroup.groupId!);

      debugPrint('그룹 나가기 및 좌석 업데이트 성공: $updateResponse');
    }
  }
}

final taxiGroupProvider =
    StateNotifierProvider<TaxiGroupNotifier, List<TaxiGroup>>((ref) {
  return TaxiGroupNotifier();
});
