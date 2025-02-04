import 'package:letsmerge/models/map_model.dart';
import 'package:letsmerge/server/rest_api.dart';

class NaverSearchProvider {
  Future<dynamic> SearchPlace({
    required String query,
    int display = 10,
  }) async {
    final params = {
      'query': query,
      'display': display.toString()
    };

    try {
      final api = NaverSearchAPIRequest('local.json');
      Map<String, dynamic> response = await api.send(HTTPMethod.get, params: params);

      // items 리스트를 변환
      final List<dynamic> items = response['items'];

      List<NaverSearchResult> results = parseNaverSearchResults(items);

      return results; // 리스트 반환
      // print("API : $response");
    } catch(e) {
      throw '[Error] NaverAPIProvider: $e';
    }
  }
}