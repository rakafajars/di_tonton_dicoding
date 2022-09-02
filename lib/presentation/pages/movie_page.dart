import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie_popular/movie_popular_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_top_rated/movie_top_rated_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/routes.dart';
import '../bloc/movie_now_playing/movie_now_playing_bloc.dart';

class MoviePage extends StatefulWidget {
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<MovieNowPlayingBloc>(context)
      ..add(
        FetchNowPlayingMovieEvent(),
      );

    BlocProvider.of<MoviePopularBloc>(context)
      ..add(
        FetchMoviePopularEvent(),
      );

    BlocProvider.of<MovieTopRatedBloc>(context)
      ..add(
        FetchMovieTopRatedEvent(),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Now Playing',
              style: kHeading6,
            ),
            BlocBuilder<MovieNowPlayingBloc, MovieNowPlayingState>(
              builder: (context, state) {
                if (state is MovieNowPlayingLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is MovieNowPlayingHasData) {
                  return MovieList(state.result);
                } else if (state is MovieNowPlayingError) {
                  return Text(state.message);
                } else {
                  return Container();
                }
              },
            ),
            _buildSubHeading(
              title: 'Popular',
              onTap: () => Navigator.pushNamed(context, POPULAR_MOVIE_ROUTE),
            ),
            BlocBuilder<MoviePopularBloc, MoviePopularState>(
              builder: (context, state) {
                if (state is MoviePopularLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is MoviePopularHasData) {
                  return MovieList(state.result);
                } else if (state is MoviePopularError) {
                  return Text(state.message);
                } else {
                  return Container();
                }
              },
            ),
            _buildSubHeading(
              title: 'Top Rated',
              onTap: () => Navigator.pushNamed(context, TOP_RATED_MOVIE_ROUTE),
            ),
            BlocBuilder<MovieTopRatedBloc, MovieTopRatedState>(
              builder: (context, state) {
                if (state is MovieTopRatedLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is MovieTopRatedHasData) {
                  return MovieList(state.result);
                } else if (state is MovieTopRatedError) {
                  return Text(state.message);
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  DETAIL_MOVIE_ROUTE,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
