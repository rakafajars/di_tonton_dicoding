import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_recommendation.dart';
import 'package:ditonton/presentation/bloc/tv_series_recommendation/tv_series_recommendation_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_recommendation_bloc_test.mocks.dart';

@GenerateMocks([GetTvSeriesRecommendation])
void main() {
  late TvSeriesRecommendationBloc tvSeriesRecommendationBloc;
  late MockGetTvSeriesRecommendation mockGetTvSeriesRecommendation;

  final tId = 1;
  final tTvSeries = TvSeries(
    backdropPath: "backdropPath",
    firstAirDate: "firstAirDate",
    genreIds: [1, 2, 3],
    id: 1,
    name: "name",
    originCountry: ["1", "2"],
    originalLanguage: "originalLanguage",
    originalName: "originalName",
    overview: "overview",
    popularity: 1,
    posterPath: "posterPath",
    voteAverage: 1,
    voteCount: 1,
  );

  final tTvSeriesList = <TvSeries>[tTvSeries];

  setUp(() {
    mockGetTvSeriesRecommendation = MockGetTvSeriesRecommendation();
    tvSeriesRecommendationBloc =
        TvSeriesRecommendationBloc(mockGetTvSeriesRecommendation);
  });

  test('initial state should be empty', () {
    expect(tvSeriesRecommendationBloc.state, TvSeriesRecommendationEmpty());
  });

  blocTest(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvSeriesRecommendation.execute(tId)).thenAnswer(
        (_) async => Right(
          tTvSeriesList,
        ),
      );

      return tvSeriesRecommendationBloc;
    },
    act: (TvSeriesRecommendationBloc bloc) =>
        bloc.add(FetchTvSeriesRecommendationEvent(tId)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSeriesRecommendationLoading(),
      TvSeriesRecommendationHasData(tTvSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetTvSeriesRecommendation.execute(tId));
    },
  );

  blocTest(
    'Should emit [Loading, Error] when data is gotten successfully',
    build: () {
      when(mockGetTvSeriesRecommendation.execute(tId)).thenAnswer(
        (_) async => Left(
          ServerFailure(
            'Server Failure',
          ),
        ),
      );

      return tvSeriesRecommendationBloc;
    },
    wait: const Duration(milliseconds: 500),
    act: (TvSeriesRecommendationBloc bloc) =>
        bloc.add(FetchTvSeriesRecommendationEvent(tId)),
    expect: () => [
      TvSeriesRecommendationLoading(),
      TvSeriesRecommendationError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTvSeriesRecommendation.execute(tId));
    },
  );
}
