import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'taxi_group.freezed.dart';
part 'taxi_group.g.dart';

List<String> _clothesFromJson(dynamic clothes) {
  if (clothes == null) return [];

  // 문자열인 경우 JSON 파싱 시도
  if (clothes is String) {
    try {
      final decoded = jsonDecode(clothes);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
      // 문자열이 단일 값인 경우 1개짜리 리스트로 반환
      return [clothes];
    } catch (_) {
      // JSON 파싱 실패시 문자열 자체를 리스트의 요소로
      return [clothes];
    }
  }

  // List인 경우 문자열 변환
  if (clothes is List) {
    return clothes.map((e) => e.toString()).toList();
  }

  // 기타 타입의 경우 빈 리스트 반환
  return [];
}

List<String> _clothesToJson(List<String> clothes) => clothes;

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
    @JsonKey(
      name: 'host_clothes',
      fromJson: _clothesFromJson,
      toJson: _clothesToJson,
      defaultValue: <String>[],
    )
    required List<String> clothes,
    List<String>? participants,
    @JsonKey(name: 'remaining_seats') required int remainingSeats,
  }) = _TaxiGroup;

  factory TaxiGroup.fromJson(Map<String, dynamic> json) =>
      _$TaxiGroupFromJson(json);
}
