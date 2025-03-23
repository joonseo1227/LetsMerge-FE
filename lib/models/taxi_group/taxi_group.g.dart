// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taxi_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaxiGroupImpl _$$TaxiGroupImplFromJson(Map<String, dynamic> json) =>
    _$TaxiGroupImpl(
      groupId: json['group_id'] as String?,
      creatorUserId: json['host_id'] as String?,
      departurePlace: json['departure_place'] as String,
      departureAddress: json['departure_address'] as String,
      departureLat: (json['departure_lat'] as num).toDouble(),
      departureLon: (json['departure_lon'] as num).toDouble(),
      arrivalPlace: json['arrival_place'] as String,
      arrivalAddress: json['arrival_address'] as String,
      arrivalLat: (json['arrival_lat'] as num).toDouble(),
      arrivalLon: (json['arrival_lon'] as num).toDouble(),
      estimatedFare: (json['estimated_fare'] as num).toInt(),
      departureTime: DateTime.parse(json['departure_time'] as String),
      remainingSeats: (json['remaining_seats'] as num).toInt(),
    );

Map<String, dynamic> _$$TaxiGroupImplToJson(_$TaxiGroupImpl instance) =>
    <String, dynamic>{
      if (instance.groupId case final value?) 'group_id': value,
      'host_id': instance.creatorUserId,
      'departure_place': instance.departurePlace,
      'departure_address': instance.departureAddress,
      'departure_lat': instance.departureLat,
      'departure_lon': instance.departureLon,
      'arrival_place': instance.arrivalPlace,
      'arrival_address': instance.arrivalAddress,
      'arrival_lat': instance.arrivalLat,
      'arrival_lon': instance.arrivalLon,
      'estimated_fare': instance.estimatedFare,
      'departure_time': instance.departureTime.toIso8601String(),
      'remaining_seats': instance.remainingSeats,
    };
