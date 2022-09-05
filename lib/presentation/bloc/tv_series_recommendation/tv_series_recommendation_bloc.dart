import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_recommendation.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/tv_series.dart';

part 'tv_series_recommendation_event.dart';
part 'tv_series_recommendation_state.dart';

class TvSeriesRecommendationBloc
    extends Bloc<TvSeriesRecommendationEvent, TvSeriesRecommendationState> {
  final GetTvSeriesRecommendation _getTvSeriesRecommendation;

  TvSeriesRecommendationBloc(this._getTvSeriesRecommendation)
      : super(TvSeriesRecommendationEmpty()) {
    on<FetchTvSeriesRecommendationEvent>((event, emit) async {
      final id = event.id;
      emit(TvSeriesRecommendationLoading());
      final result = await _getTvSeriesRecommendation.execute(id);

      result.fold(
          (failure) => emit(TvSeriesRecommendationError(failure.message)),
          (data) => emit(TvSeriesRecommendationHasData(data)));
    });
  }
}
