import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../utils/exception.dart';
import '../models/tv_series_detail_response.dart';
import '../models/tv_series_model.dart';
import '../models/tv_series_response.dart';

abstract class TvSeriesRemoteDataSource {
  Future<List<TvSeriesModel>> getTvSeriesAiringToday();
  Future<List<TvSeriesModel>> getTvSeriesPopular();
  Future<List<TvSeriesModel>> getTvSeriesTopRated();
  Future<TvSeriesDetailResponse> getTvSeriesDetail(int id);
  Future<List<TvSeriesModel>> getTvSeriesRecommendation(int id);
  Future<List<TvSeriesModel>> searchTvSeries(String query);
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

  @override
  Future<TvSeriesDetailResponse> getTvSeriesDetail(int id) async {
    final response = await client.get(
      Uri.parse(
        '$BASE_URL/tv/$id?$API_KEY',
      ),
    );

    if (response.statusCode == 200) {
      return TvSeriesDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> getTvSeriesRecommendation(int id) async {
    final response = await client.get(
      Uri.parse(
        '$BASE_URL/tv/$id/recommendations?$API_KEY',
      ),
    );

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesModel>> searchTvSeries(String query) async {
    final response = await client.get(
      Uri.parse(
        '$BASE_URL/search/tv?$API_KEY&query=$query',
      ),
    );

    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).tvSeriesList;
    } else {
      throw ServerException();
    }
  }
}
