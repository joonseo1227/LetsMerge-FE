import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final directionsProvider =
    StateNotifierProvider<DirectionsNotifier, List<NLatLng>>(
  (ref) => DirectionsNotifier(),
);

class DirectionsNotifier extends StateNotifier<List<NLatLng>> {
  DirectionsNotifier() : super([]);

  Future<void> fetchDirections(
      double startLat, double startLng, double endLat, double endLng) async {
    //출발지와 목적지가 동일한 경우
    if (startLat == endLat && startLng == endLng) {
      debugPrint("출발지와 목적지가 동일하여 경로 요청을 취소합니다.");
      state = [];
      return;
    }

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
          state = [];
          return;
        }

        var trafast = data['route']['trafast'];
        if (trafast == null || trafast.isEmpty) {
          debugPrint("trafast 경로 없음.");
          state = [];
          return;
        }

        var route = trafast[0]['path']; // 가장 빠른 경로 가져오기

        List<NLatLng> routePoints = route
            .map<NLatLng>(
                (point) => NLatLng(point[1], point[0])) // 위도, 경도 순서 변환
            .toList();

        state = routePoints;
      } else {
        debugPrint("경로 요청 실패: ${response.statusCode}");
        state = [];
      }
    } catch (e) {
      debugPrint("경로 요청 오류: $e");
      state = [];
    }
  }
}
