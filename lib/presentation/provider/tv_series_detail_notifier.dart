import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendation.dart';
import 'package:ditonton/domain/usecases/get_tv_series_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_tv_series_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_series_watchlist.dart';
import 'package:flutter/foundation.dart';

import '../../common/state_enum.dart';

class TvSeriesDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  // Detail Tv Series
  final GetTvSeriesDetail getTvSeriesDetail;

  late TvSeriesDetail _tvSeriesDetail;
  TvSeriesDetail get tvSeriesDetail => _tvSeriesDetail;

  RequestState _tvSeriesDetailState = RequestState.Empty;
  RequestState get tvSeriesDetailState => _tvSeriesDetailState;

  // Tv Recommendation
  final GetTvSeriesRecommendation getTvSeriesRecommendation;

  List<TvSeries> _tvSeriesRecommendation = [];
  List<TvSeries> get tvSeriesRecommendation => _tvSeriesRecommendation;

  RequestState _tvSeriesRecommendationState = RequestState.Empty;
  RequestState get tvSeriesRecommendationState => _tvSeriesRecommendationState;

  // save TV Recommencation
  final SaveTvSeriesWatchlist saveTvSeriesWatchlist;
  final RemoveTvSeriesWatchlist removeTvSeriesWatchlist;
  final GetTvSeriesWatchlistStatus getTvSeriesWatchlistStatus;
  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  String _message = '';
  String get message => _message;

  TvSeriesDetailNotifier({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendation,
    required this.saveTvSeriesWatchlist,
    required this.removeTvSeriesWatchlist,
    required this.getTvSeriesWatchlistStatus,
  });

  Future<void> fetchTvSeriesDetail(int id) async {
    _tvSeriesDetailState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getTvSeriesDetail.execute(id);
    final recommendationResult = await getTvSeriesRecommendation.execute(id);

    detailResult.fold(
      (failure) {
        _tvSeriesDetailState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeries) {
        _tvSeriesRecommendationState = RequestState.Loading;
        _tvSeriesDetail = tvSeries;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _tvSeriesRecommendationState = RequestState.Error;
            _message = failure.message;
          },
          (tvSeriesRecomendation) {
            _tvSeriesRecommendationState = RequestState.Loaded;
            _tvSeriesRecommendation = tvSeriesRecomendation;
          },
        );

        _tvSeriesDetailState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;
  Future<void> addTvSeriesList(TvSeriesDetail tvSeries) async {
    final result = await saveTvSeriesWatchlist.execute(tvSeries);
    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    print(tvSeries.id);

    await loadTvSeriesListStatus(tvSeries.id);
  }

  Future<void> removeTvSeriesFromTvSerieslist(TvSeriesDetail tvSeries) async {
    final result = await removeTvSeriesWatchlist.execute(tvSeries);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadTvSeriesListStatus(tvSeries.id);
  }

  Future<void> loadTvSeriesListStatus(int id) async {
    final result = await getTvSeriesWatchlistStatus.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}
