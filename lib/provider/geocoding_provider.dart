import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:letsmerge/models/location_model.dart';

enum GeocodingMode { departure, destination }

final reverseGeocodingProvider = StateNotifierProvider<ReverseGeocodingNotifier,
    Map<GeocodingMode, LocationModel?>>(
  (ref) => ReverseGeocodingNotifier(),
);

class ReverseGeocodingNotifier
    extends StateNotifier<Map<GeocodingMode, LocationModel?>> {
  ReverseGeocodingNotifier()
      : super({
          GeocodingMode.departure: null,
          GeocodingMode.destination: null,
        });

  Future<String> fetchAddress(double latitude, double longitude) async {
    String url =
        'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=$longitude,$latitude&orders=roadaddr,addr,legalcode&output=json';
    debugPrint("Reverse Geocoding API 요청: $url");

    try {
      var response = await http.get(Uri.parse(url), headers: {
        "X-NCP-APIGW-API-KEY-ID": dotenv.env['NAVER_MAP_CLIENT_ID']!,
        "X-NCP-APIGW-API-KEY": dotenv.env['NAVER_MAP_CLIENT_SECRET']!,
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var results = data['results'];

        if (results.isNotEmpty) {
          // 주소 유형별 분리
          var roadaddr = _findAddress(results, 'roadaddr');
          var addr = _findAddress(results, 'addr');
          var legalcode = _findAddress(results, 'legalcode');

          // 우선순위 (도로명 -> 지번(동+지번) -> 법정동)
          return roadaddr ?? addr ?? legalcode ?? '주소를 찾을 수 없습니다.';
        }
        return '주소를 찾을 수 없습니다.';
      }
      return '주소 검색 실패';
    } catch (e) {
      return '주소 검색 오류';
    }
  }

// 주소 유형별 포맷팅
  String? _findAddress(List results, String type) {
    var result = results.firstWhere(
      (res) => res['name'] == type,
      orElse: () => null,
    );
    if (result == null) return null;

    var region = result['region'];
    var land = result['land'];
    String base = '${region['area1']['name']} ${region['area2']['name']}';

    if (type == 'roadaddr' && land != null) {
      // 도로명 주소: 시/군/구 + 도로명 + 번호
      return '$base ${land['name']} ${_formatNumber(land)}';
    } else if (type == 'addr' && land != null) {
      // 지번 주소: 시/군/구 + 동 + 지번
      return '$base ${region['area3']['name']} ${_formatNumber(land)}';
    } else if (type == 'legalcode') {
      // 법정동 주소: 시/군/구 + 동
      return '$base ${region['area3']['name']}';
    }

    return null;
  }

// 번호 포맷탕
  String _formatNumber(Map land) {
    String number = land['number1'] ?? '';
    if (land['number2'] != null && land['number2'].isNotEmpty) {
      number += '-${land['number2']}';
    }
    return number;
  }

  void setPlaceAndAddress({
    required GeocodingMode mode,
    required String address,
    required String place,
    required double lat,
    required double lng,
  }) {
    state = {
      ...state,
      mode: LocationModel(
          latitude: lat, longitude: lng, address: address, place: place),
    };
  }
}
