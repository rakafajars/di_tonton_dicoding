import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_watchlist.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_watchlist_status.dart';
import 'package:ditonton/domain/usecases/tv_series/remove_tv_series_watchlist.dart';
import 'package:ditonton/domain/usecases/tv_series/save_tv_series_watchlist.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_series_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesWatchlist,
  GetTvSeriesWatchlistStatus,
  SaveTvSeriesWatchlist,
  RemoveTvSeriesWatchlist,
])
void main() {
  late WatchlistTvSeriesBloc watchlistTvSeriesBloc;
  late MockGetTvSeriesWatchlist mockGetTvSeriesWatchlist;
  late MockGetTvSeriesWatchlistStatus mockGetTvSeriesWatchlistStatus;
  late MockSaveTvSeriesWatchlist mockSaveTvSeriesWatchlist;
  late MockRemoveTvSeriesWatchlist mockRemoveTvSeriesWatchlist;

  setUp(() {
    mockGetTvSeriesWatchlist = MockGetTvSeriesWatchlist();
    mockGetTvSeriesWatchlistStatus = MockGetTvSeriesWatchlistStatus();
    mockSaveTvSeriesWatchlist = MockSaveTvSeriesWatchlist();
    mockRemoveTvSeriesWatchlist = MockRemoveTvSeriesWatchlist();
    watchlistTvSeriesBloc = WatchlistTvSeriesBloc(
      mockGetTvSeriesWatchlist,
      mockGetTvSeriesWatchlistStatus,
      mockSaveTvSeriesWatchlist,
      mockRemoveTvSeriesWatchlist,
    );
  });

  test('initial state should be empty', () {
    expect(watchlistTvSeriesBloc.state, WatchlistTvSeriesEmpty());
  });

  group(
    'Get Watchlist Tv Series',
    () {
      blocTest(
        'Should emit [Loading, HasData] when data is gotten successfully',
        build: () {
          when(mockGetTvSeriesWatchlist.execute()).thenAnswer(
            (_) async => Right(
              [testTvSeriesListWatchlist],
            ),
          );

          return watchlistTvSeriesBloc;
        },
        act: (WatchlistTvSeriesBloc bloc) => bloc.add(FetchWatchlistTvSeries()),
        wait: const Duration(milliseconds: 500),
        expect: () => [
          WatchlistTvSeriesLoading(),
          WatchlistTvSeriesHasData([testTvSeriesListWatchlist]),
        ],
        verify: (bloc) {
          verify(mockGetTvSeriesWatchlist.execute());
        },
      );

      blocTest(
        'Should emit [Loading, Error] when get watchlist is unsuccessful',
        build: () {
          when(mockGetTvSeriesWatchlist.execute()).thenAnswer(
            (_) async => Left(
              DatabaseFailure(
                "Can't get data",
              ),
            ),
          );

          return watchlistTvSeriesBloc;
        },
        wait: const Duration(milliseconds: 500),
        act: (WatchlistTvSeriesBloc bloc) => bloc.add(FetchWatchlistTvSeries()),
        expect: () => [
          WatchlistTvSeriesLoading(),
          WatchlistTvSeriesError("Can't get data"),
        ],
        verify: (bloc) {
          verify(mockGetTvSeriesWatchlist.execute());
        },
      );
    },
  );

  group('Watchlist', () {
    blocTest(
      'should get the watchlist status',
      build: () {
        when(mockGetTvSeriesWatchlistStatus.execute(1))
            .thenAnswer((_) async => true);

        return watchlistTvSeriesBloc;
      },
      act: (WatchlistTvSeriesBloc bloc) =>
          bloc.add(FetchWatchlistTvSeriesStatus(1)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        WatchlistStatusHasData(
          isAddtoWatchlist: true,
        ),
      ],
      verify: (bloc) => verify(
        mockGetTvSeriesWatchlistStatus.execute(1),
      ),
    );

    blocTest(
      'should save the watchlist',
      build: () {
        when(mockSaveTvSeriesWatchlist.execute(testTvSeriesDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));

        return watchlistTvSeriesBloc;
      },
      act: (WatchlistTvSeriesBloc bloc) =>
          bloc.add(AddWatchlistTvSeriesEvent(testTvSeriesDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        SaveWatchlistTvSeriesHasData(
          'Added to Watchlist',
        ),
      ],
      verify: (bloc) =>
          verify(mockSaveTvSeriesWatchlist.execute(testTvSeriesDetail)),
    );

    blocTest(
      'should remove the watchlist',
      build: () {
        when(mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetail))
            .thenAnswer((_) async => Right('Removed from Watchlist'));

        return watchlistTvSeriesBloc;
      },
      act: (WatchlistTvSeriesBloc bloc) =>
          bloc.add(RemoveWatchlistTvSeriesEvent(testTvSeriesDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [RemoveWatchlistTvSeriesHasData('Removed from Watchlist')],
      verify: (bloc) =>
          verify(mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetail)),
    );

    blocTest(
      'should update watchlist message when add watchlist failed',
      build: () {
        when(mockSaveTvSeriesWatchlist.execute(testTvSeriesDetail)).thenAnswer(
          (_) async => Left(
            DatabaseFailure(
              'Failed',
            ),
          ),
        );

        return watchlistTvSeriesBloc;
      },
      act: (WatchlistTvSeriesBloc bloc) =>
          bloc.add(AddWatchlistTvSeriesEvent(testTvSeriesDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [SaveWatchlistTvSeriesError('Failed')],
      verify: (bloc) =>
          verify(mockSaveTvSeriesWatchlist.execute(testTvSeriesDetail)),
    );

    blocTest(
      'should update watchlist message when remove watchlist failed',
      build: () {
        when(mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetail))
            .thenAnswer(
          (_) async => Left(
            DatabaseFailure(
              'Failed',
            ),
          ),
        );

        return watchlistTvSeriesBloc;
      },
      act: (WatchlistTvSeriesBloc bloc) => bloc.add(
        RemoveWatchlistTvSeriesEvent(
          testTvSeriesDetail,
        ),
      ),
      wait: const Duration(milliseconds: 500),
      expect: () => [RemoveWatchlistTvSeriesError('Failed')],
      verify: (bloc) =>
          verify(mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetail)),
    );
  });
}
