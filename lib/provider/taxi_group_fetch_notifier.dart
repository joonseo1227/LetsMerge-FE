import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/taxi_group/chats/chat.dart';
import 'package:letsmerge/models/taxi_group/participants/participants.dart';
import 'package:letsmerge/models/taxi_group/taxi_group.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TaxiGroupNotifier extends StateNotifier<List<TaxiGroup>> {
  final SupabaseClient _supabase;
  final String userId;
  StreamSubscription<List<Map<String, dynamic>>>? _subscription;

  TaxiGroupNotifier(this._supabase, this.userId) : super([]) {
    _watchTaxiGroup();
  }

  void _watchTaxiGroup() {
    _subscription = _supabase
        .from('taxigroups')
        .stream(primaryKey: ['group_id']).listen((data) {
      state = data.map((e) => TaxiGroup.fromJson(e)).toList();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class ParticipantsNotifier extends StateNotifier<List<Participants>> {
  final SupabaseClient _supabase;
  final TaxiGroup taxiGroup;
  StreamSubscription<List<Map<String, dynamic>>>? _subscription;

  ParticipantsNotifier(this._supabase, this.taxiGroup) : super([]) {
    _watchParticipants(taxiGroup);
  }

  void _watchParticipants(TaxiGroup taxiGroup) {
    _subscription = _supabase
        .from('participants')
        .stream(primaryKey: ['group_id'])
        .eq('group_id', taxiGroup.groupId!)
        .order('created_at', ascending: false)
        .listen((data) {
          state = data.map((e) => Participants.fromJson(e)).toList();
        });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class ChatMessagesNotifier extends StateNotifier<List<Chat>> {
  final SupabaseClient _supabase;
  final TaxiGroup taxiGroup;
  StreamSubscription<List<Map<String, dynamic>>>? _subscription;

  ChatMessagesNotifier(this._supabase, this.taxiGroup) : super([]) {
    _watchChatMessages(taxiGroup);
  }

  void _watchChatMessages(TaxiGroup taxiGroup) {
    _subscription = _supabase
        .from('chats')
        .stream(primaryKey: ['message_id'])
        .eq('group_id', taxiGroup.groupId!)
        .order('created_at', ascending: false)
        .listen((data) {
          state = data.map((e) => Chat.fromJson(e)).toList();
        });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final supabaseProvider = Provider((ref) => Supabase.instance.client);

final taxiGroupsProvider =
    StateNotifierProvider.family<TaxiGroupNotifier, List<TaxiGroup>, String>(
  (ref, userId) {
    final supabase = ref.watch(supabaseProvider);
    return TaxiGroupNotifier(supabase, userId);
  },
);

final participantsProvider = StateNotifierProvider.family<ParticipantsNotifier,
    List<Participants>, TaxiGroup>(
  (ref, taxiGroup) {
    final supabase = ref.watch(supabaseProvider);
    return ParticipantsNotifier(supabase, taxiGroup);
  },
);

final chatMessagesProvider =
    StateNotifierProvider.family<ChatMessagesNotifier, List<Chat>, TaxiGroup>(
  (ref, taxiGroup) {
    final supabase = ref.watch(supabaseProvider);
    return ChatMessagesNotifier(supabase, taxiGroup);
  },
);
