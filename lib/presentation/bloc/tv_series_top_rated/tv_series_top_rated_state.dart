part of 'tv_series_top_rated_bloc.dart';

abstract class TvSeriesTopRatedState extends Equatable {
  const TvSeriesTopRatedState();

  @override
  List<Object> get props => [];
}

class TvSeriesTopRatedEmpty extends TvSeriesTopRatedState {}

class TvSeriesTopRatedLoading extends TvSeriesTopRatedState {}

class TvSeriesTopRatedHasData extends TvSeriesTopRatedState {
  final List<TvSeries> result;

  const TvSeriesTopRatedHasData(this.result);

  @override
  List<Object> get props => [result];
}

class TvSeriesTopRatedError extends TvSeriesTopRatedState {
  final String message;

  const TvSeriesTopRatedError(this.message);

  @override
  List<Object> get props => [message];
}
