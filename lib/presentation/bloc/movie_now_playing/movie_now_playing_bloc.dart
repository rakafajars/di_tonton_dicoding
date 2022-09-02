import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_now_playing_movies.dart';

part 'movie_now_playing_event.dart';
part 'movie_now_playing_state.dart';

class MovieNowPlayingBloc
    extends Bloc<MovieNowPlayingEvent, MovieNowPlayingState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  MovieNowPlayingBloc(this._getNowPlayingMovies)
      : super(MovieNowPlayingEmpty()) {
    on<FetchNowPlayingMovieEvent>(
      (event, emit) async {
        emit(MovieNowPlayingLoading());
        final result = await _getNowPlayingMovies.execute();
        result.fold(
          (failure) => emit(MovieNowPlayingError(failure.message)),
          (data) => emit(MovieNowPlayingHasData(data)),
        );
      },
    );
  }
}
