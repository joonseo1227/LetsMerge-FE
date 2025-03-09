import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'taxi_group.freezed.dart';
part 'taxi_group.g.dart';

@freezed
class TaxiGroup with _$TaxiGroup {
  const factory TaxiGroup({
    @JsonKey(name: 'group_id', includeIfNull: false) String? groupId,
    @JsonKey(name: 'host_id') String? creatorUserId,
    @JsonKey(name: 'departure_place') required String departurePlace,
    @JsonKey(name: 'departure_address') required String departureAddress,
    @JsonKey(name: 'departure_lat') required double departureLat,
    @JsonKey(name: 'departure_lon') required double departureLon,
    @JsonKey(name: 'arrival_place') required String arrivalPlace,
    @JsonKey(name: 'arrival_address') required String arrivalAddress,
    @JsonKey(name: 'arrival_lat') required double arrivalLat,
    @JsonKey(name: 'arrival_lon') required double arrivalLon,
    @JsonKey(name: 'estimated_fare') required int? estimatedFare,
    required int? seater,
    @JsonKey(name: 'departure_time') required DateTime? departureTime,
    @JsonKey(name: 'host_clothes') required List<String> clothes,
    required List<String> participants,
    @JsonKey(name: 'remaining_seats') required int remainingSeats,
  }) = _TaxiGroup;

  factory TaxiGroup.fromJson(Map<String, dynamic> json) =>
      _$TaxiGroupFromJson(json);
}