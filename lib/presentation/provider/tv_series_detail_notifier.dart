import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendation.dart';
import 'package:flutter/foundation.dart';

import '../../common/state_enum.dart';

class TvSeriesDetailNotifier extends ChangeNotifier {
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

  String _message = '';
  String get message => _message;

  TvSeriesDetailNotifier({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendation,
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
}
