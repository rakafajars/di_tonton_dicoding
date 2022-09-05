part of 'tv_series_detail_bloc.dart';

abstract class TvSeriesDetailEvent extends Equatable {
  const TvSeriesDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTvSeriesDetailEvent extends TvSeriesDetailEvent {
  final int id;

  FetchTvSeriesDetailEvent(this.id);

  @override
  List<Object> get props => [id];
}
