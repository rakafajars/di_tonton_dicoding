import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_tv_series_watchlist.dart';
import 'package:flutter/foundation.dart';

class TvSeriesWatchlistNotifier extends ChangeNotifier {
  final GetTvSeriesWatchlist getTvSeriesWatchlist;

  var _tvSeriesWatchlist = <TvSeries>[];

  List<TvSeries> get tvSeriesWatchlist => _tvSeriesWatchlist;

  var _tvSeriesState = RequestState.Empty;
  RequestState get tvSeriesState => _tvSeriesState;
  String _message = '';
  String get message => _message;

  TvSeriesWatchlistNotifier({required this.getTvSeriesWatchlist});

  Future<void> fetchTvSeriesWatchlistMovies() async {
    _tvSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getTvSeriesWatchlist.execute();
    result.fold(
      (failure) {
        _tvSeriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _tvSeriesState = RequestState.Loaded;
        _tvSeriesWatchlist = moviesData;
        notifyListeners();
      },
    );
  }
}
