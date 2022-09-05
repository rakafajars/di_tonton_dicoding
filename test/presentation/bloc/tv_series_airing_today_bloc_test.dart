import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_airing_today.dart';
import 'package:ditonton/presentation/bloc/tv_series_airing_today/tv_series_airing_today_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_airing_today_bloc_test.mocks.dart';

@GenerateMocks([GetTvSeriesAiringToday])
void main() {
  late MockGetTvSeriesAiringToday mockGetTvSeriesAiringToday;
  late TvSeriesAiringTodayBloc tvSeriesAiringTodayBloc;

  setUp(() {
    mockGetTvSeriesAiringToday = MockGetTvSeriesAiringToday();
    tvSeriesAiringTodayBloc =
        TvSeriesAiringTodayBloc(mockGetTvSeriesAiringToday);
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
    expect(tvSeriesAiringTodayBloc.state, TvSeriesAiringEmpty());
  });

  blocTest(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvSeriesAiringToday.execute()).thenAnswer(
        (_) async => Right(
          tTvSeriesList,
        ),
      );

      return tvSeriesAiringTodayBloc;
    },
    act: (TvSeriesAiringTodayBloc bloc) =>
        bloc.add(FetchTvSeriesAiringTodayEvent()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSeriesAiringLoading(),
      TvSeriesAiringHasData(tTvSeriesList),
    ],
    verify: (bloc) {
      verify(mockGetTvSeriesAiringToday.execute());
    },
  );

  blocTest(
    'Should emit [Loading, Error] when data is gotten successfully',
    build: () {
      when(mockGetTvSeriesAiringToday.execute()).thenAnswer(
        (_) async => Left(
          ServerFailure(
            'Server Failure',
          ),
        ),
      );

      return tvSeriesAiringTodayBloc;
    },
    wait: const Duration(milliseconds: 500),
    act: (TvSeriesAiringTodayBloc bloc) =>
        bloc.add(FetchTvSeriesAiringTodayEvent()),
    expect: () => [
      TvSeriesAiringLoading(),
      TvSeriesAiringError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTvSeriesAiringToday.execute());
    },
  );
}
