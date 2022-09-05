import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/search_tv_series/search_tv_series_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/search_movie/search_movie_bloc.dart';
import '../widgets/movie_card_list.dart';
import '../widgets/tv_series_card_list.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<SearchMovieBloc>().add(
                      OnQueryChanged(
                        query,
                      ),
                    );

                context.read<SearchTvSeriesBloc>().add(
                      SearchTvQueryEvent(
                        query,
                      ),
                    );
              },
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            const TabBar(
              tabs: [
                Tab(
                  text: 'Movie',
                ),
                Tab(
                  text: 'Tv Series',
                )
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  BlocBuilder<SearchMovieBloc, SearchMovieState>(
                    builder: (context, state) {
                      if (state is SearchMovieLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is SearchMovieHasData) {
                        final result = state.result;
                        return Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              final movie = result[index];
                              return MovieCard(movie);
                            },
                            itemCount: result.length,
                          ),
                        );
                      } else if (state is SearchMovieError) {
                        return Expanded(
                          child: Center(
                            child: Text(state.message),
                          ),
                        );
                      } else {
                        return Expanded(
                          child: Container(),
                        );
                      }
                    },
                  ),
                  BlocBuilder<SearchTvSeriesBloc, SearchTvSeriesState>(
                    builder: (context, state) {
                      if (state is SearchTvSeriesLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is SearchTvSeriesHasData) {
                        final result = state.result;
                        return Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              final tvSeries = result[index];
                              return TvSeriesCard(tvSeries);
                            },
                            itemCount: result.length,
                          ),
                        );
                      } else if (state is SearchTvSeriesError) {
                        return Expanded(
                          child: Center(
                            child: Text(state.message),
                          ),
                        );
                      } else {
                        return Expanded(
                          child: Container(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
