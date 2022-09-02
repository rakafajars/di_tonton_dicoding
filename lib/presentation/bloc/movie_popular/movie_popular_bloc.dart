import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/movie.dart';

part 'movie_popular_event.dart';
part 'movie_popular_state.dart';

class MoviePopularBloc extends Bloc<MoviePopularEvent, MoviePopularState> {
  final GetPopularMovies _getPopularMovies;
  MoviePopularBloc(this._getPopularMovies) : super(MoviePopularEmpty()) {
    on<FetchMoviePopularEvent>(
      (event, emit) async {
        emit(MoviePopularLoading());
        final result = await _getPopularMovies.execute();
        result.fold(
          (failure) => emit(MoviePopularError(failure.message)),
          (data) => emit(MoviePopularHasData(data)),
        );
      },
    );
  }
}
