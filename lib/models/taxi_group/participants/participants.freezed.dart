// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participants.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Participants _$ParticipantsFromJson(Map<String, dynamic> json) {
  return _Participants.fromJson(json);
}

/// @nodoc
mixin _$Participants {
  @JsonKey(name: 'participant_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'group_id')
  String get groupId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Participants to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Participants
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParticipantsCopyWith<Participants> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParticipantsCopyWith<$Res> {
  factory $ParticipantsCopyWith(
          Participants value, $Res Function(Participants) then) =
      _$ParticipantsCopyWithImpl<$Res, Participants>;
  @useResult
  $Res call(
      {@JsonKey(name: 'participant_id') String userId,
      @JsonKey(name: 'id') int id,
      @JsonKey(name: 'group_id') String groupId,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class _$ParticipantsCopyWithImpl<$Res, $Val extends Participants>
    implements $ParticipantsCopyWith<$Res> {
  _$ParticipantsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Participants
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? id = null,
    Object? groupId = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ParticipantsImplCopyWith<$Res>
    implements $ParticipantsCopyWith<$Res> {
  factory _$$ParticipantsImplCopyWith(
          _$ParticipantsImpl value, $Res Function(_$ParticipantsImpl) then) =
      __$$ParticipantsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'participant_id') String userId,
      @JsonKey(name: 'id') int id,
      @JsonKey(name: 'group_id') String groupId,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class __$$ParticipantsImplCopyWithImpl<$Res>
    extends _$ParticipantsCopyWithImpl<$Res, _$ParticipantsImpl>
    implements _$$ParticipantsImplCopyWith<$Res> {
  __$$ParticipantsImplCopyWithImpl(
      _$ParticipantsImpl _value, $Res Function(_$ParticipantsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Participants
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? id = null,
    Object? groupId = null,
    Object? createdAt = null,
  }) {
    return _then(_$ParticipantsImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ParticipantsImpl implements _Participants {
  const _$ParticipantsImpl(
      {@JsonKey(name: 'participant_id') required this.userId,
      @JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'group_id') required this.groupId,
      @JsonKey(name: 'created_at') required this.createdAt});

  factory _$ParticipantsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParticipantsImplFromJson(json);

  @override
  @JsonKey(name: 'participant_id')
  final String userId;
  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'group_id')
  final String groupId;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  @override
  String toString() {
    return 'Participants(userId: $userId, id: $id, groupId: $groupId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParticipantsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, id, groupId, createdAt);

  /// Create a copy of Participants
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParticipantsImplCopyWith<_$ParticipantsImpl> get copyWith =>
      __$$ParticipantsImplCopyWithImpl<_$ParticipantsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParticipantsImplToJson(
      this,
    );
  }
}

abstract class _Participants implements Participants {
  const factory _Participants(
          {@JsonKey(name: 'participant_id') required final String userId,
          @JsonKey(name: 'id') required final int id,
          @JsonKey(name: 'group_id') required final String groupId,
          @JsonKey(name: 'created_at') required final String createdAt}) =
      _$ParticipantsImpl;

  factory _Participants.fromJson(Map<String, dynamic> json) =
      _$ParticipantsImpl.fromJson;

  @override
  @JsonKey(name: 'participant_id')
  String get userId;
  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'group_id')
  String get groupId;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;

  /// Create a copy of Participants
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParticipantsImplCopyWith<_$ParticipantsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
