import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

final directionsProvider =
    StateNotifierProvider<DirectionsNotifier, List<NLatLng>>(
  (ref) => DirectionsNotifier(),
);

class DirectionsNotifier extends StateNotifier<List<NLatLng>> {
  DirectionsNotifier() : super([]);

  int? _taxiFare;
  double _roundPrecision = 0.0001; // 약 11m 오차

  int? get taxiFare => _taxiFare;

  // 좌표 반올림
  double _roundCoordinate(double value) {
    return (value / _roundPrecision).round() * _roundPrecision;
  }

  // 두 좌표가 같은 위치인지 확인
  bool isSameLocation(double lat1, double lng1, double lat2, double lng2) {
    return _roundCoordinate(lat1) == _roundCoordinate(lat2) &&
        _roundCoordinate(lng1) == _roundCoordinate(lng2);
  }

  Future<bool> checkFetchDirections(
      double startLat,
      double startLng,
      double endLat,
      double endLng,
      ) async {
    if (isSameLocation(startLat, startLng, endLat, endLng)) {
      return false; // 출발지와 목적지가 동일하다고 판단
    }

    await fetchDirections(startLat, startLng, endLat, endLng);
    return true; // 정상적으로 경로 요청
  }

  Future<void> fetchDirections(
      double startLat, double startLng, double endLat, double endLng) async {
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
          _taxiFare = null;
          state = [];
          return;
        }

        var trafast = data['route']['trafast'];
        if (trafast == null || trafast.isEmpty) {
          debugPrint("trafast 경로 없음.");
          _taxiFare = null;
          state = [];
          return;
        }

        var route = trafast[0]['path'];
        var summary = trafast[0]['summary'];

        _taxiFare = summary['taxiFare'];
        debugPrint("예상 택시비: $_taxiFare");

        List<NLatLng> routePoints = route
            .map<NLatLng>(
              (point) => NLatLng(
            point[1],
            point[0],
          ),
        )
            .toList();

        state = routePoints;
        state = [...state];
      } else {
        debugPrint("경로 요청 실패: ${response.statusCode}");
        _taxiFare = null;
        state = [];
      }
    } catch (e) {
      debugPrint("경로 요청 오류: $e");
      _taxiFare = null;
      state = [];
    }
  }
}
