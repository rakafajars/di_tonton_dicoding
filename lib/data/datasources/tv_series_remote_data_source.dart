import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:http/http.dart' as http;

abstract class TvSeriesRemoteDataSource {
  Future<List<TvSeriesModel>> getTvSeriesAiringToday();
  Future<List<TvSeriesModel>> getTvSeriesPopular();
  Future<List<TvSeriesModel>> getTvSeriesTopRated();
}

class TvSeriesRemoteDataSourceImpl implements TvSeriesRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final http.Client client;

  TvSeriesRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvSeriesModel>> getTvSeriesAiringToday() async {
    final response = await client.get(
      Uri.parse(
        '$BASE_URL/tv/airing_today?$API_KEY',
      ),
    );
    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getTvSeriesPopular() async {
    final response = await client.get(
      Uri.parse(
        '$BASE_URL/tv/popular?$API_KEY',
      ),
    );

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getTvSeriesTopRated() async {
    final response = await client.get(
      Uri.parse(
        '$BASE_URL/tv/top_rated?$API_KEY',
      ),
    );

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }
}
