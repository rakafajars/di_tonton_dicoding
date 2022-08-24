import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:flutter/foundation.dart';

import '../../common/state_enum.dart';

class TvSeriesDetailNotifier extends ChangeNotifier {
  final GetTvSeriesDetail getTvSeriesDetail;

  late TvSeriesDetail _tvSeriesDetail;
  TvSeriesDetail get tvSeriesDetail => _tvSeriesDetail;

  RequestState _tvSeriesDetailState = RequestState.Empty;
  RequestState get tvSeriesDetailState => _tvSeriesDetailState;

  String _message = '';
  String get message => _message;

  TvSeriesDetailNotifier({
    required this.getTvSeriesDetail,
  });

  Future<void> fetchTvSeriesDetail(int id) async {
    _tvSeriesDetailState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getTvSeriesDetail.execute(id);

    detailResult.fold(
      (failure) {
        _tvSeriesDetailState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeries) {
        _tvSeriesDetailState = RequestState.Loaded;
        _tvSeriesDetail = tvSeries;
        notifyListeners();
      },
    );
  }
}
