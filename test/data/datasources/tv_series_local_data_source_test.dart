import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_series_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource =
        TvSeriesLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save tv series watchlist', () {
    test(
      'should return success message when inster to database is success',
      () async {
        // arrage
        when(mockDatabaseHelper.insertTvSeriesList(testTvSeriesTable))
            .thenAnswer((_) async => 1);
        // act
        final result = await dataSource.insertTvSeriesList(testTvSeriesTable);
        // assert
        expect(result, 'Added to Watchlist');
      },
    );

    test('should throw DatabaseException when insert to database is failed',
        () async {
      // arrange
      when(mockDatabaseHelper.insertTvSeriesList(testTvSeriesTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.insertTvSeriesList(testTvSeriesTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove tv series watchlist', () {
    test('should return success message when remove from database is success',
        () async {
      // arrange
      when(mockDatabaseHelper.removeTvSeriesWatchlist(testTvSeriesTable))
          .thenAnswer(
        (_) async => 1,
      );
      // act
      final result =
          await dataSource.removeTvSeriesWatchlist(testTvSeriesTable);
      // assert
      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove from database is failed',
        () async {
      // arrange
      when(mockDatabaseHelper.removeTvSeriesWatchlist(testTvSeriesTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.removeTvSeriesWatchlist(testTvSeriesTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get Tv Series Detail By Id', () {
    final tId = 1;

    test('should return Tv Series Detail Table when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getTvSeriesById(tId)).thenAnswer(
        (_) async => testTvSeriesMap,
      );
      // act
      final result = await dataSource.getTvSeriesById(tId);
      // assert
      expect(result, testTvSeriesTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getTvSeriesById(tId))
          .thenAnswer((_) async => null);
      // act
      final result = await dataSource.getTvSeriesById(tId);
      // assert
      expect(result, null);
    });
  });

  group('get tv seris watchlist', () {
    test('should return list of TvSerisTable ', () async {
      // arrange
      when(mockDatabaseHelper.getTvSeriesWatchlist())
          .thenAnswer((_) async => [testTvSeriesMap]);
      // act
      final result = await dataSource.getTvSeriesWatchlist();
      // assert
      expect(result, [testTvSeriesTable]);
    });
  });
}
