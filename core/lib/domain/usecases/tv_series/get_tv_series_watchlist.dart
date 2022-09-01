import 'package:dartz/dartz.dart';
import '../../../utils/failure.dart';
import '../../entities/tv_series.dart';
import '../../repositories/tv_series_repository.dart';

class GetTvSeriesWatchlist {
  final TvSeriesRepository _repository;

  GetTvSeriesWatchlist(this._repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return _repository.getTvSeriesWatchlist();
  }
}
