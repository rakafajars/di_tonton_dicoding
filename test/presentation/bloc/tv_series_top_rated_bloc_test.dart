import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_top_rated.dart';
import 'package:ditonton/presentation/bloc/tv_series_top_rated/tv_series_top_rated_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_top_rated_bloc_test.mocks.dart';

@GenerateMocks([GetTvSeriesTopRated])
void main() {
  late MockGetTvSeriesTopRated mockGetTvSeriesTopRated;
  late TvSeriesTopRatedBloc tvSeriesTopRatedBloc;

  setUp(() {
    mockGetTvSeriesTopRated = MockGetTvSeriesTopRated();
    tvSeriesTopRatedBloc = TvSeriesTopRatedBloc(mockGetTvSeriesTopRated);
  });

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

  // pengujian verivikasi awal
  test('initial state should be empty', () {
    expect(tvSeriesTopRatedBloc.state, TvSeriesTopRatedEmpty());
  });

  blocTest(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvSeriesTopRated.execute()).thenAnswer(
        (_) async => Right(
          tTvSeriesList,
        ),
      );

      return tvSeriesTopRatedBloc;
    },
    act: (TvSeriesTopRatedBloc bloc) => bloc.add(FetchTvSeriesTopRatedEvent()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSeriesTopRatedLoading(),
      TvSeriesTopRatedHasData(tTvSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetTvSeriesTopRated.execute());
    },
  );

  blocTest(
    'Should emit [Loading, Error] when data is gotten successfully',
    build: () {
      when(mockGetTvSeriesTopRated.execute()).thenAnswer(
        (_) async => Left(
          ServerFailure(
            'Server Failure',
          ),
        ),
      );

      return tvSeriesTopRatedBloc;
    },
    wait: const Duration(milliseconds: 500),
    act: (TvSeriesTopRatedBloc bloc) => bloc.add(FetchTvSeriesTopRatedEvent()),
    expect: () => [
      TvSeriesTopRatedLoading(),
      TvSeriesTopRatedError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTvSeriesTopRated.execute());
    },
  );
}
