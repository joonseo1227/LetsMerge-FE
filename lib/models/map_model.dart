

class NaverSearchResult {
  final String title;
  final String link;
  final String category;
  final String description;
  final String telephone;
  final String address;
  final String roadAddress;
  final double mapX;
  final double mapY;

  NaverSearchResult({
    required this.title,
    required this.link,
    required this.category,
    required this.description,
    required this.telephone,
    required this.address,
    required this.roadAddress,
    required this.mapX,
    required this.mapY,
  });

  // JSON에서 객체 변환 (Factory Constructor)
  factory NaverSearchResult.fromJson(Map<String, dynamic> json) {
    return NaverSearchResult(
      title: json['title']?.replaceAll(RegExp(r'<[^>]*>'), '') ?? 'No Title', // HTML 태그 제거
      link: json['link'] ?? '',
      category: json['category'] ?? 'No Category',
      description: json['description'] ?? '',
      telephone: json['telephone'] ?? '',
      address: json['address'] ?? 'No Address',
      roadAddress: json['roadAddress'] ?? 'No Road Address',
      mapX: double.tryParse(json['mapx'].toString()) ?? 0.0,
      mapY: double.tryParse(json['mapy'].toString()) ?? 0.0,
    );
  }

  // 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'link': link,
      'category': category,
      'description': description,
      'telephone': telephone,
      'address': address,
      'roadAddress': roadAddress,
      'mapx': mapX,
      'mapy': mapY,
    };
  }
}

// JSON 리스트를 객체 리스트로 변환하는 함수
List<NaverSearchResult> parseNaverSearchResults(List<dynamic> jsonList) {
  return jsonList.map((item) => NaverSearchResult.fromJson(item)).toList();
}
