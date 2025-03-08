import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/taxi_group/taxi_group.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaxiGroupNotifier extends StateNotifier<List<TaxiGroup>> {
  TaxiGroupNotifier() : super([]) {
    initializeRealtimeSubscription();
  }

  final SupabaseClient _supabase = Supabase.instance.client;

  RealtimeChannel? _groupSubscription;


  // 그룹 관련 realtime 구독 설정
  void initializeRealtimeSubscription() {
    _groupSubscription = _supabase
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
    _groupSubscription?.unsubscribe();
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

      // 각 항목의 모든 필드 출력 (디버그용)
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
        .select('participants, seater, remaining_seats')
        .eq('group_id', taxiGroup.groupId!)
        .single();

    // 기존의 participants 리스트를 불러오고, 없으면 빈 리스트로 초기화
    List<dynamic> currentParticipants = taxiGroupData['participants'] ?? [];
    List<String> participants = currentParticipants.cast<String>();

    int seats = taxiGroupData['remaining_seats'] ?? 0;

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
        .select('participants, seater, remaining_seats')
        .eq('group_id', taxiGroup.groupId!)
        .single();

    // 기존의 participants 리스트를 불러오고, 없으면 빈 리스트로 초기화
    List<dynamic> currentParticipants = taxiGroupData['participants'] ?? [];
    List<String> participants = currentParticipants.cast<String>();

    int seats = taxiGroupData['remaining_seats'] ?? 0;

    if (seats == 0) {
      debugPrint("떠날 유저 정보가 없습니다.");
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

  Stream<List<Map<String, dynamic>>> chatMessagesStream(TaxiGroup taxiGroup) {
    return _supabase
        .from('chats')
        .stream(primaryKey: ['message_id'])
        .eq('group_id', taxiGroup.groupId!)
        .order('created_at', ascending: false);
  }

  Future<void> sendChatMessage(
    TaxiGroup taxiGroup,
    String content,
    String messageType,
    String time,
  ) async {
    final User? user = _supabase.auth.currentUser;
    final String senderId = user!.id;
    try {
      await _supabase.from('chats').insert({
        'group_id': taxiGroup.groupId,
        'sender_id': senderId,
        'content': content,
        'message_type': messageType,
        'created_at': time,
      });
      debugPrint("Insert 성공");
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }

  //특정 채팅 메시지를 읽음 처리하는 함수
  Future<void> readChatMessage(String messageId) async {
    try {
      await _supabase.from('chats').update({
        'is_read': true,
      }).eq('message_id', messageId);
    } catch (e) {
      debugPrint('Error reading message $e');
    }
  }
}

final taxiGroupProvider =
    StateNotifierProvider<TaxiGroupNotifier, List<TaxiGroup>>((ref) {
  return TaxiGroupNotifier();
});
