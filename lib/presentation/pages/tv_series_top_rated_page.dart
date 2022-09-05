import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/tv_series_top_rated/tv_series_top_rated_bloc.dart';

class TvSeriesTopRatedPage extends StatefulWidget {
  const TvSeriesTopRatedPage({Key? key}) : super(key: key);

  @override
  State<TvSeriesTopRatedPage> createState() => _TvSeriesTopRatedPageState();
}

class _TvSeriesTopRatedPageState extends State<TvSeriesTopRatedPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TvSeriesTopRatedBloc>(context)
      ..add(FetchTvSeriesTopRatedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tv Series Populer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvSeriesTopRatedBloc, TvSeriesTopRatedState>(
          builder: (context, state) {
            if (state is TvSeriesTopRatedLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvSeriesTopRatedHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = state.result[index];
                  return TvSeriesCard(tvSeries);
                },
                itemCount: state.result.length,
              );
            } else if (state is TvSeriesTopRatedError) {
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
