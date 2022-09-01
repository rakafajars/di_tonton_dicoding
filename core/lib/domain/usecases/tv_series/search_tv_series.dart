import 'package:dartz/dartz.dart';
import '../../../utils/failure.dart';
import '../../entities/tv_series.dart';
import '../../repositories/tv_series_repository.dart';

class SearchTvSeries {
  final TvSeriesRepository repository;

  SearchTvSeries(this.repository);
  Future<Either<Failure, List<TvSeries>>> execute(String query) {
    return repository.searchTvSeries(query);
  }
}
