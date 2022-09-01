import 'package:flutter/foundation.dart';

import '../../core.dart';
import '../../domain/entities/tv_series.dart';
import '../../domain/usecases/tv_series/get_tv_series_airing_today.dart';
import '../../domain/usecases/tv_series/get_tv_series_popular.dart';
import '../../domain/usecases/tv_series/get_tv_series_top_rated.dart';

class TvSeriesListNotifier extends ChangeNotifier {
  // Tv Series Airing Today
  final GetTvSeriesAiringToday getTvSeriesAiringToday;

  RequestState _tvSeriesAiringTodayState = RequestState.Empty;
  RequestState get tvSeriesAiringTodayState => _tvSeriesAiringTodayState;

  List<TvSeries> _tvSeriesAiringToday = [];
  List<TvSeries> get tvSeriesAiringToday => _tvSeriesAiringToday;

  // Tv Series Popular
  final GetTvSeriesPopular getTvSeriesPopular;

  RequestState _tvSeriesPopularState = RequestState.Empty;
  RequestState get tvSeriesPopularState => _tvSeriesPopularState;

  List<TvSeries> _tvSeriesPopular = [];
  List<TvSeries> get tvSeriesPupular => _tvSeriesPopular;

  // Tv Series Top Rated
  final GetTvSeriesTopRated getTvSeriesTopRated;

  RequestState _tvSerisTopRatedState = RequestState.Empty;
  RequestState get tvSerisTopRatedState => _tvSerisTopRatedState;

  List<TvSeries> _tvSeriesTopRated = [];
  List<TvSeries> get tvSeriesTopRated => _tvSeriesTopRated;

  String _message = "";
  String get message => _message;

  TvSeriesListNotifier({
    required this.getTvSeriesAiringToday,
    required this.getTvSeriesPopular,
    required this.getTvSeriesTopRated,
  });

  Future<void> fetchTvSeriesAiringToday() async {
    _tvSeriesAiringTodayState = RequestState.Loading;
    notifyListeners();
    final result = await getTvSeriesAiringToday.execute();
    result.fold(
      (failure) {
        _tvSeriesAiringTodayState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        _tvSeriesAiringTodayState = RequestState.Loaded;
        _tvSeriesAiringToday = tvSeriesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTvSeriesPopular() async {
    _tvSeriesPopularState = RequestState.Loading;
    notifyListeners();
    final result = await getTvSeriesPopular.execute();
    result.fold(
      (failure) {
        _tvSeriesPopularState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        _tvSeriesPopularState = RequestState.Loaded;
        _tvSeriesPopular = tvSeriesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTvTopRated() async {
    _tvSerisTopRatedState = RequestState.Loading;
    notifyListeners();
    final result = await getTvSeriesTopRated.execute();
    result.fold(
      (failure) {
        _tvSerisTopRatedState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesData) {
        _tvSerisTopRatedState = RequestState.Loaded;
        _tvSeriesTopRated = tvSeriesData;
        notifyListeners();
      },
    );
  }
}
