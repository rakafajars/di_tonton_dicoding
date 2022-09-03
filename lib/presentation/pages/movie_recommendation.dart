import 'package:ditonton/common/routes.dart';
import 'package:ditonton/presentation/bloc/movie_recommendation/movie_recommendation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/movie_tv_card_recommendation.dart';

class MovieRecommendation extends StatefulWidget {
  final int id;
  const MovieRecommendation({Key? key, required this.id}) : super(key: key);

  @override
  State<MovieRecommendation> createState() => _MovieRecommendationState();
}

class _MovieRecommendationState extends State<MovieRecommendation> {
  @override
  void initState() {
    BlocProvider.of<MovieRecommendationBloc>(context)
      ..add(FetchMovieRecommendationEvent(widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieRecommendationBloc, MovieRecommendationState>(
      builder: (context, state) {
        if (state is MovieRecommendationLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MovieRecommendationHasData) {
          return Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.result.length,
              itemBuilder: (context, int index) {
                final movie = state.result[index];

                return MovieTvCardRecommendation(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      DETAIL_MOVIE_ROUTE,
                      arguments: movie.id,
                    );
                  },
                  posterPath: movie.posterPath ?? "",
                );
              },
            ),
          );
        } else if (state is MovieRecommendationError) {
          return Text(state.message);
        } else {
          return Container();
        }
      },
    );
  }
}
