import 'package:ditonton/domain/entities/tv_series_detail.dart';

class TvSeriesDetailResponse {
  TvSeriesDetailResponse(
      {this.overview,
      this.posterPath,
      this.originalName,
      this.voteAverage,
      required this.id});
  final int id;
  final String? posterPath;
  final String? originalName;
  final double? voteAverage;
  final String? overview;

  factory TvSeriesDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvSeriesDetailResponse(
        id: json['id'],
        posterPath: json["poster_path"],
        originalName: json["original_name"],
        overview: json["overview"],
        voteAverage: json["vote_average"].toDouble(),
      );

  TvSeriesDetail toEntity() {
    return TvSeriesDetail(
      id: id,
      posterPath: this.posterPath,
      originalName: this.originalName,
      overview: this.overview,
      voteAverage: this.voteAverage,
    );
  }
}
