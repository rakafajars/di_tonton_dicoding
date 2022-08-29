import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv_series/remove_tv_series_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveTvSeriesWatchlist usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = RemoveTvSeriesWatchlist(mockTvSeriesRepository);
  });

  test(
    ('should remove tv series watchlist from repository'),
    () async {
      // arrange
      when(mockTvSeriesRepository.removeTvSeriesWatchlist(testTvSeriesDetail))
          .thenAnswer(
        (_) async => Right(
          'Removed from Tv Series Watchlist',
        ),
      );
      // act
      final result = await usecase.execute(testTvSeriesDetail);
      // assert
      verify(
          mockTvSeriesRepository.removeTvSeriesWatchlist(testTvSeriesDetail));
      expect(result, Right('Removed from Tv Series Watchlist'));
    },
  );
}
