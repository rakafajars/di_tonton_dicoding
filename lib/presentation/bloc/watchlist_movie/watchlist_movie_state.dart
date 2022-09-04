part of 'watchlist_movie_bloc.dart';

abstract class WatchlistMovieState extends Equatable {
  const WatchlistMovieState();

  @override
  List<Object> get props => [];
}

class WatchlistMovieInitial extends WatchlistMovieState {}

class SaveWatchlistMovieHasData extends WatchlistMovieState {
  final String message;

  SaveWatchlistMovieHasData(this.message);
  @override
  List<Object> get props => [message];
}

class SaveWatchlistMovieError extends WatchlistMovieState {
  final String message;

  SaveWatchlistMovieError(this.message);
  @override
  List<Object> get props => [message];
}

class RemoveWatchlistMovieHasData extends WatchlistMovieState {
  final String message;

  RemoveWatchlistMovieHasData(this.message);
  @override
  List<Object> get props => [message];
}

class RemoveWatchlistMovieError extends WatchlistMovieState {
  final String message;

  RemoveWatchlistMovieError(this.message);
  @override
  List<Object> get props => [message];
}

class WatchlistStatusHasData extends WatchlistMovieState {
  final bool isAddtoWatchlist;

  WatchlistStatusHasData({
    this.isAddtoWatchlist = false,
  });

  @override
  List<Object> get props => [isAddtoWatchlist];
}
