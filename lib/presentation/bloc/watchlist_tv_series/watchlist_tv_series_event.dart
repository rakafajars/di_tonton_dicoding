part of 'watchlist_tv_series_bloc.dart';

abstract class WatchlistTvSeriesEvent extends Equatable {
  const WatchlistTvSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistTvSeries extends WatchlistTvSeriesEvent {}

class AddWatchlistTvSeriesEvent extends WatchlistTvSeriesEvent {
  final TvSeriesDetail tvSeriesDetail;

  AddWatchlistTvSeriesEvent(this.tvSeriesDetail);
  @override
  List<Object> get props => [tvSeriesDetail];
}

class RemoveWatchlistTvSeriesEvent extends WatchlistTvSeriesEvent {
  final TvSeriesDetail tvSeriesDetail;

  RemoveWatchlistTvSeriesEvent(this.tvSeriesDetail);

  @override
  List<Object> get props => [tvSeriesDetail];
}

class FetchWatchlistTvSeriesStatus extends WatchlistTvSeriesEvent {
  final int id;

  FetchWatchlistTvSeriesStatus(this.id);

  @override
  List<Object> get props => [id];
}
