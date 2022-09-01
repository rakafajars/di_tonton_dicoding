import 'package:dartz/dartz.dart';
import '../../utils/failure.dart';
import '../entities/tv_series.dart';
import '../entities/tv_series_detail.dart';

abstract class TvSeriesRepository {
  Future<Either<Failure, List<TvSeries>>> getTvSeriesAiringToday();
  Future<Either<Failure, List<TvSeries>>> getTvSeriesPopular();
  Future<Either<Failure, List<TvSeries>>> getTvSeriesTopRated();
  Future<Either<Failure, TvSeriesDetail>> getTvSeriesDetail(int id);
  Future<Either<Failure, List<TvSeries>>> getTvSeriesRecommendation(int id);
  Future<Either<Failure, List<TvSeries>>> searchTvSeries(String query);
  Future<Either<Failure, String>> saveTvSeriesWatchlist(
      TvSeriesDetail tvSeries);
  Future<Either<Failure, String>> removeTvSeriesWatchlist(
      TvSeriesDetail tvSeries);
  Future<bool> isAddedToTvSerieslist(int id);
  Future<Either<Failure, List<TvSeries>>> getTvSeriesWatchlist();
}
