class MovieModel {
  final int id;
  final bool isAdult;
  final String? backdropImgUrl;
  final List<int> genreIds;
  final String language;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String? posterImgUrl;
  final String releaseDate;
  final String title;
  final bool isVideoAvailable;
  final double voteAverage;
  final int voteCount;

  MovieModel({
    required this.id,
    required this.isAdult,
    this.backdropImgUrl,
    required this.genreIds,
    required this.language,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterImgUrl,
    required this.releaseDate,
    required this.title,
    required this.isVideoAvailable,
    required this.voteAverage,
    required this.voteCount,
  });

  //* Convet json to MovieModel
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json["id"] ?? 0,
      isAdult: json["adult"] ?? false,
      backdropImgUrl: json["backdrop_path"] as String?,
      genreIds: List<int>.from(json["genre_ids"] ?? []),
      language: json["original_language"] ?? "",
      originalTitle: json["original_title"] ?? "",
      overview: json["overview"] ?? "",
      popularity: json["popularity"] ?? 0,
      posterImgUrl: json["poster_path"] as String?,
      releaseDate: json["release_date"] ?? "",
      title: json["title"] ?? "",
      isVideoAvailable: json["video"] ?? false,
      voteAverage: json["vote_average"].toDouble() ?? 0,
      voteCount: json["vote_count"].toInt() ?? 0,
    );
  }
}
