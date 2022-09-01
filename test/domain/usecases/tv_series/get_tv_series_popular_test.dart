import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_tv_series_popular.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesPopular usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTvSeriesPopular(mockTvSeriesRepository);
  });

  final tTvSeries = <TvSeries>[];

  test(
    ('should get list of tv series popular from the repository'),
    () async {
      // arrange
      when(mockTvSeriesRepository.getTvSeriesPopular())
          .thenAnswer((_) async => Right(tTvSeries));
      // acc
      final result = await usecase.execute();
      // assert
      expect(result, Right(tTvSeries));
    },
  );
}
