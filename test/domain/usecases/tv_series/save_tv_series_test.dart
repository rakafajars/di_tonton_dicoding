import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv_series/save_tv_series_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SaveTvSeriesWatchlist usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = SaveTvSeriesWatchlist(mockTvSeriesRepository);
  });

  test(
    'should save tv series to the repository',
    () async {
      // arrange
      when(mockTvSeriesRepository.saveTvSeriesWatchlist(testTvSeriesDetail))
          .thenAnswer(
        (_) async => Right(
          'Added to Tv Series Watchlist',
        ),
      );
      // act
      final result = await usecase.execute(testTvSeriesDetail);
      // assert
      verify(mockTvSeriesRepository.saveTvSeriesWatchlist(testTvSeriesDetail));
      expect(result, Right('Added to Tv Series Watchlist'));
    },
  );
}
