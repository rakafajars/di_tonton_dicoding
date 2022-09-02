import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/search_tv_series/search_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../provider/tv_series_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTvSeries])
void main() {
  late SearchTvSeriesBloc searchTvSeriesBloc;
  late MockSearchTvSeries mockSearchTvSeries;

  final tTvSeriesModel = TvSeries(
    backdropPath: "/ypLoTftyF5EpGBxJas4PThIdiU4.jpg",
    firstAirDate: "2010-06-08",
    genreIds: [18, 9648],
    id: 31917,
    name: "Pretty Little Liars",
    originCountry: ["US"],
    originalLanguage: "en",
    originalName: "Pretty Little Liars",
    overview:
        "Based on the Pretty Little Liars series of young adult novels by Sara Shepard, the series follows the lives of four girls — Spencer, Hanna, Aria, and Emily — whose clique falls apart after the disappearance of their queen bee, Alison. One year later, they begin receiving messages from someone using the name \"A\" who threatens to expose their secrets — including long-hidden ones they thought only Alison knew.",
    popularity: 239.476,
    posterPath: "/aUPbHiLS3hCHKjtLsncFa9g0viV.jpg",
    voteAverage: 8.033,
    voteCount: 2190,
  );

  final tTvSeriesList = <TvSeries>[tTvSeriesModel];
  final tQuery = 'Pretty Little Liars';

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();
    searchTvSeriesBloc = SearchTvSeriesBloc(mockSearchTvSeries);
  });

  test('initial state should be empty', () {
    expect(searchTvSeriesBloc.state, SearchTvSeriesEmpty());
  });

  blocTest(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchTvSeries.execute(tQuery)).thenAnswer(
        (_) async => Right(
          tTvSeriesList,
        ),
      );

      return searchTvSeriesBloc;
    },
    act: (SearchTvSeriesBloc bloc) => bloc.add(SearchTvQueryEvent(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () =>
        [SearchTvSeriesLoading(), SearchTvSeriesHasData(tTvSeriesList)],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );

  blocTest(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTvSeries.execute(tQuery)).thenAnswer(
        (_) async => Left(
          ServerFailure(
            'Server Failure',
          ),
        ),
      );

      return searchTvSeriesBloc;
    },
    act: (SearchTvSeriesBloc bloc) => bloc.add(SearchTvQueryEvent(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchTvSeriesLoading(),
      SearchTvSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    },
  );
}
