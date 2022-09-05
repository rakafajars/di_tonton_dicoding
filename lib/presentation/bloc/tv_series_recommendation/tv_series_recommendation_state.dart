part of 'tv_series_recommendation_bloc.dart';

abstract class TvSeriesRecommendationState extends Equatable {
  const TvSeriesRecommendationState();

  @override
  List<Object> get props => [];
}

class TvSeriesRecommendationEmpty extends TvSeriesRecommendationState {}

class TvSeriesRecommendationLoading extends TvSeriesRecommendationState {}

class TvSeriesRecommendationHasData extends TvSeriesRecommendationState {
  final List<TvSeries> result;

  TvSeriesRecommendationHasData(this.result);

  @override
  List<Object> get props => [result];
}

class TvSeriesRecommendationError extends TvSeriesRecommendationState {
  final String message;

  const TvSeriesRecommendationError(this.message);

  @override
  List<Object> get props => [message];
}
