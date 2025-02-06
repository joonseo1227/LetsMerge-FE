import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum HTTPMethod { get, post }

class NaverSearchAPIRequest {
  static const String _baseUrl = "https://openapi.naver.com/v1/search/";

  late String _path;

  NaverSearchAPIRequest(this._path);

  String get path => _path;

  set setPath(String val) => _path = val;

  Future<dynamic> send(HTTPMethod method,
      {Map<String, dynamic>? params}) async {
    try {
      // URL과 쿼리 파라미터 처리
      final uri = method == HTTPMethod.get
          ? Uri.parse(_baseUrl + _path).replace(queryParameters: params)
          : Uri.parse(_baseUrl + _path);

      http.Request request;

      switch (method) {
        case HTTPMethod.get:
          request = http.Request('GET', uri);
          break;
        case HTTPMethod.post:
          request = http.Request('POST', uri);
          break;
      }

      final headers = {
        'Content-Type': 'application/json',
        'X-Naver-Client-Id': dotenv.env['X-Naver-Client-Id'] ?? "",
        'X-Naver-Client-Secret': dotenv.env['X-Naver-Client-Secret'] ?? "",
      };

      request.headers.addAll(headers);

      // POST 요청일 경우 Body 추가
      if (method == HTTPMethod.post && params != null) {
        request.body = jsonEncode(params);
      }

      final response = await request.send();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = await response.stream.bytesToString();
        return jsonDecode(responseBody);
      } else {
        throw 'Error ${response.statusCode}: ${response.reasonPhrase}';
      }
    } on TimeoutException {
      throw TimeoutException('[Error] api send: timeout');
    } catch (e) {
      throw '\n[Error] api send:$e';
    }
  }
}
