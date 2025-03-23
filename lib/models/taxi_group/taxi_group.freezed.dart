// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'taxi_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaxiGroup _$TaxiGroupFromJson(Map<String, dynamic> json) {
  return _TaxiGroup.fromJson(json);
}

/// @nodoc
mixin _$TaxiGroup {
  @JsonKey(name: 'group_id', includeIfNull: false)
  String? get groupId => throw _privateConstructorUsedError;
  @JsonKey(name: 'host_id')
  String? get creatorUserId => throw _privateConstructorUsedError;
  @JsonKey(name: 'departure_place')
  String get departurePlace => throw _privateConstructorUsedError;
  @JsonKey(name: 'departure_address')
  String get departureAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'departure_lat')
  double get departureLat => throw _privateConstructorUsedError;
  @JsonKey(name: 'departure_lon')
  double get departureLon => throw _privateConstructorUsedError;
  @JsonKey(name: 'arrival_place')
  String get arrivalPlace => throw _privateConstructorUsedError;
  @JsonKey(name: 'arrival_address')
  String get arrivalAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'arrival_lat')
  double get arrivalLat => throw _privateConstructorUsedError;
  @JsonKey(name: 'arrival_lon')
  double get arrivalLon => throw _privateConstructorUsedError;
  @JsonKey(name: 'estimated_fare')
  int get estimatedFare => throw _privateConstructorUsedError;
  @JsonKey(name: 'departure_time')
  DateTime get departureTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'remaining_seats')
  int get remainingSeats => throw _privateConstructorUsedError;

  /// Serializes this TaxiGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaxiGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaxiGroupCopyWith<TaxiGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaxiGroupCopyWith<$Res> {
  factory $TaxiGroupCopyWith(TaxiGroup value, $Res Function(TaxiGroup) then) =
      _$TaxiGroupCopyWithImpl<$Res, TaxiGroup>;
  @useResult
  $Res call(
      {@JsonKey(name: 'group_id', includeIfNull: false) String? groupId,
      @JsonKey(name: 'host_id') String? creatorUserId,
      @JsonKey(name: 'departure_place') String departurePlace,
      @JsonKey(name: 'departure_address') String departureAddress,
      @JsonKey(name: 'departure_lat') double departureLat,
      @JsonKey(name: 'departure_lon') double departureLon,
      @JsonKey(name: 'arrival_place') String arrivalPlace,
      @JsonKey(name: 'arrival_address') String arrivalAddress,
      @JsonKey(name: 'arrival_lat') double arrivalLat,
      @JsonKey(name: 'arrival_lon') double arrivalLon,
      @JsonKey(name: 'estimated_fare') int estimatedFare,
      @JsonKey(name: 'departure_time') DateTime departureTime,
      @JsonKey(name: 'remaining_seats') int remainingSeats});
}

/// @nodoc
class _$TaxiGroupCopyWithImpl<$Res, $Val extends TaxiGroup>
    implements $TaxiGroupCopyWith<$Res> {
  _$TaxiGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaxiGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = freezed,
    Object? creatorUserId = freezed,
    Object? departurePlace = null,
    Object? departureAddress = null,
    Object? departureLat = null,
    Object? departureLon = null,
    Object? arrivalPlace = null,
    Object? arrivalAddress = null,
    Object? arrivalLat = null,
    Object? arrivalLon = null,
    Object? estimatedFare = null,
    Object? departureTime = null,
    Object? remainingSeats = null,
  }) {
    return _then(_value.copyWith(
      groupId: freezed == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String?,
      creatorUserId: freezed == creatorUserId
          ? _value.creatorUserId
          : creatorUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      departurePlace: null == departurePlace
          ? _value.departurePlace
          : departurePlace // ignore: cast_nullable_to_non_nullable
              as String,
      departureAddress: null == departureAddress
          ? _value.departureAddress
          : departureAddress // ignore: cast_nullable_to_non_nullable
              as String,
      departureLat: null == departureLat
          ? _value.departureLat
          : departureLat // ignore: cast_nullable_to_non_nullable
              as double,
      departureLon: null == departureLon
          ? _value.departureLon
          : departureLon // ignore: cast_nullable_to_non_nullable
              as double,
      arrivalPlace: null == arrivalPlace
          ? _value.arrivalPlace
          : arrivalPlace // ignore: cast_nullable_to_non_nullable
              as String,
      arrivalAddress: null == arrivalAddress
          ? _value.arrivalAddress
          : arrivalAddress // ignore: cast_nullable_to_non_nullable
              as String,
      arrivalLat: null == arrivalLat
          ? _value.arrivalLat
          : arrivalLat // ignore: cast_nullable_to_non_nullable
              as double,
      arrivalLon: null == arrivalLon
          ? _value.arrivalLon
          : arrivalLon // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedFare: null == estimatedFare
          ? _value.estimatedFare
          : estimatedFare // ignore: cast_nullable_to_non_nullable
              as int,
      departureTime: null == departureTime
          ? _value.departureTime
          : departureTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      remainingSeats: null == remainingSeats
          ? _value.remainingSeats
          : remainingSeats // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaxiGroupImplCopyWith<$Res>
    implements $TaxiGroupCopyWith<$Res> {
  factory _$$TaxiGroupImplCopyWith(
          _$TaxiGroupImpl value, $Res Function(_$TaxiGroupImpl) then) =
      __$$TaxiGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'group_id', includeIfNull: false) String? groupId,
      @JsonKey(name: 'host_id') String? creatorUserId,
      @JsonKey(name: 'departure_place') String departurePlace,
      @JsonKey(name: 'departure_address') String departureAddress,
      @JsonKey(name: 'departure_lat') double departureLat,
      @JsonKey(name: 'departure_lon') double departureLon,
      @JsonKey(name: 'arrival_place') String arrivalPlace,
      @JsonKey(name: 'arrival_address') String arrivalAddress,
      @JsonKey(name: 'arrival_lat') double arrivalLat,
      @JsonKey(name: 'arrival_lon') double arrivalLon,
      @JsonKey(name: 'estimated_fare') int estimatedFare,
      @JsonKey(name: 'departure_time') DateTime departureTime,
      @JsonKey(name: 'remaining_seats') int remainingSeats});
}

/// @nodoc
class __$$TaxiGroupImplCopyWithImpl<$Res>
    extends _$TaxiGroupCopyWithImpl<$Res, _$TaxiGroupImpl>
    implements _$$TaxiGroupImplCopyWith<$Res> {
  __$$TaxiGroupImplCopyWithImpl(
      _$TaxiGroupImpl _value, $Res Function(_$TaxiGroupImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaxiGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = freezed,
    Object? creatorUserId = freezed,
    Object? departurePlace = null,
    Object? departureAddress = null,
    Object? departureLat = null,
    Object? departureLon = null,
    Object? arrivalPlace = null,
    Object? arrivalAddress = null,
    Object? arrivalLat = null,
    Object? arrivalLon = null,
    Object? estimatedFare = null,
    Object? departureTime = null,
    Object? remainingSeats = null,
  }) {
    return _then(_$TaxiGroupImpl(
      groupId: freezed == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String?,
      creatorUserId: freezed == creatorUserId
          ? _value.creatorUserId
          : creatorUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      departurePlace: null == departurePlace
          ? _value.departurePlace
          : departurePlace // ignore: cast_nullable_to_non_nullable
              as String,
      departureAddress: null == departureAddress
          ? _value.departureAddress
          : departureAddress // ignore: cast_nullable_to_non_nullable
              as String,
      departureLat: null == departureLat
          ? _value.departureLat
          : departureLat // ignore: cast_nullable_to_non_nullable
              as double,
      departureLon: null == departureLon
          ? _value.departureLon
          : departureLon // ignore: cast_nullable_to_non_nullable
              as double,
      arrivalPlace: null == arrivalPlace
          ? _value.arrivalPlace
          : arrivalPlace // ignore: cast_nullable_to_non_nullable
              as String,
      arrivalAddress: null == arrivalAddress
          ? _value.arrivalAddress
          : arrivalAddress // ignore: cast_nullable_to_non_nullable
              as String,
      arrivalLat: null == arrivalLat
          ? _value.arrivalLat
          : arrivalLat // ignore: cast_nullable_to_non_nullable
              as double,
      arrivalLon: null == arrivalLon
          ? _value.arrivalLon
          : arrivalLon // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedFare: null == estimatedFare
          ? _value.estimatedFare
          : estimatedFare // ignore: cast_nullable_to_non_nullable
              as int,
      departureTime: null == departureTime
          ? _value.departureTime
          : departureTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      remainingSeats: null == remainingSeats
          ? _value.remainingSeats
          : remainingSeats // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaxiGroupImpl implements _TaxiGroup {
  const _$TaxiGroupImpl(
      {@JsonKey(name: 'group_id', includeIfNull: false) this.groupId,
      @JsonKey(name: 'host_id') this.creatorUserId,
      @JsonKey(name: 'departure_place') required this.departurePlace,
      @JsonKey(name: 'departure_address') required this.departureAddress,
      @JsonKey(name: 'departure_lat') required this.departureLat,
      @JsonKey(name: 'departure_lon') required this.departureLon,
      @JsonKey(name: 'arrival_place') required this.arrivalPlace,
      @JsonKey(name: 'arrival_address') required this.arrivalAddress,
      @JsonKey(name: 'arrival_lat') required this.arrivalLat,
      @JsonKey(name: 'arrival_lon') required this.arrivalLon,
      @JsonKey(name: 'estimated_fare') required this.estimatedFare,
      @JsonKey(name: 'departure_time') required this.departureTime,
      @JsonKey(name: 'remaining_seats') required this.remainingSeats});

  factory _$TaxiGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaxiGroupImplFromJson(json);

  @override
  @JsonKey(name: 'group_id', includeIfNull: false)
  final String? groupId;
  @override
  @JsonKey(name: 'host_id')
  final String? creatorUserId;
  @override
  @JsonKey(name: 'departure_place')
  final String departurePlace;
  @override
  @JsonKey(name: 'departure_address')
  final String departureAddress;
  @override
  @JsonKey(name: 'departure_lat')
  final double departureLat;
  @override
  @JsonKey(name: 'departure_lon')
  final double departureLon;
  @override
  @JsonKey(name: 'arrival_place')
  final String arrivalPlace;
  @override
  @JsonKey(name: 'arrival_address')
  final String arrivalAddress;
  @override
  @JsonKey(name: 'arrival_lat')
  final double arrivalLat;
  @override
  @JsonKey(name: 'arrival_lon')
  final double arrivalLon;
  @override
  @JsonKey(name: 'estimated_fare')
  final int estimatedFare;
  @override
  @JsonKey(name: 'departure_time')
  final DateTime departureTime;
  @override
  @JsonKey(name: 'remaining_seats')
  final int remainingSeats;

  @override
  String toString() {
    return 'TaxiGroup(groupId: $groupId, creatorUserId: $creatorUserId, departurePlace: $departurePlace, departureAddress: $departureAddress, departureLat: $departureLat, departureLon: $departureLon, arrivalPlace: $arrivalPlace, arrivalAddress: $arrivalAddress, arrivalLat: $arrivalLat, arrivalLon: $arrivalLon, estimatedFare: $estimatedFare, departureTime: $departureTime, remainingSeats: $remainingSeats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaxiGroupImpl &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.creatorUserId, creatorUserId) ||
                other.creatorUserId == creatorUserId) &&
            (identical(other.departurePlace, departurePlace) ||
                other.departurePlace == departurePlace) &&
            (identical(other.departureAddress, departureAddress) ||
                other.departureAddress == departureAddress) &&
            (identical(other.departureLat, departureLat) ||
                other.departureLat == departureLat) &&
            (identical(other.departureLon, departureLon) ||
                other.departureLon == departureLon) &&
            (identical(other.arrivalPlace, arrivalPlace) ||
                other.arrivalPlace == arrivalPlace) &&
            (identical(other.arrivalAddress, arrivalAddress) ||
                other.arrivalAddress == arrivalAddress) &&
            (identical(other.arrivalLat, arrivalLat) ||
                other.arrivalLat == arrivalLat) &&
            (identical(other.arrivalLon, arrivalLon) ||
                other.arrivalLon == arrivalLon) &&
            (identical(other.estimatedFare, estimatedFare) ||
                other.estimatedFare == estimatedFare) &&
            (identical(other.departureTime, departureTime) ||
                other.departureTime == departureTime) &&
            (identical(other.remainingSeats, remainingSeats) ||
                other.remainingSeats == remainingSeats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      groupId,
      creatorUserId,
      departurePlace,
      departureAddress,
      departureLat,
      departureLon,
      arrivalPlace,
      arrivalAddress,
      arrivalLat,
      arrivalLon,
      estimatedFare,
      departureTime,
      remainingSeats);

  /// Create a copy of TaxiGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaxiGroupImplCopyWith<_$TaxiGroupImpl> get copyWith =>
      __$$TaxiGroupImplCopyWithImpl<_$TaxiGroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaxiGroupImplToJson(
      this,
    );
  }
}

abstract class _TaxiGroup implements TaxiGroup {
  const factory _TaxiGroup(
      {@JsonKey(name: 'group_id', includeIfNull: false) final String? groupId,
      @JsonKey(name: 'host_id') final String? creatorUserId,
      @JsonKey(name: 'departure_place') required final String departurePlace,
      @JsonKey(name: 'departure_address')
      required final String departureAddress,
      @JsonKey(name: 'departure_lat') required final double departureLat,
      @JsonKey(name: 'departure_lon') required final double departureLon,
      @JsonKey(name: 'arrival_place') required final String arrivalPlace,
      @JsonKey(name: 'arrival_address') required final String arrivalAddress,
      @JsonKey(name: 'arrival_lat') required final double arrivalLat,
      @JsonKey(name: 'arrival_lon') required final double arrivalLon,
      @JsonKey(name: 'estimated_fare') required final int estimatedFare,
      @JsonKey(name: 'departure_time') required final DateTime departureTime,
      @JsonKey(name: 'remaining_seats')
      required final int remainingSeats}) = _$TaxiGroupImpl;

  factory _TaxiGroup.fromJson(Map<String, dynamic> json) =
      _$TaxiGroupImpl.fromJson;

  @override
  @JsonKey(name: 'group_id', includeIfNull: false)
  String? get groupId;
  @override
  @JsonKey(name: 'host_id')
  String? get creatorUserId;
  @override
  @JsonKey(name: 'departure_place')
  String get departurePlace;
  @override
  @JsonKey(name: 'departure_address')
  String get departureAddress;
  @override
  @JsonKey(name: 'departure_lat')
  double get departureLat;
  @override
  @JsonKey(name: 'departure_lon')
  double get departureLon;
  @override
  @JsonKey(name: 'arrival_place')
  String get arrivalPlace;
  @override
  @JsonKey(name: 'arrival_address')
  String get arrivalAddress;
  @override
  @JsonKey(name: 'arrival_lat')
  double get arrivalLat;
  @override
  @JsonKey(name: 'arrival_lon')
  double get arrivalLon;
  @override
  @JsonKey(name: 'estimated_fare')
  int get estimatedFare;
  @override
  @JsonKey(name: 'departure_time')
  DateTime get departureTime;
  @override
  @JsonKey(name: 'remaining_seats')
  int get remainingSeats;

  /// Create a copy of TaxiGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaxiGroupImplCopyWith<_$TaxiGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
