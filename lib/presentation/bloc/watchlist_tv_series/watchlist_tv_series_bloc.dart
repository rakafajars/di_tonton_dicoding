import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_watchlist.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_watchlist_status.dart';
import 'package:ditonton/domain/usecases/tv_series/remove_tv_series_watchlist.dart';
import 'package:ditonton/domain/usecases/tv_series/save_tv_series_watchlist.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/tv_series.dart';
import '../../../domain/entities/tv_series_detail.dart';

part 'watchlist_tv_series_event.dart';
part 'watchlist_tv_series_state.dart';

class WatchlistTvSeriesBloc
    extends Bloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState> {
  final GetTvSeriesWatchlist _getTvSeriesWatchlist;
  final GetTvSeriesWatchlistStatus _getTvSeriesWatchlistStatus;
  final SaveTvSeriesWatchlist _saveTvSeriesWatchlist;
  final RemoveTvSeriesWatchlist _removeTvSeriesWatchlis;

  WatchlistTvSeriesBloc(
      this._getTvSeriesWatchlist,
      this._getTvSeriesWatchlistStatus,
      this._saveTvSeriesWatchlist,
      this._removeTvSeriesWatchlis)
      : super(WatchlistTvSeriesEmpty()) {
    on<WatchlistTvSeriesEvent>((event, emit) async {
      if (event is FetchWatchlistTvSeries) {
        emit(WatchlistTvSeriesLoading());
        final result = await _getTvSeriesWatchlist.execute();

        result.fold(
          (failure) => emit(WatchlistTvSeriesError(failure.message)),
          (data) => emit(WatchlistTvSeriesHasData(data)),
        );
      }
      if (event is AddWatchlistTvSeriesEvent) {
        final result =
            await _saveTvSeriesWatchlist.execute(event.tvSeriesDetail);

        result.fold(
          (failure) => emit(SaveWatchlistTvSeriesError(failure.message)),
          (data) => emit(SaveWatchlistTvSeriesHasData('Added to Watchlist')),
        );
      }
      if (event is RemoveWatchlistTvSeriesEvent) {
        final result =
            await _removeTvSeriesWatchlis.execute(event.tvSeriesDetail);

        result.fold(
          (failure) => emit(RemoveWatchlistTvSeriesError(failure.message)),
          (data) =>
              emit(RemoveWatchlistTvSeriesHasData('Removed from Watchlist')),
        );
      }
      if (event is FetchWatchlistTvSeriesStatus) {
        final result = await _getTvSeriesWatchlistStatus.execute(event.id);

        emit(
          WatchlistStatusHasData(
            isAddtoWatchlist: result,
          ),
        );
      }
    });
  }
}
