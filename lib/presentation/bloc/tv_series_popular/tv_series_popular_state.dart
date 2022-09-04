part of 'tv_series_popular_bloc.dart';

abstract class TvSeriesPopularState extends Equatable {
  const TvSeriesPopularState();

  @override
  List<Object> get props => [];
}

class TvSeriesPopularEmpty extends TvSeriesPopularState {}

class TvSeriesPopularLoading extends TvSeriesPopularState {}

class TvSeriesPopularHasData extends TvSeriesPopularState {
  final List<TvSeries> result;

  const TvSeriesPopularHasData(this.result);

  @override
  List<Object> get props => [result];
}

class TvSeriesPopularError extends TvSeriesPopularState {
  final String message;

  const TvSeriesPopularError(this.message);

  @override
  List<Object> get props => [message];
}
