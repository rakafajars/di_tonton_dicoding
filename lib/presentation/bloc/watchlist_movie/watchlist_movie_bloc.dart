import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/movie_detail.dart';

part 'watchlist_movie_event.dart';
part 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchListStatus _getWatchListStatus;
  final SaveWatchlist _saveWatchlist;
  final RemoveWatchlist _removeWatchlist;
  WatchlistMovieBloc(
    this._getWatchListStatus,
    this._saveWatchlist,
    this._removeWatchlist,
  ) : super(WatchlistMovieInitial()) {
    on<WatchlistMovieEvent>(
      (event, emit) async {
        if (event is AddWatchlistMovieEvent) {
          final result = await _saveWatchlist.execute(event.movieDetail);

          result.fold(
            (failure) => emit(SaveWatchlistMovieError(failure.message)),
            (data) => emit(SaveWatchlistMovieHasData('Added to Watchlist')),
          );
        }
        if (event is RemoveWatchlistMovieEvent) {
          final result = await _removeWatchlist.execute(event.movieDetail);

          result.fold(
            (failure) => emit(RemoveWatchlistMovieError(failure.message)),
            (data) =>
                emit(RemoveWatchlistMovieHasData('Removed from Watchlist')),
          );
        }
        if (event is FetchWatchlistMovieStatus) {
          final result = await _getWatchListStatus.execute(event.id);

          emit(
            WatchlistStatusHasData(
              isAddtoWatchlist: result,
            ),
          );
        }
      },
    );
  }
}
