import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_popular.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/tv_series.dart';

part 'tv_series_popular_event.dart';
part 'tv_series_popular_state.dart';

class TvSeriesPopularBloc
    extends Bloc<TvSeriesPopularEvent, TvSeriesPopularState> {
  final GetTvSeriesPopular _getTvSeriesPopular;

  TvSeriesPopularBloc(this._getTvSeriesPopular)
      : super(TvSeriesPopularEmpty()) {
    on<FetchTvSeriesPopularEvent>((event, emit) async {
      emit(TvSeriesPopularLoading());
      final result = await _getTvSeriesPopular.execute();
      result.fold(
        (failure) => emit(TvSeriesPopularError(failure.message)),
        (data) => emit(TvSeriesPopularHasData(data)),
      );
    });
  }
}
