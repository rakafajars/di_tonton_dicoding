import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_detail.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../provider/tv_series_detail_notifier_test.mocks.dart';

@GenerateMocks([GetTvSeriesDetail])
void main() {
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late TvSeriesDetailBloc tvSeriesDetailBloc;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    tvSeriesDetailBloc = TvSeriesDetailBloc(mockGetTvSeriesDetail);
  });

  final tId = 1;

  test('initial state should be empty', () {
    expect(tvSeriesDetailBloc.state, TvSeriesDetailEmpty());
  });

  blocTest(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvSeriesDetail.execute(tId)).thenAnswer(
        (_) async => Right(
          testTvSeriesDetail,
        ),
      );

      return tvSeriesDetailBloc;
    },
    act: (TvSeriesDetailBloc bloc) => bloc.add(FetchTvSeriesDetailEvent(tId)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSeriesDetailLoading(),
      TvSeriesDetailHasData(testTvSeriesDetail),
    ],
    verify: (bloc) {
      verify(mockGetTvSeriesDetail.execute(tId));
    },
  );

  blocTest(
    'Should emit [Loading, Error] when data is gotten successfully',
    build: () {
      when(mockGetTvSeriesDetail.execute(tId)).thenAnswer(
        (_) async => Left(
          ServerFailure(
            'Server Failure',
          ),
        ),
      );

      return tvSeriesDetailBloc;
    },
    act: (TvSeriesDetailBloc bloc) => bloc.add(FetchTvSeriesDetailEvent(tId)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSeriesDetailLoading(),
      TvSeriesDetailError(
        'Server Failure',
      ),
    ],
    verify: (bloc) {
      verify(mockGetTvSeriesDetail.execute(tId));
    },
  );
}
