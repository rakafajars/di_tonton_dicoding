part of 'tv_series_airing_today_bloc.dart';

abstract class TvSeriesAiringTodayState extends Equatable {
  const TvSeriesAiringTodayState();

  @override
  List<Object> get props => [];
}

class TvSeriesAiringEmpty extends TvSeriesAiringTodayState {}

class TvSeriesAiringLoading extends TvSeriesAiringTodayState {}

class TvSeriesAiringHasData extends TvSeriesAiringTodayState {
  final List<TvSeries> result;

  const TvSeriesAiringHasData(this.result);

  @override
  List<Object> get props => [result];
}

class TvSeriesAiringError extends TvSeriesAiringTodayState {
  final String message;

  const TvSeriesAiringError(this.message);

  @override
  List<Object> get props => [message];
}
