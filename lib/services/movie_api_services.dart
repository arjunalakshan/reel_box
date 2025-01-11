import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:reel_box/models/movie_model.dart';

class MovieApiServices {
  final String _apiAccessToken = dotenv.env["TMDB_ACCESS_TOKEN"] ?? "";
  final String _baseUrl = "https://api.themoviedb.org/3/";

  //* Get Popular movie list
  Future<List<MovieModel>> getPopularMovieList({int pageId = 1}) async {
    try {
      final response = await http.get(
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer $_apiAccessToken",
        },
        Uri.parse("${_baseUrl}movie/popular?language=en-US&page=$pageId"),
      );
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final List<dynamic> resultsList = jsonBody["results"];

        return resultsList
            .map((element) => MovieModel.fromJson(element))
            .toList();
      } else {
        log(response.statusCode.toString());
        return [];
      }
    } catch (error) {
      log(error.toString());
      return [];
    }
  }

  //* Get Now playing movie list
  Future<List<MovieModel>> getNowplayingMovieList({int pageId = 1}) async {
    try {
      final response = await http.get(
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer $_apiAccessToken",
        },
        Uri.parse("${_baseUrl}movie/now_playing?language=en-US&page=$pageId"),
      );
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final List<dynamic> resultsList = jsonBody["results"];

        return resultsList
            .map((element) => MovieModel.fromJson(element))
            .toList();
      } else {
        log(response.statusCode.toString());
        return [];
      }
    } catch (error) {
      log(error.toString());
      return [];
    }
  }

  //* Get Now Playing Movie list total pages
  Future<int> getNowPlayingMovieTotalPages() async {
    try {
      final response = await http.get(
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer $_apiAccessToken",
        },
        Uri.parse("${_baseUrl}movie/now_playing?language=en-US&page=1"),
      );
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final int totalPages = jsonBody["total_pages"];
        log(totalPages.toString());
        return totalPages;
      } else {
        log(response.statusCode.toString());
        return 0;
      }
    } catch (error) {
      log(error.toString());
      return 0;
    }
  }

  //* Get movies by search query
  Future<List<MovieModel>> getMovieListBySearchQuery(String searchQuery) async {
    try {
      final response = await http.get(
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer $_apiAccessToken",
        },
        Uri.parse(
            "${_baseUrl}search/movie?query=$searchQuery&include_adult=false&language=en-US&page=1"),
      );
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final List<dynamic> resultsList = jsonBody["results"];

        return resultsList
            .map((element) => MovieModel.fromJson(element))
            .toList();
      } else {
        log(response.statusCode.toString());
        return [];
      }
    } catch (error) {
      log(error.toString());
      return [];
    }
  }
}
