import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'movie_recommendation.dart';

class MovieDetailPage extends StatefulWidget {
  final int id;
  MovieDetailPage({required this.id});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MovieDetailBloc>(context)
      ..add(
        FetchMovieDetailEvent(
          widget.id,
        ),
      );

    BlocProvider.of<WatchlistMovieBloc>(context)
      ..add(
        FetchWatchlistMovieStatus(
          widget.id,
        ),
      );
    // Future.microtask(() {
    //   Provider.of<MovieDetailNotifier>(context, listen: false)
    //       .loadWatchlistStatus(widget.id);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MovieDetailHasData) {
            final movie = state.result;
            return BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
              builder: (context, state) {
                if (state is WatchlistStatusHasData) {
                  return SafeArea(
                    child: DetailContent(
                      movie,
                      state.isAddtoWatchlist,
                      widget.id,
                    ),
                  );
                } else {
                  return Container();
                }
              },
            );
          } else if (state is MovieDetailError) {
            return Text(state.message);
          } else {
            return Container();
          }
        },
      ),
      // body: Consumer<MovieDetailNotifier>(
      //   builder: (context, provider, child) {
      //     if (provider.movieState == RequestState.Loading) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     } else if (provider.movieState == RequestState.Loaded) {
      //       final movie = provider.movie;
      //       return SafeArea(
      //         child: DetailContent(
      //           movie,
      //           provider.movieRecommendations,
      //           provider.isAddedToWatchlist,
      //         ),
      //       );
      //     } else {
      //       return Text(provider.message);
      //     }
      //   },
      // ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final bool isAddedWatchlist;
  final int id;

  DetailContent(
    this.movie,
    this.isAddedWatchlist,
    this.id,
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                // if (!isAddedWatchlist) {
                                //   await Provider.of<MovieDetailNotifier>(
                                //           context,
                                //           listen: false)
                                //       .addWatchlist(movie);
                                // } else {
                                //   await Provider.of<MovieDetailNotifier>(
                                //           context,
                                //           listen: false)
                                //       .removeFromWatchlist(movie);
                                // }
                                //
                                // final message =
                                //     Provider.of<MovieDetailNotifier>(context,
                                //             listen: false)
                                //         .watchlistMessage;
                                //
                                // if (message ==
                                //         MovieDetailNotifier
                                //             .watchlistAddSuccessMessage ||
                                //     message ==
                                //         MovieDetailNotifier
                                //             .watchlistRemoveSuccessMessage) {
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //       SnackBar(content: Text(message)));
                                // } else {
                                //   showDialog(
                                //       context: context,
                                //       builder: (context) {
                                //         return AlertDialog(
                                //           content: Text(message),
                                //         );
                                //       });
                                // }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(movie.genres),
                            ),
                            Text(
                              _showDuration(movie.runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              movie.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            MovieRecommendation(
                              id: id,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
