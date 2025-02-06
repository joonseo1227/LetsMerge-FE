import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// 경로 좌표와 택시비를 함께 관리하는 상태 클래스
class DirectionsState {
  final List<NLatLng> routePoints;
  final int? taxiFare;

  DirectionsState({
    required this.routePoints,
    this.taxiFare,
  });

  DirectionsState copyWith({
    List<NLatLng>? routePoints,
    int? taxiFare,
  }) {
    return DirectionsState(
      routePoints: routePoints ?? this.routePoints,
      taxiFare: taxiFare ?? this.taxiFare,
    );
  }
}

final directionsProvider =
    StateNotifierProvider<DirectionsNotifier, DirectionsState>(
  (ref) => DirectionsNotifier(),
);

class DirectionsNotifier extends StateNotifier<DirectionsState> {
  DirectionsNotifier()
      : super(DirectionsState(routePoints: [], taxiFare: null));

  final double _roundPrecision = 0.0001; // 약 11m 오차

  // 좌표를 반올림하여 비교할 때 사용하는 함수
  double _roundCoordinate(double value) {
    return (value / _roundPrecision).round() * _roundPrecision;
  }

  // 두 좌표가 동일한 위치인지 확인
  bool isSameLocation(double lat1, double lng1, double lat2, double lng2) {
    return _roundCoordinate(lat1) == _roundCoordinate(lat2) &&
        _roundCoordinate(lng1) == _roundCoordinate(lng2);
  }

  // 출발지와 목적지가 동일한지 확인한 후 경로 요청을 진행
  Future<bool> checkFetchDirections(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) async {
    if (isSameLocation(startLat, startLng, endLat, endLng)) {
      return false; // 동일한 위치인 경우
    }

    await fetchDirections(startLat, startLng, endLat, endLng);
    return true; // 정상적으로 요청됨
  }

  // directions API를 호출하여 경로 좌표와 택시비를 받아오는 함수
  Future<void> fetchDirections(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) async {
    String url =
        'https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving?start=$startLng,$startLat&goal=$endLng,$endLat&option=trafast';

    debugPrint("Directions API 요청: $url");

    try {
      var response = await http.get(Uri.parse(url), headers: {
        "X-NCP-APIGW-API-KEY-ID": dotenv.env['NAVER_MAP_CLIENT_ID']!,
        "X-NCP-APIGW-API-KEY": dotenv.env['NAVER_MAP_CLIENT_SECRET']!,
      });

      if (response.statusCode == 200) {
        var decodedBody = utf8.decode(response.bodyBytes);
        var data = json.decode(decodedBody);
        debugPrint("API 응답: $data");

        if (data['route'] == null) {
          debugPrint("route 데이터 없음");
          state = DirectionsState(routePoints: [], taxiFare: null);
          return;
        }

        var trafast = data['route']['trafast'];
        if (trafast == null || trafast.isEmpty) {
          debugPrint("trafast 경로 없음.");
          state = DirectionsState(routePoints: [], taxiFare: null);
          return;
        }

        var route = trafast[0]['path'];
        var summary = trafast[0]['summary'];

        int taxiFare = summary['taxiFare'];
        debugPrint("예상 택시비: $taxiFare");

        List<NLatLng> routePoints = route
            .map<NLatLng>(
              (point) => NLatLng(
                point[1],
                point[0],
              ),
            )
            .toList();

        // 상태 업데이트 (경로 좌표와 택시비 모두 반영)
        state = DirectionsState(routePoints: routePoints, taxiFare: taxiFare);
      } else {
        debugPrint("경로 요청 실패: ${response.statusCode}");
        state = DirectionsState(routePoints: [], taxiFare: null);
      }
    } catch (e) {
      debugPrint("경로 요청 오류: $e");
      state = DirectionsState(routePoints: [], taxiFare: null);
    }
  }
}
