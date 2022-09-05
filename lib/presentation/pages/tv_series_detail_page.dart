import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/tv_series_recommendation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../common/constants.dart';

class TvSeriesDetailPage extends StatefulWidget {
  final int id;
  TvSeriesDetailPage({required this.id});

  @override
  State<TvSeriesDetailPage> createState() => _TvSeriesDetailPageState();
}

class _TvSeriesDetailPageState extends State<TvSeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TvSeriesDetailBloc>(context)
      ..add(
        FetchTvSeriesDetailEvent(
          widget.id,
        ),
      );

    BlocProvider.of<WatchlistTvSeriesBloc>(context)
      ..add(
        FetchWatchlistTvSeriesStatus(
          widget.id,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvSeriesDetailBloc, TvSeriesDetailState>(
        builder: (context, state) {
          if (state is TvSeriesDetailLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvSeriesDetailHasData) {
            final tvSeries = state.result;
            return BlocBuilder<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
              builder: (context, state) {
                if (state is WatchlistStatusHasData) {
                  return SafeArea(
                    child: DetailContentTv(
                      tvSeriesDetail: tvSeries,
                      isAddedTvSeriesWatchlist: state.isAddtoWatchlist,
                      id: widget.id,
                    ),
                  );
                } else {
                  return Container();
                }
              },
            );
          } else if (state is TvSeriesDetailError) {
            return Text(state.message);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class DetailContentTv extends StatelessWidget {
  final TvSeriesDetail tvSeriesDetail;
  final bool isAddedTvSeriesWatchlist;
  final int id;

  const DetailContentTv({
    Key? key,
    required this.tvSeriesDetail,
    required this.isAddedTvSeriesWatchlist,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      listener: (context, state) {
        if (state is SaveWatchlistTvSeriesHasData) {
          context.read<WatchlistTvSeriesBloc>()
            ..add(FetchWatchlistTvSeriesStatus(id));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
              ),
            ),
          );
        }
        if (state is SaveWatchlistTvSeriesError) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(state.message),
              );
            },
          );
        }
        if (state is RemoveWatchlistTvSeriesHasData) {
          context.read<WatchlistTvSeriesBloc>()
            ..add(FetchWatchlistTvSeriesStatus(id));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
        if (state is RemoveWatchlistTvSeriesError) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(state.message),
              );
            },
          );
        }
      },
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl:
                'https://image.tmdb.org/t/p/w500${tvSeriesDetail.posterPath}',
            width: screenWidth,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Container(
            margin: const EdgeInsets.only(top: 48 + 8),
            child: DraggableScrollableSheet(
              builder: ((context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: kRichBlack,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
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
                                tvSeriesDetail.originalName ?? "-",
                                style: kHeading5,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (!isAddedTvSeriesWatchlist) {
                                    context.read<WatchlistTvSeriesBloc>()
                                      ..add(
                                        AddWatchlistTvSeriesEvent(
                                          tvSeriesDetail,
                                        ),
                                      );
                                  } else {
                                    context.read<WatchlistTvSeriesBloc>()
                                      ..add(
                                        RemoveWatchlistTvSeriesEvent(
                                          tvSeriesDetail,
                                        ),
                                      );
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    isAddedTvSeriesWatchlist
                                        ? Icon(Icons.check)
                                        : Icon(Icons.add),
                                    Text('Watchlist'),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RatingBarIndicator(
                                    rating: tvSeriesDetail.voteAverage ?? 0 / 2,
                                    itemCount: 5,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: kMikadoYellow,
                                    ),
                                    itemSize: 24,
                                  ),
                                  Text('${tvSeriesDetail.voteAverage}')
                                ],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Overview',
                                style: kHeading6,
                              ),
                              Text(
                                tvSeriesDetail.overview ?? "-",
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Recommendations',
                                style: kHeading6,
                              ),
                              TvSeriesRecommendation(id: id),
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
              }),
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
      ),
    );
  }
}
