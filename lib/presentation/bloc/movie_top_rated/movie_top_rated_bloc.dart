import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/movie.dart';

part 'movie_top_rated_event.dart';
part 'movie_top_rated_state.dart';

class MovieTopRatedBloc extends Bloc<MovieTopRatedEvent, MovieTopRatedState> {
  final GetTopRatedMovies _getTopRatedMovies;
  MovieTopRatedBloc(this._getTopRatedMovies) : super(MovieTopRatedEmpty()) {
    on<FetchMovieTopRatedEvent>(
      (event, emit) async {
        emit(MovieTopRatedLoading());
        final result = await _getTopRatedMovies.execute();
        result.fold(
          (failure) => emit(MovieTopRatedError(failure.message)),
          (data) => emit(MovieTopRatedHasData(data)),
        );
      },
    );
  }
}
