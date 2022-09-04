import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_top_rated.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/tv_series.dart';

part 'tv_series_top_rated_event.dart';
part 'tv_series_top_rated_state.dart';

class TvSeriesTopRatedBloc
    extends Bloc<TvSeriesTopRatedEvent, TvSeriesTopRatedState> {
  final GetTvSeriesTopRated _getTvSeriesTopRated;

  TvSeriesTopRatedBloc(this._getTvSeriesTopRated)
      : super(TvSeriesTopRatedEmpty()) {
    on<FetchTvSeriesTopRatedEvent>(
      (event, emit) async {
        emit(TvSeriesTopRatedLoading());
        final result = await _getTvSeriesTopRated.execute();
        result.fold(
          (failure) => emit(TvSeriesTopRatedError(failure.message)),
          (data) => emit(TvSeriesTopRatedHasData(data)),
        );
      },
    );
  }
}
