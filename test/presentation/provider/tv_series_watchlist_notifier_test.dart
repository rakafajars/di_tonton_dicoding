import 'package:core/core.dart';
import 'package:core/domain/usecases/tv_series/get_tv_series_watchlist.dart';
import 'package:core/presentation/provider/tv_series_watchlist_notifier.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_watchlist_notifier_test.mocks.dart';

@GenerateMocks([GetTvSeriesWatchlist])
void main() {
  late TvSeriesWatchlistNotifier provider;
  late MockGetTvSeriesWatchlist mockGetTvSeriesWatchlist;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvSeriesWatchlist = MockGetTvSeriesWatchlist();
    provider = TvSeriesWatchlistNotifier(
      getTvSeriesWatchlist: mockGetTvSeriesWatchlist,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  test('should change tv series data when data is gotten successfully',
      () async {
    // arrange
    when(mockGetTvSeriesWatchlist.execute())
        .thenAnswer((_) async => Right([testTvSeriesListWatchlist]));
    // act
    await provider.fetchTvSeriesWatchlistMovies();
    // assert
    expect(provider.tvSeriesState, RequestState.Loaded);
    expect(provider.tvSeriesWatchlist, [testTvSeriesListWatchlist]);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetTvSeriesWatchlist.execute()).thenAnswer(
      (_) async => Left(
        DatabaseFailure(
          "Can't get data",
        ),
      ),
    );
    // act
    await provider.fetchTvSeriesWatchlistMovies();
    // assert
    expect(provider.tvSeriesState, RequestState.Error);
    expect(provider.message, "Can't get data");
    expect(listenerCallCount, 2);
  });
}
