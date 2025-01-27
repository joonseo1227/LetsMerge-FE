import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

enum GeocodingMode { departure, destination }

final reverseGeocodingProvider =
    StateNotifierProvider<ReverseGeocodingNotifier, Map<GeocodingMode, String>>(
  (ref) => ReverseGeocodingNotifier(),
);

class ReverseGeocodingNotifier extends StateNotifier<Map<GeocodingMode, String>> {
  ReverseGeocodingNotifier()
      : super({
    GeocodingMode.departure: '', //출발지 초기값
    GeocodingMode.destination: '', //도착지 초기값
  });

  Future<String> fetchAddress(double latitude, double longitude) async {
    String url =
        'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=$longitude,$latitude&orders=roadaddr,addr&output=json';
    String result;
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
          var region = results[0]['region'];
          var land = results[0]['land'];

          String regionAddress = '${region['area1']['name']} '
              '${region['area2']['name']} '
              '${region['area3']['name']} '
              '${region['area4']['name']}';

          String landAddress = land != null && land['name'] != null
              ? '${land['name']} ${land['number1']}${land['number2'] != '' ? '-${land['number2']}' : ''}'
              : '';

          result = regionAddress + landAddress;
        } else {
          result = '주소를 찾을 수 없습니다.';
        }
      } else {
        result = '주소 검색 실패';
      }
    } catch (e) {
      result = '주소 검색 오류';
    }

    return result;
  }

  void setAddress(GeocodingMode mode, String address) {
    state = {...state, mode: address};
  }
}
