import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core.dart';
import '../provider/tv_series_watchlist_notifier.dart';
import '../widgets/tv_series_card_list.dart';

class TvSeriesWatchlistPage extends StatefulWidget {
  const TvSeriesWatchlistPage({Key? key}) : super(key: key);

  @override
  State<TvSeriesWatchlistPage> createState() => _TvSeriesWatchlistPageState();
}

class _TvSeriesWatchlistPageState extends State<TvSeriesWatchlistPage>
    with RouteAware {
  @override
  void initState() {
    Future.microtask(() =>
        Provider.of<TvSeriesWatchlistNotifier>(context, listen: false)
            .fetchTvSeriesWatchlistMovies());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    Provider.of<TvSeriesWatchlistNotifier>(context, listen: false)
        .fetchTvSeriesWatchlistMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tv Series Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TvSeriesWatchlistNotifier>(
          builder: (context, data, child) {
            if (data.tvSeriesState == RequestState.Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.tvSeriesState == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = data.tvSeriesWatchlist[index];
                  return TvSeriesCard(tvSeries);
                },
                itemCount: data.tvSeriesWatchlist.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
