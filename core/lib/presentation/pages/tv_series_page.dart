import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/presentation/pages/tv_series_detail_page.dart';
import 'package:core/presentation/pages/tv_series_popular_page.dart';
import 'package:core/presentation/pages/tv_series_top_rated_page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core.dart';
import '../../domain/entities/tv_series.dart';
import '../../utils/routes.dart';
import '../provider/tv_series_list_notifier.dart';

class TvSeriesPage extends StatefulWidget {
  const TvSeriesPage({Key? key}) : super(key: key);

  @override
  State<TvSeriesPage> createState() => _TvSeriesPageState();
}

class _TvSeriesPageState extends State<TvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<TvSeriesListNotifier>(context, listen: false)
        ..fetchTvSeriesAiringToday()
        ..fetchTvSeriesPopular()
        ..fetchTvTopRated(),
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
              'Airing Today',
              style: kHeading6,
            ),
            Consumer<TvSeriesListNotifier>(
              builder: (context, data, child) {
                final state = data.tvSeriesAiringTodayState;

                if (state == RequestState.Loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.Loaded) {
                  return TvSeriesList(data.tvSeriesAiringToday);
                } else {
                  return const Text('Failed');
                }
              },
            ),
            _buildSubHeading(
              title: 'Tv Series Popular',
              onTap: () => {
                Navigator.pushNamed(context, TV_SERIS_POPULAR_ROUTE),
              },
            ),
            Consumer<TvSeriesListNotifier>(builder: (context, data, child) {
              final state = data.tvSeriesPopularState;
              if (state == RequestState.Loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state == RequestState.Loaded) {
                return TvSeriesList(data.tvSeriesPupular);
              } else {
                return const Text('Failed');
              }
            }),
            _buildSubHeading(
              title: 'Tv Series Top Rated',
              onTap: () => {
                Navigator.pushNamed(context, TV_TOP_RATED_TV_SERIES_ROUTE),
              },
            ),
            Consumer<TvSeriesListNotifier>(builder: (context, data, child) {
              final state = data.tvSerisTopRatedState;
              if (state == RequestState.Loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state == RequestState.Loaded) {
                return TvSeriesList(data.tvSeriesTopRated);
              } else {
                return const Text('Failed');
              }
            }),
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
              children: const [Text('See More'), Icon(Icons.arrow_forward_ios)],
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
    return SizedBox(
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
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tvSeriesList.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
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
