import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class GetTvSeriesWatchlistStatus {
  final TvSeriesRepository repository;

  GetTvSeriesWatchlistStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToTvSerieslist(id);
  }
}
