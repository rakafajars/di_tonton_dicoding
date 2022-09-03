import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/movie.dart';

part 'movie_recommendation_event.dart';
part 'movie_recommendation_state.dart';

class MovieRecommendationBloc
    extends Bloc<MovieRecommendationEvent, MovieRecommendationState> {
  final GetMovieRecommendations _getMovieRecommendations;

  MovieRecommendationBloc(this._getMovieRecommendations)
      : super(MovieRecommendationEmpty()) {
    on<FetchMovieRecommendationEvent>(
      (event, emit) async {
        final id = event.id;
        emit(MovieRecommendationLoading());
        final result = await _getMovieRecommendations.execute(id);

        result.fold(
            (failure) => emit(MovieRecommendationError(failure.message)),
            (data) => emit(MovieRecommendationHasData(data)));
      },
    );
  }
}
