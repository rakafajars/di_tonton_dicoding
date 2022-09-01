import 'package:dartz/dartz.dart';
import '../../../utils/failure.dart';
import '../../entities/tv_series.dart';
import '../../repositories/tv_series_repository.dart';

class GetTvSeriesRecommendation {
  final TvSeriesRepository repository;

  GetTvSeriesRecommendation(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute(int id) {
    return repository.getTvSeriesRecommendation(id);
  }
}
