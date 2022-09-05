import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_popular.dart';
import 'package:ditonton/presentation/bloc/tv_series_popular/tv_series_popular_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_popular_bloc_test.mocks.dart';

@GenerateMocks([GetTvSeriesPopular])
void main() {
  late MockGetTvSeriesPopular mockGetTvSeriesPopular;
  late TvSeriesPopularBloc tvSeriesPopularBloc;

  setUp(() {
    mockGetTvSeriesPopular = MockGetTvSeriesPopular();
    tvSeriesPopularBloc = TvSeriesPopularBloc(mockGetTvSeriesPopular);
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
    expect(tvSeriesPopularBloc.state, TvSeriesPopularEmpty());
  });

  blocTest(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvSeriesPopular.execute()).thenAnswer(
        (_) async => Right(
          tTvSeriesList,
        ),
      );

      return tvSeriesPopularBloc;
    },
    act: (TvSeriesPopularBloc bloc) => bloc.add(FetchTvSeriesPopularEvent()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSeriesPopularLoading(),
      TvSeriesPopularHasData(tTvSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetTvSeriesPopular.execute());
    },
  );

  blocTest(
    'Should emit [Loading, Error] when data is gotten successfully',
    build: () {
      when(mockGetTvSeriesPopular.execute()).thenAnswer(
        (_) async => Left(
          ServerFailure(
            'Server Failure',
          ),
        ),
      );

      return tvSeriesPopularBloc;
    },
    wait: const Duration(milliseconds: 500),
    act: (TvSeriesPopularBloc bloc) => bloc.add(FetchTvSeriesPopularEvent()),
    expect: () => [
      TvSeriesPopularLoading(),
      TvSeriesPopularError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTvSeriesPopular.execute());
    },
  );
}
