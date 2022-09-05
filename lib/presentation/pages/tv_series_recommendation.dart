import 'package:ditonton/common/routes.dart';
import 'package:ditonton/presentation/bloc/tv_series_recommendation/tv_series_recommendation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/movie_tv_card_recommendation.dart';

class TvSeriesRecommendation extends StatefulWidget {
  final int id;

  const TvSeriesRecommendation({Key? key, required this.id}) : super(key: key);

  @override
  State<TvSeriesRecommendation> createState() => _TvSeriesRecommendationState();
}

class _TvSeriesRecommendationState extends State<TvSeriesRecommendation> {
  @override
  void initState() {
    BlocProvider.of<TvSeriesRecommendationBloc>(context)
      ..add(FetchTvSeriesRecommendationEvent(widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TvSeriesRecommendationBloc, TvSeriesRecommendationState>(
      builder: (context, state) {
        if (state is TvSeriesRecommendationLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TvSeriesRecommendationHasData) {
          return Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.result.length,
              itemBuilder: (context, int index) {
                final tvSeries = state.result[index];

                return MovieTvCardRecommendation(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      TV_SERIES_DETAIL_ROUTE,
                      arguments: tvSeries.id,
                    );
                  },
                  posterPath: tvSeries.posterPath ?? "",
                );
              },
            ),
          );
        } else if (state is TvSeriesRecommendationError) {
          return Text(state.message);
        } else {
          return Container();
        }
      },
    );
  }
}
