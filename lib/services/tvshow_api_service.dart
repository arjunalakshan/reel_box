import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:reel_box/models/tv_show_model.dart';

class TvshowApiService {
  final String _apiAccessToken = dotenv.env["TMDB_ACCESS_TOKEN"] ?? "";
  final String _baseUrl = "https://api.themoviedb.org/3/tv/";

  Future<List<TvShowModel>> getTVShowList() async {
    try {
      final popularTVShowResponse = await http.get(
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer $_apiAccessToken",
        },
        Uri.parse("${_baseUrl}popular?language=en-US&page=1"),
      );
      final airingTodayTVShowResponse = await http.get(
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer $_apiAccessToken",
        },
        Uri.parse("${_baseUrl}airing_today?language=en-US&page=1"),
      );
      final topRatedTVShowResponse = await http.get(
        headers: {
          "accept": "application/json",
          "Authorization": "Bearer $_apiAccessToken",
        },
        Uri.parse("${_baseUrl}top_rated?language=en-US&page=1"),
      );

      if (popularTVShowResponse.statusCode == 200 &&
          airingTodayTVShowResponse.statusCode == 200 &&
          topRatedTVShowResponse.statusCode == 200) {
        final popularJsonBody = jsonDecode(popularTVShowResponse.body);
        final airingTodayJsonBody = jsonDecode(airingTodayTVShowResponse.body);
        final topRatedJsonBody = jsonDecode(topRatedTVShowResponse.body);

        final List<dynamic> popularResultsList = popularJsonBody["results"];
        final List<dynamic> airingResultsList = airingTodayJsonBody["results"];
        final List<dynamic> topratedResultsList = topRatedJsonBody["results"];

        List<TvShowModel> tvShowList = [];
        tvShowList.addAll(
          popularResultsList
              .map((element) => TvShowModel.fromJson(element))
              .take(10),
        );
        tvShowList.addAll(
          airingResultsList
              .map((element) => TvShowModel.fromJson(element))
              .take(10),
        );
        tvShowList.addAll(
          topratedResultsList
              .map((element) => TvShowModel.fromJson(element))
              .take(10),
        );

        return tvShowList;
      } else {
        log("${popularTVShowResponse.statusCode}, ${airingTodayTVShowResponse.statusCode}, ${topRatedTVShowResponse.statusCode}");
        return [];
      }
    } catch (error) {
      log(error.toString());
      return [];
    }
  }
}
