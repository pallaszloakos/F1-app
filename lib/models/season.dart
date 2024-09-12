class Season {
  final String season;
  final String url;

  Season({required this.season, required this.url});

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      season: json['season'],
      url: json['url']
    );
  }
}
