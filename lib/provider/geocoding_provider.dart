import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final reverseGeocodingProvider =
StateNotifierProvider<ReverseGeocodingNotifier, String>(
      (ref) => ReverseGeocodingNotifier(),
);

class ReverseGeocodingNotifier extends StateNotifier<String> {
  ReverseGeocodingNotifier() : super('위치를 가져오는 중...');

  Future<void> fetchAddress(double latitude, double longitude) async {
    String url =
        'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=$longitude,$latitude&orders=roadaddr,addr&output=json';

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

          // 행정구역 주소
          String regionAddress = '${region['area1']['name']} '
              '${region['area2']['name']} '
              '${region['area3']['name']} '
              '${region['area4']['name']}';

          // 도로명 주소 또는 지번 주소
          String landAddress = land != null && land['name'] != null
              ? '${land['name']} ${land['number1']}${land['number2'] != '' ? '-${land['number2']}' : ''}'
              : '';
          
          // 최종 주소
          // String fullAddress = landAddress.isNotEmpty ? landAddress : regionAddress;\
          String fullAddress = regionAddress + landAddress;
          state = fullAddress;
        } else {
          state = '주소를 찾을 수 없습니다.';
        }
      } else {
        state = '주소 검색 실패';
      }
    } catch (e) {
      state = '주소 검색 오류';
    }
  }
}