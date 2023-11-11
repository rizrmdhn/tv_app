import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:http/http.dart' as http;

abstract class TvRemoveDataSource {
  Future<List<TvModel>> getAiringTodayTvs();
  Future<List<TvModel>> getOnTheAirTvs();
  Future<List<TvModel>> getPopularTvs();
  Future<List<TvModel>> getTopRatedTvs();
  Future<TvDetailModel> getTvDetail(int id);
  Future<List<TvModel>> getTvRecommendations(int id);
  Future<List<TvModel>> searchTvs(String query);
}

class TvRemoteDataSourceImpl implements TvRemoveDataSource {
  static const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const baseUrl = 'https://api.themoviedb.org/3';

  final http.Client client;

  TvRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvModel>> getAiringTodayTvs() async {
    final response =
        await client.get(Uri.parse('$baseUrl/tv/airing_today?$apiKey'));
    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getOnTheAirTvs() async {
    final response =
        await client.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey'));
    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getPopularTvs() async {
    final response = await client.get(Uri.parse('$baseUrl/tv/popular?$apiKey'));
    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTopRatedTvs() async {
    final response =
        await client.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey'));
    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvDetailModel> getTvDetail(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/tv/$id?$apiKey'));

    if (response.statusCode == 200) {
      return TvDetailModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTvRecommendations(int id) async {
    final response =
        await client.get(Uri.parse('$baseUrl/tv/$id/recommendations?$apiKey'));

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> searchTvs(String query) async {
    final response =
        await client.get(Uri.parse('$baseUrl/search/tv?$apiKey&query=$query'));

    if (response.statusCode == 200) {
      return TvResponse.fromJson(json.decode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }
}
