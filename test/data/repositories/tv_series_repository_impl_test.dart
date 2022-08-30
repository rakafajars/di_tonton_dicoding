import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/tv_series_detail_response.dart';
import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/repositories/tv_series_repository_impl.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRepositoryImpl repository;
  late MockTvSeriesRemoteDataSource mockTvSeriesRemoteDataSource;
  late MockTvSeriesLocalDataSource mockTvSeriesLocalDataSource;

  setUp(() {
    mockTvSeriesRemoteDataSource = MockTvSeriesRemoteDataSource();
    mockTvSeriesLocalDataSource = MockTvSeriesLocalDataSource();
    repository = TvSeriesRepositoryImpl(
      remoteDataSource: mockTvSeriesRemoteDataSource,
      localDataSource: mockTvSeriesLocalDataSource,
    );
  });

  final tTvSeriesModel = TvSeriesModel(
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

  final tTvSeries = TvSeries(
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

  final tTvSeriesModelList = <TvSeriesModel>[tTvSeriesModel];
  final tTvSeriesList = <TvSeries>[tTvSeries];

  group('Tv Airing Today', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getTvSeriesAiringToday()).thenAnswer(
        (_) async => tTvSeriesModelList,
      );
      // act
      final result = await repository.getTvSeriesAiringToday();
      // assert
      verify(mockTvSeriesRemoteDataSource.getTvSeriesAiringToday());
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getTvSeriesAiringToday())
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvSeriesAiringToday();
      // assert
      verify(mockTvSeriesRemoteDataSource.getTvSeriesAiringToday());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getTvSeriesAiringToday()).thenThrow(
        SocketException(
          'Failed to connect to the network',
        ),
      );
      // act
      final result = await repository.getTvSeriesAiringToday();
      // assert
      verify(mockTvSeriesRemoteDataSource.getTvSeriesAiringToday());
      expect(
          result,
          equals(Left(
            ConnectionFailure(
              'Failed to connect to the network',
            ),
          )));
    });
  });

  group('Tv Series Popular', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getTvSeriesPopular()).thenAnswer(
        (_) async => tTvSeriesModelList,
      );
      // act
      final result = await repository.getTvSeriesPopular();
      // assert
      verify(mockTvSeriesRemoteDataSource.getTvSeriesPopular());
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getTvSeriesPopular())
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvSeriesPopular();
      // assert
      verify(mockTvSeriesRemoteDataSource.getTvSeriesPopular());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getTvSeriesPopular()).thenThrow(
        SocketException(
          'Failed to connect to the network',
        ),
      );
      // act
      final result = await repository.getTvSeriesPopular();
      // assert
      verify(mockTvSeriesRemoteDataSource.getTvSeriesPopular());
      expect(
          result,
          equals(Left(
            ConnectionFailure(
              'Failed to connect to the network',
            ),
          )));
    });
  });

  group('Tv Series Top Rated', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getTvSeriesTopRated()).thenAnswer(
        (_) async => tTvSeriesModelList,
      );
      // act
      final result = await repository.getTvSeriesTopRated();
      // assert
      verify(mockTvSeriesRemoteDataSource.getTvSeriesTopRated());
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getTvSeriesTopRated())
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvSeriesTopRated();
      // assert
      verify(mockTvSeriesRemoteDataSource.getTvSeriesTopRated());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getTvSeriesTopRated()).thenThrow(
        SocketException(
          'Failed to connect to the network',
        ),
      );
      // act
      final result = await repository.getTvSeriesTopRated();
      // assert
      verify(mockTvSeriesRemoteDataSource.getTvSeriesTopRated());
      expect(
          result,
          equals(Left(
            ConnectionFailure(
              'Failed to connect to the network',
            ),
          )));
    });
  });

  group('Get Tv Series detail', () {
    final tId = 1;
    final tTvSeriesResponse = TvSeriesDetailResponse(
      id: 1,
      originalName: 'originalName',
      overview: 'overview',
      posterPath: 'posterPath',
      voteAverage: 1,
    );

    test(
        'should return Tv Series data when the call to remote data source is successful',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getTvSeriesDetail(tId))
          .thenAnswer((_) async => tTvSeriesResponse);
      // act
      final result = await repository.getTvSeriesDetail(tId);
      // assert
      verify(mockTvSeriesRemoteDataSource.getTvSeriesDetail(tId));
      expect(result, equals(Right(testTvSeriesDetail)));
    });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getTvSeriesDetail(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvSeriesDetail(tId);
      // assert
      verify(mockTvSeriesRemoteDataSource.getTvSeriesDetail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getTvSeriesDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvSeriesDetail(tId);
      // assert
      verify(mockTvSeriesRemoteDataSource.getTvSeriesDetail(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Get Tv Series Recommendation', () {
    final tId = 1;
    final tTvSeriesList = <TvSeriesModel>[];
    test('should return data (movie list) when the call is successful',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getTvSeriesRecommendation(tId))
          .thenAnswer((_) async => tTvSeriesList);
      // act
      final result = await repository.getTvSeriesRecommendation(tId);
      // assert
      verify(mockTvSeriesRemoteDataSource.getTvSeriesRecommendation(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTvSeriesList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getTvSeriesRecommendation(tId))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvSeriesRecommendation(tId);
      // assertbuild runner
      verify(mockTvSeriesRemoteDataSource.getTvSeriesRecommendation(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getTvSeriesRecommendation(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvSeriesRecommendation(tId);
      // assert
      verify(mockTvSeriesRemoteDataSource.getTvSeriesRecommendation(tId));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Seach Tv Series', () {
    final tQuery = 'spiderman';

    test('should return movie list when call to data source is successful',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.searchTvSeries(tQuery))
          .thenAnswer((_) async => tTvSeriesModelList);
      // act
      final result = await repository.searchTvSeries(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.searchTvSeries(tQuery))
          .thenThrow(ServerException());
      // act
      final result = await repository.searchTvSeries(tQuery);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.searchTvSeries(tQuery))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.searchTvSeries(tQuery);
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save tv series watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockTvSeriesLocalDataSource.insertTvSeriesList(testTvSeriesTable))
          .thenAnswer(
        (realInvocation) async => 'Added to Watchlist',
      );
      // act
      final result = await repository.saveTvSeriesWatchlist(testTvSeriesDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockTvSeriesLocalDataSource.insertTvSeriesList(testTvSeriesTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveTvSeriesWatchlist(testTvSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove tv series watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockTvSeriesLocalDataSource
              .removeTvSeriesWatchlist(testTvSeriesTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result =
          await repository.removeTvSeriesWatchlist(testTvSeriesDetail);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockTvSeriesLocalDataSource
              .removeTvSeriesWatchlist(testTvSeriesTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result =
          await repository.removeTvSeriesWatchlist(testTvSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get tv series watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockTvSeriesLocalDataSource.getTvSeriesById(tId))
          .thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToTvSerieslist(tId);
      // assert
      expect(result, false);
    });
  });
  group('get watchlist tv series', () {
    test('should return list of Movies', () async {
      // arrange
      when(mockTvSeriesLocalDataSource.getTvSeriesWatchlist())
          .thenAnswer((_) async => [testTvSeriesTable]);
      // act
      final result = await repository.getTvSeriesWatchlist();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testTvSeriesListWatchlist]);
    });
  });
}
