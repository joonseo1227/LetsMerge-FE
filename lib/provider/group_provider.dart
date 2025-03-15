import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/taxi_group/chats/chat.dart';
import 'package:letsmerge/models/taxi_group/taxi_group.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_dialog.dart';
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

    int seats = taxiGroup.remainingSeats;

    if (seats == 0) {
      debugPrint("남은 좌석이 없습니다.");
    } else {
      final int remainingSeats = seats - 1;

      // taxiGroup 업데이트
      final participantInsert = await _supabase.from('participants').insert({
        'group_id': taxiGroup.groupId,
        'participant_id': user.id,
      });

      final seatsUpdate = await _supabase.from('taxigroups').update({
        'remaining_seats': remainingSeats,
      }).eq('group_id', taxiGroup.groupId!);

      debugPrint('그룹 참가 및 좌석 업데이트 성공: $participantInsert, $seatsUpdate');
    }
  }

  Future<void> checkGroup(TaxiGroup taxiGroup) async {
    final User? user = _supabase.auth.currentUser;
    if (user == null) {
      debugPrint('로그인한 사용자가 없습니다.');
      return;
    }

    // 그룹 생성자인지 확인
    if (taxiGroup.creatorUserId == user.id) {
      debugPrint('그룹 생성자입니다.');
      return;
    }

    // 그룹 참가자 데이터
    final Map<String, dynamic> participantsData = await _supabase
        .from('participants')
        .select('participant_id')
        .eq('group_id', taxiGroup.groupId!)
        .single();

    // 이미 사용자가 참여 중인지 확인
    if (participantsData['participant_id'] == user.id) {
      debugPrint('이미 참여한 사용자입니다.');
      return;
    }
  }

  Future<void> leaveGroup(TaxiGroup taxiGroup) async {
    final User? user = _supabase.auth.currentUser;
    if (user == null) {
      debugPrint('로그인한 사용자가 없습니다.');
      return;
    }

    int seats = taxiGroup.remainingSeats;

    // 그룹 참가자 데이터
    final Map<String, dynamic> participantsData = await _supabase
        .from('participants')
        .select('participant_id')
        .eq('group_id', taxiGroup.groupId!)
        .single();

    if (participantsData['participant_id'] != user.id) {
      debugPrint("떠날 유저 정보가 없습니다.");
    } else {
      final int remainingSeats = seats + 1;

      // taxiGroup 업데이트
      final participantDelete = await _supabase
          .from('participants')
          .delete()
          .eq('participant_id', user.id);

      final seatsUpdate = await _supabase.from('taxigroups').update({
        'remaining_seats': remainingSeats,
      }).eq('group_id', taxiGroup.groupId!);

      debugPrint('그룹 나가기 및 좌석 업데이트 성공: $participantDelete, $seatsUpdate');
    }
  }

  Stream<List<Map<String, dynamic>>> fetchParticipant(TaxiGroup taxiGroup) {
    return _supabase
        .from('participants')
        .stream(primaryKey: ['group_id'])
        .eq('group_id', taxiGroup.groupId!)
        .order('created_at', ascending: false);
  }

  // 실시간 채팅 메시지 스트림 (Realtime 채널 구독)
  Stream<List<Map<String, dynamic>>> chatMessagesStream(TaxiGroup taxiGroup) {
    final controller = StreamController<List<Map<String, dynamic>>>();

    // 현재 채팅 메시지 목록을 가져오는 함수
    Future<void> fetchMessages() async {
      final response = await _supabase
          .from('chats')
          .select()
          .eq('group_id', taxiGroup.groupId!)
          .order('created_at', ascending: false);
      controller.add(response.cast<Map<String, dynamic>>());
        }

    // 최초 메시지 로드
    fetchMessages();

    // 실시간 구독 설정
    final RealtimeChannel channel = _supabase
        .channel('chat_messages:${taxiGroup.groupId!}')
        .onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'chats',
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'group_id',
        value: taxiGroup.groupId!,
      ),
      callback: (payload) async {
        debugPrint('Realtime event received: ${payload.toString()}');

        await fetchMessages();
      },
    )
        .subscribe();

    controller.onCancel = () {
      channel.unsubscribe();
    };

    return controller.stream;
  }

  Future<void> sendChatMessage(
      TaxiGroup taxiGroup,
      String content,
      String messageType,
      ) async {
    final User? user = _supabase.auth.currentUser;
    final String senderId = user!.id;
    try {
      await _supabase.from('chats').insert({
        'group_id': taxiGroup.groupId,
        'sender_id': senderId,
        'content': content,
        'message_type': messageType,
      });
      debugPrint("Insert 성공");
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }

  // 특정 채팅 메시지를 읽음 처리하는 함수
  Future<void> readChatMessage(String messageId) async {
    try {
      await _supabase.from('chats').update({
        'is_read': true,
      }).eq('message_id', messageId);
    } catch (e) {
      debugPrint('Error reading message $e');
    }
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

final taxiGroupProvider =
StateNotifierProvider<TaxiGroupNotifier, List<TaxiGroup>>((ref) {
  return TaxiGroupNotifier();
});


final chatMessagesProvider =
StreamProvider.autoDispose.family<List<Chat>, TaxiGroup>((ref, taxiGroup) {
  final taxiGroupNotifier = ref.watch(taxiGroupProvider.notifier);
  return taxiGroupNotifier
      .chatMessagesStream(taxiGroup)
      .map((data) => data.map((e) => Chat.fromJson(e)).toList());
});