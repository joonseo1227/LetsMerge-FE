class TermsModel {
  final String title;
  final String content;

  TermsModel({required this.title, required this.content});

  factory TermsModel.fromJson(Map<String, dynamic> json) {
    return TermsModel(
      title: json['title'],
      content: json['content'],
    );
  }
}
