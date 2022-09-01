import 'package:dartz/dartz.dart';

import '../../../utils/failure.dart';
import '../../entities/tv_series.dart';
import '../../repositories/tv_series_repository.dart';

class GetTvSeriesPopular {
  final TvSeriesRepository repository;

  GetTvSeriesPopular(this.repository);
  Future<Either<Failure, List<TvSeries>>> execute() {
    return repository.getTvSeriesPopular();
  }
}
