import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';

abstract class TvSeriesRepository {
  Future<Either<Failure, List<TvSeries>>> getTvSeriesAiringToday();
  Future<Either<Failure, List<TvSeries>>> getTvSeriesPopular();
  Future<Either<Failure, List<TvSeries>>> getTvSeriesTopRated();
}
