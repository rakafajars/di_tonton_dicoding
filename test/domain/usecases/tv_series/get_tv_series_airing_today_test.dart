import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_airing_today.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesAiringToday usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesAiringToday(mockTvSeriesRepository);
  });

  final tTvSeries = <TvSeries>[];

  test(
    ('should get list of tv series airing today from the repository'),
    () async {
      // arrange
      when(mockTvSeriesRepository.getTvSeriesAiringToday()).thenAnswer(
        (_) async => Right(
          tTvSeries,
        ),
      );
      // act
      final result = await usecase.execute();
      // assert
      expect(
        result,
        Right(
          tTvSeries,
        ),
      );
    },
  );
}
