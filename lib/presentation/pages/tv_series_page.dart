import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series_airing_today/tv_series_airing_today_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_popular/tv_series_popular_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_top_rated/tv_series_top_rated_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/constants.dart';
import '../../common/routes.dart';

class TvSeriesPage extends StatefulWidget {
  const TvSeriesPage({Key? key}) : super(key: key);

  @override
  State<TvSeriesPage> createState() => _TvSeriesPageState();
}

class _TvSeriesPageState extends State<TvSeriesPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TvSeriesAiringTodayBloc>(context)
      ..add(FetchTvSeriesAiringTodayEvent());
    BlocProvider.of<TvSeriesPopularBloc>(context)
      ..add(FetchTvSeriesPopularEvent());

    BlocProvider.of<TvSeriesTopRatedBloc>(context)
      ..add(FetchTvSeriesTopRatedEvent());
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
              'Airing Today',
              style: kHeading6,
            ),
            BlocBuilder<TvSeriesAiringTodayBloc, TvSeriesAiringTodayState>(
              builder: (context, state) {
                if (state is TvSeriesAiringLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TvSeriesAiringHasData) {
                  return TvSeriesList(state.result);
                } else if (state is TvSeriesAiringError) {
                  return Text(state.message);
                } else {
                  return Container();
                }
              },
            ),
            _buildSubHeading(
              title: 'Tv Series Popular',
              onTap: () => {
                Navigator.pushNamed(context, TV_SERIES_POPULAR_ROUTE),
              },
            ),
            BlocBuilder<TvSeriesPopularBloc, TvSeriesPopularState>(
              builder: (context, state) {
                if (state is TvSeriesPopularLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TvSeriesPopularHasData) {
                  return TvSeriesList(state.result);
                } else if (state is TvSeriesPopularError) {
                  return Text(state.message);
                } else {
                  return Container();
                }
              },
            ),
            _buildSubHeading(
              title: 'Tv Series Top Rated',
              onTap: () => {
                Navigator.pushNamed(context, TV_TOP_RATED_TV_SERIES_ROUTE),
              },
            ),
            BlocBuilder<TvSeriesTopRatedBloc, TvSeriesTopRatedState>(
              builder: (context, state) {
                if (state is TvSeriesTopRatedLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TvSeriesTopRatedHasData) {
                  return TvSeriesList(state.result);
                } else if (state is TvSeriesTopRatedError) {
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

class TvSeriesList extends StatelessWidget {
  final List<TvSeries> tvSeries;

  TvSeriesList(this.tvSeries);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tvSeriesList = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TV_SERIES_DETAIL_ROUTE,
                  arguments: tvSeriesList.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tvSeriesList.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
