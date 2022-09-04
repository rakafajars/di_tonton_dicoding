import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistMovies,
  SaveWatchlist,
  RemoveWatchlist,
  GetWatchListStatus,
])
void main() {
  late WatchlistMovieBloc watchlistMovieBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    watchlistMovieBloc = WatchlistMovieBloc(
      mockGetWatchListStatus,
      mockSaveWatchlist,
      mockRemoveWatchlist,
      mockGetWatchlistMovies,
    );
  });

  test('initial state should be empty', () {
    expect(watchlistMovieBloc.state, WatchlistMovieEmpty());
  });

  group(
    'Get Watchlist Movie',
    () {
      blocTest(
        'Should emit [Loading, HasData] when data is gotten successfully',
        build: () {
          when(mockGetWatchlistMovies.execute()).thenAnswer(
            (_) async => Right(
              [testWatchlistMovie],
            ),
          );

          return watchlistMovieBloc;
        },
        act: (WatchlistMovieBloc bloc) => bloc.add(FetchWatchlistMovie()),
        wait: const Duration(milliseconds: 500),
        expect: () => [
          WatchlistMovieLoading(),
          WatchlistMovieHasData([testWatchlistMovie]),
        ],
        verify: (bloc) {
          verify(mockGetWatchlistMovies.execute());
        },
      );

      blocTest(
        'Should emit [Loading, Error] when get watchlist is unsuccessful',
        build: () {
          when(mockGetWatchlistMovies.execute()).thenAnswer(
            (_) async => Left(
              DatabaseFailure(
                "Can't get data",
              ),
            ),
          );

          return watchlistMovieBloc;
        },
        wait: const Duration(milliseconds: 500),
        act: (WatchlistMovieBloc bloc) => bloc.add(FetchWatchlistMovie()),
        expect: () => [
          WatchlistMovieLoading(),
          WatchlistMovieError("Can't get data"),
        ],
        verify: (bloc) {
          verify(mockGetWatchlistMovies.execute());
        },
      );
    },
  );

  group('Watchlist', () {
    blocTest(
      'should get the watchlist status',
      build: () {
        when(mockGetWatchListStatus.execute(1)).thenAnswer((_) async => true);

        return watchlistMovieBloc;
      },
      act: (WatchlistMovieBloc bloc) => bloc.add(FetchWatchlistMovieStatus(1)),
      wait: const Duration(milliseconds: 500),
      expect: () => [WatchlistStatusHasData(isAddtoWatchlist: true)],
      verify: (bloc) => verify(mockGetWatchListStatus.execute(1)),
    );

    blocTest(
      'should save the watchlist',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));

        return watchlistMovieBloc;
      },
      act: (WatchlistMovieBloc bloc) =>
          bloc.add(AddWatchlistMovieEvent(testMovieDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [SaveWatchlistMovieHasData('Added to Watchlist')],
      verify: (bloc) => verify(mockSaveWatchlist.execute(testMovieDetail)),
    );

    blocTest(
      'should remove the watchlist',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Removed from Watchlist'));

        return watchlistMovieBloc;
      },
      act: (WatchlistMovieBloc bloc) =>
          bloc.add(RemoveWatchlistMovieEvent(testMovieDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [RemoveWatchlistMovieHasData('Removed from Watchlist')],
      verify: (bloc) => verify(mockRemoveWatchlist.execute(testMovieDetail)),
    );

    blocTest(
      'should update watchlist message when add watchlist failed',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer(
          (_) async => Left(
            DatabaseFailure(
              'Failed',
            ),
          ),
        );

        return watchlistMovieBloc;
      },
      act: (WatchlistMovieBloc bloc) =>
          bloc.add(AddWatchlistMovieEvent(testMovieDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [SaveWatchlistMovieError('Failed')],
      verify: (bloc) => verify(mockSaveWatchlist.execute(testMovieDetail)),
    );

    blocTest(
      'should update watchlist message when remove watchlist failed',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer(
          (_) async => Left(
            DatabaseFailure(
              'Failed',
            ),
          ),
        );

        return watchlistMovieBloc;
      },
      act: (WatchlistMovieBloc bloc) =>
          bloc.add(RemoveWatchlistMovieEvent(testMovieDetail)),
      wait: const Duration(milliseconds: 500),
      expect: () => [RemoveWatchlistMovieError('Failed')],
      verify: (bloc) => verify(mockRemoveWatchlist.execute(testMovieDetail)),
    );
  });
}
