part of 'tv_series_airing_today_bloc.dart';

abstract class TvSeriesAiringTodayEvent extends Equatable {
  const TvSeriesAiringTodayEvent();

  @override
  List<Object> get props => [];
}

class FetchTvSeriesAiringTodayEvent extends TvSeriesAiringTodayEvent {}
