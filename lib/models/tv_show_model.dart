class TvShowModel {
  final int id;
  final bool isAdult;
  final String? posterImgUrl;
  final String name;
  final String overview;
  final String firstAirDate;
  final double voteAverage;
  final int voteCount;

  TvShowModel({
    required this.id,
    required this.isAdult,
    this.posterImgUrl,
    required this.name,
    required this.overview,
    required this.firstAirDate,
    required this.voteAverage,
    required this.voteCount,
  });

  //* Convert json to TvShowModel
  factory TvShowModel.fromJson(Map<String, dynamic> json) {
    return TvShowModel(
      id: json["id"] ?? 0,
      isAdult: json["adult"] ?? false,
      posterImgUrl: json["poster_path"] as String?,
      name: json["name"] ?? "",
      overview: json["overview"] ?? "",
      firstAirDate: json["first_air_date"] ?? "",
      voteAverage: json["vote_average"].toDouble() ?? 0,
      voteCount: json["vote_count"].toInt() ?? 0,
    );
  }
}
