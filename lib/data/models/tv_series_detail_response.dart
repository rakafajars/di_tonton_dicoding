import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

class TvSeriesDetailResponse extends Equatable {
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

  @override
  List<Object?> get props => [
        id,
        posterPath,
        originalName,
        overview,
        voteAverage,
      ];
}
