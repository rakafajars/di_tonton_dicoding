import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_tv_series_top_rated.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesTopRated usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesTopRated(mockTvSeriesRepository);
  });

  final tTvSeries = <TvSeries>[];

  test(
    'should get list of tv series top rated from the repository',
    () async {
      // arrange
      when(mockTvSeriesRepository.getTvSeriesTopRated()).thenAnswer(
        (_) async => Right(
          tTvSeries,
        ),
      );
      // act
      final result = await usecase.execute();
      // assert
      expect(result, Right(tTvSeries));
    },
  );
}
