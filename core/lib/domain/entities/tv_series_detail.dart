import 'package:equatable/equatable.dart';

class TvSeriesDetail extends Equatable {
  final String? posterPath;
  final String? originalName;
  final double? voteAverage;
  final String? overview;
  final int id;

  TvSeriesDetail({
    required this.id,
    required this.posterPath,
    required this.originalName,
    required this.voteAverage,
    required this.overview,
  });
  @override
  List<Object?> get props => [
        id,
        posterPath,
        originalName,
        voteAverage,
        overview,
      ];
}
