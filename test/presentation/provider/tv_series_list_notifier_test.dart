import 'package:core/core.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_tv_series_airing_today.dart';
import 'package:core/domain/usecases/tv_series/get_tv_series_popular.dart';
import 'package:core/domain/usecases/tv_series/get_tv_series_top_rated.dart';
import 'package:core/presentation/provider/tv_series_list_notifier.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_list_notifier_test.mocks.dart';

@GenerateMocks(
    [GetTvSeriesAiringToday, GetTvSeriesPopular, GetTvSeriesTopRated])
void main() {
  late TvSeriesListNotifier provider;
  late MockGetTvSeriesAiringToday mockGetTvSeriesAiringToday;
  late MockGetTvSeriesPopular mockGetTvSeriesPopular;
  late MockGetTvSeriesTopRated mockGetTvSeriesTopRated;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvSeriesAiringToday = MockGetTvSeriesAiringToday();
    mockGetTvSeriesPopular = MockGetTvSeriesPopular();
    mockGetTvSeriesTopRated = MockGetTvSeriesTopRated();
    provider = TvSeriesListNotifier(
        getTvSeriesAiringToday: mockGetTvSeriesAiringToday,
        getTvSeriesPopular: mockGetTvSeriesPopular,
        getTvSeriesTopRated: mockGetTvSeriesTopRated)
      ..addListener(() {
        listenerCallCount += 1;
      });
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

  group('tv airing today', () {
    test('initialState should be Empty', () {
      expect(provider.tvSeriesAiringTodayState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      when(mockGetTvSeriesAiringToday.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      // act
      provider.fetchTvSeriesAiringToday();
      // assert
      verify(mockGetTvSeriesAiringToday.execute());
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetTvSeriesAiringToday.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      // act
      provider.fetchTvSeriesAiringToday();
      // assert
      expect(provider.tvSeriesAiringTodayState, RequestState.Loading);
    });

    test('should change movies when data is gotten successfully', () async {
      // arrange
      when(mockGetTvSeriesAiringToday.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      // act
      await provider.fetchTvSeriesAiringToday();
      // assert
      expect(provider.tvSeriesAiringTodayState, RequestState.Loaded);
      expect(provider.tvSeriesAiringToday, tTvSeriesList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTvSeriesAiringToday.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTvSeriesAiringToday();
      // assert
      expect(provider.tvSeriesAiringTodayState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('tv top rated', () {
    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetTvSeriesTopRated.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      // act
      provider.fetchTvTopRated();
      // assert
      expect(provider.tvSerisTopRatedState, RequestState.Loading);
    });

    test('should change movies when data is gotten successfully', () async {
      // arrange
      when(mockGetTvSeriesTopRated.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      // act
      await provider.fetchTvTopRated();
      // assert
      expect(provider.tvSerisTopRatedState, RequestState.Loaded);
      expect(provider.tvSeriesTopRated, tTvSeriesList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTvSeriesTopRated.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTvTopRated();
      // assert
      expect(provider.tvSerisTopRatedState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top popular', () {
    test('should change state to Loading when usecase is called', () {
      // arrange
      when(mockGetTvSeriesPopular.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      // act
      provider.fetchTvSeriesPopular();
      // assert
      expect(provider.tvSeriesPopularState, RequestState.Loading);
    });

    test('should change movies when data is gotten successfully', () async {
      // arrange
      when(mockGetTvSeriesPopular.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));
      // act
      await provider.fetchTvSeriesPopular();
      // assert
      expect(provider.tvSeriesPopularState, RequestState.Loaded);
      expect(provider.tvSeriesPupular, tTvSeriesList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTvSeriesPopular.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTvSeriesPopular();
      // assert
      expect(provider.tvSeriesPopularState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
