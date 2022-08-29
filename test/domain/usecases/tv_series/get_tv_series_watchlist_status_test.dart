import 'package:ditonton/domain/usecases/tv_series/get_tv_series_watchlist_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesWatchlistStatus usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesWatchlistStatus(mockTvSeriesRepository);
  });

  test(
    'should get watchlist status from repository',
    () async {
      // arrange
      when(mockTvSeriesRepository.isAddedToTvSerieslist(1))
          .thenAnswer((_) async => true);

      // act
      final result = await usecase.execute(1);
      // assert
      expect(result, true);
    },
  );
}
