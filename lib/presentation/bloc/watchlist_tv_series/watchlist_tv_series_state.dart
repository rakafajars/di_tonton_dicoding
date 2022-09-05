part of 'watchlist_tv_series_bloc.dart';

abstract class WatchlistTvSeriesState extends Equatable {
  const WatchlistTvSeriesState();

  @override
  List<Object> get props => [];
}

class WatchlistTvSeriesEmpty extends WatchlistTvSeriesState {}

class WatchlistTvSeriesLoading extends WatchlistTvSeriesState {}

class WatchlistTvSeriesHasData extends WatchlistTvSeriesState {
  final List<TvSeries> result;

  WatchlistTvSeriesHasData(this.result);
  @override
  List<Object> get props => [result];
}

class WatchlistTvSeriesError extends WatchlistTvSeriesState {
  final String message;

  WatchlistTvSeriesError(this.message);
  @override
  List<Object> get props => [message];
}

class SaveWatchlistTvSeriesHasData extends WatchlistTvSeriesState {
  final String message;

  SaveWatchlistTvSeriesHasData(this.message);
  @override
  List<Object> get props => [message];
}

class SaveWatchlistTvSeriesError extends WatchlistTvSeriesState {
  final String message;

  SaveWatchlistTvSeriesError(this.message);
  @override
  List<Object> get props => [message];
}

class RemoveWatchlistTvSeriesHasData extends WatchlistTvSeriesState {
  final String message;

  RemoveWatchlistTvSeriesHasData(this.message);
  @override
  List<Object> get props => [message];
}

class RemoveWatchlistTvSeriesError extends WatchlistTvSeriesState {
  final String message;

  RemoveWatchlistTvSeriesError(this.message);
  @override
  List<Object> get props => [message];
}

class WatchlistStatusHasData extends WatchlistTvSeriesState {
  final bool isAddtoWatchlist;

  WatchlistStatusHasData({
    this.isAddtoWatchlist = false,
  });

  @override
  List<Object> get props => [isAddtoWatchlist];
}
