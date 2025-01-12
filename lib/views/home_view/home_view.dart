import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:reel_box/models/movie_model.dart';
import 'package:reel_box/services/movie_api_services.dart';
import 'package:reel_box/views/shared/movie_details_view.dart';
import 'package:reel_box/widgets/movie_list_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    _getPopularMovies();
  }

  List<MovieModel> _popularMovieList = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMoreDataToLoad = true;

  //* get popular movies by calling API Service
  Future<void> _getPopularMovies() async {
    if (_isLoading || !_hasMoreDataToLoad) {
      return;
    } else {
      setState(() {
        _isLoading = true;
      });
      await Future.delayed(Duration(seconds: 1));
      try {
        final nextMovieList =
            await MovieApiServices().getPopularMovieList(pageId: _currentPage);
        log(nextMovieList.length.toString());
        setState(() {
          if (nextMovieList.isEmpty) {
            _hasMoreDataToLoad = false;
          } else {
            _popularMovieList.addAll(nextMovieList);
            _currentPage++;
          }
        });
      } catch (e) {
        log(e.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ReelBox"),
        titleTextStyle: TextStyle(
          color: Color(0xff00A6FB),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (!_isLoading &&
                  notification.metrics.pixels ==
                      notification.metrics.maxScrollExtent) {
                _getPopularMovies();
              }
              return true;
            },
            child: ListView.builder(
              itemCount: _popularMovieList.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _popularMovieList.length) {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xff006494),
                    ),
                  );
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => MovieDetailsView(
                            movieModel: _popularMovieList[index])),
                      ),
                    );
                  },
                  child: MovieListCard(movieModel: _popularMovieList[index]),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
