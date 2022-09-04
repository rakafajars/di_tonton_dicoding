import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_airing_today.dart';
import 'package:equatable/equatable.dart';

part 'tv_series_airing_today_event.dart';
part 'tv_series_airing_today_state.dart';

class TvSeriesAiringTodayBloc
    extends Bloc<TvSeriesAiringTodayEvent, TvSeriesAiringTodayState> {
  final GetTvSeriesAiringToday _getTvSeriesAiringToday;

  TvSeriesAiringTodayBloc(this._getTvSeriesAiringToday)
      : super(TvSeriesAiringEmpty()) {
    on<FetchTvSeriesAiringTodayEvent>((event, emit) async {
      emit(TvSeriesAiringLoading());
      final result = await _getTvSeriesAiringToday.execute();
      result.fold(
        (failure) => emit(TvSeriesAiringError(failure.message)),
        (data) => emit(TvSeriesAiringHasData(data)),
      );
    });
  }
}
