import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/presentation/bloc/movie_recommendation/movie_recommendation_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_recommendation_bloc_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main() {
  late MovieRecommendationBloc movieRecommendationBloc;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  final tId = 1;

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    movieRecommendationBloc =
        MovieRecommendationBloc(mockGetMovieRecommendations);
  });

  test('initial state should be empty', () {
    expect(movieRecommendationBloc.state, MovieRecommendationEmpty());
  });

  blocTest(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetMovieRecommendations.execute(tId)).thenAnswer(
        (_) async => Right(
          tMovies,
        ),
      );

      return movieRecommendationBloc;
    },
    act: (MovieRecommendationBloc bloc) =>
        bloc.add(FetchMovieRecommendationEvent(tId)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      MovieRecommendationLoading(),
      MovieRecommendationHasData(tMovies),
    ],
    verify: (bloc) {
      verify(mockGetMovieRecommendations.execute(tId));
    },
  );

  blocTest(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetMovieRecommendations.execute(tId)).thenAnswer(
        (_) async => Left(
          ServerFailure(
            'Server Failure',
          ),
        ),
      );

      return movieRecommendationBloc;
    },
    wait: const Duration(milliseconds: 500),
    act: (MovieRecommendationBloc bloc) =>
        bloc.add(FetchMovieRecommendationEvent(tId)),
    expect: () => [
      MovieRecommendationLoading(),
      MovieRecommendationError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetMovieRecommendations.execute(tId));
    },
  );
}
