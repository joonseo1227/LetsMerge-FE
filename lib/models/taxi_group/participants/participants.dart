import 'package:freezed_annotation/freezed_annotation.dart';

part 'participants.freezed.dart';
part 'participants.g.dart';

@freezed
class Participants with _$Participants {
  const factory Participants({
    @JsonKey(name: 'participant_id') required String userId,
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'group_id') required String groupId,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _Participants;

  factory Participants.fromJson(Map<String, dynamic> json) => _$ParticipantsFromJson(json);
}
