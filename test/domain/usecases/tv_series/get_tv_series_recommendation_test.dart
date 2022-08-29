import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_recommendation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesRecommendation usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesRecommendation(mockTvSeriesRepository);
  });

  final tId = 1;
  final tTvSeries = <TvSeries>[];

  test(
    'should get list of movie recommendations from the repository',
    () async {
      // arrange
      when(mockTvSeriesRepository.getTvSeriesRecommendation(tId)).thenAnswer(
        (_) async => Right(tTvSeries),
      );
      // act
      final result = await usecase.execute(tId);
      // assert
      expect(result, Right(tTvSeries));
    },
  );
}
