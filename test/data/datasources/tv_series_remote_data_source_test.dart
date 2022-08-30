import 'dart:convert';
import 'dart:io';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/data/models/tv_series_detail_response.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';
  late TvSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvSeriesRemoteDataSourceImpl(
      client: mockHttpClient,
    );
  });

  var urlTvSeriesAiringToday = '$BASE_URL/tv/airing_today?$API_KEY';
  var urlTvSeriesPopular = '$BASE_URL/tv/popular?$API_KEY';
  var urlTvSeriesTopRated = '$BASE_URL/tv/top_rated?$API_KEY';

  group('get Tv Series Airing Today', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_series_airing_today.json')))
        .tvSeriesList;
    test(
      'should return list of Tv Series Model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(
            Uri.parse(urlTvSeriesAiringToday),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/tv_series_airing_today.json'),
            200,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
            },
          ),
        );
        // act
        final result = await dataSource.getTvSeriesAiringToday();
        // assert
        expect(result, equals(tTvSeriesList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () {
        // arrange
        when(mockHttpClient.get(Uri.parse(urlTvSeriesAiringToday))).thenAnswer(
          (_) async => http.Response('Not Found', 404),
        );
        // act
        final call = dataSource.getTvSeriesAiringToday();
        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group(
    'Get Tv Series Popular',
    () {
      final tTvSeriesList = TvSeriesResponse.fromJson(
        json.decode(
          readJson('dummy_data/tv_series_popular.json'),
        ),
      ).tvSeriesList;

      test(
        'should return list of tv series when response is success (200)',
        () async {
          // arrange
          when(
            mockHttpClient.get(
              Uri.parse(urlTvSeriesPopular),
            ),
          ).thenAnswer(
            (_) async => http.Response(
              readJson('dummy_data/tv_series_popular.json'),
              200,
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
              },
            ),
          );
          // act
          final result = await dataSource.getTvSeriesPopular();
          // assert
          expect(result, tTvSeriesList);
        },
      );

      test(
        'should throw a ServerException when the response code is 404 or other',
        () {
          // arrange
          when(mockHttpClient.get(Uri.parse(urlTvSeriesPopular))).thenAnswer(
            (_) async => http.Response('Not Found', 404),
          );
          // act
          final call = dataSource.getTvSeriesPopular();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        },
      );
    },
  );

  group('get Top Rated Tv Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_series_top_rated.json')))
        .tvSeriesList;

    test('should return list of tv series when response code is 200 ',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse(urlTvSeriesTopRated))).thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/tv_series_top_rated.json'),
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
          },
        ),
      );
      // act
      final result = await dataSource.getTvSeriesTopRated();
      // assert
      expect(result, tTvSeriesList);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse(urlTvSeriesTopRated)))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvSeriesTopRated();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv series detail', () {
    final tId = 31917;

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvSeriesDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv series recommendation', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
      json.decode(
        readJson('dummy_data/tv_series_recommendation.json'),
      ),
    ).tvSeriesList;
    final tId = 31917;

    test('should return list of tv series Model when the response code is 200',
        () async {
      //arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/tv_series_recommendation.json'),
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
          },
        ),
      );
      // act
      final result = await dataSource.getTvSeriesRecommendation(tId);
      // assert
      expect(result, equals(tTvSeriesList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTvSeriesRecommendation(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv series search', () {
    final tSearchResult = TvSeriesResponse.fromJson(
      json.decode(
        readJson('dummy_data/tv_series_search.json'),
      ),
    ).tvSeriesList;
    final tQuery = 'Pretty Little Liars';
    test(
      'should return list of movies when response code is 200',
      () async {
        // arrange
        when(mockHttpClient
                .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
            .thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/tv_series_search.json'),
            200,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
            },
          ),
        );
        // act
        final result = await dataSource.searchTvSeries(tQuery);
        // assert
        expect((result), tSearchResult);
      },
    );

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.searchTvSeries(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
