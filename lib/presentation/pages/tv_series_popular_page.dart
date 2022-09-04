import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/tv_series_popular/tv_series_popular_bloc.dart';

class TvSeriesPopularPage extends StatefulWidget {
  const TvSeriesPopularPage({Key? key}) : super(key: key);

  @override
  State<TvSeriesPopularPage> createState() => _TvSeriesPopularPageState();
}

class _TvSeriesPopularPageState extends State<TvSeriesPopularPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TvSeriesPopularBloc>(context)
      ..add(FetchTvSeriesPopularEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tv Series Populer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvSeriesPopularBloc, TvSeriesPopularState>(
          builder: (context, state) {
            if (state is TvSeriesPopularLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvSeriesPopularHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = state.result[index];
                  return TvSeriesCard(tvSeries);
                },
                itemCount: state.result.length,
              );
            } else if (state is TvSeriesPopularError) {
              return Text(state.message);
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
