import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:reel_box/models/movie_model.dart';
import 'package:reel_box/services/movie_api_services.dart';
import 'package:reel_box/widgets/movie_list_card.dart';

class NowPlayingView extends StatefulWidget {
  const NowPlayingView({super.key});

  @override
  State<NowPlayingView> createState() => _NowPlayingViewState();
}

class _NowPlayingViewState extends State<NowPlayingView> {
  @override
  void initState() {
    _getNowPlayingMovies();
    super.initState();
  }

  List<MovieModel> _nowPlayingMovieList = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;

  //* Get now playig list from api service
  Future<void> _getNowPlayingMovies() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<MovieModel> nextMovieList =
          await MovieApiServices().getNowplayingMovieList(pageId: _currentPage);
      int totalPagesAvailable =
          await MovieApiServices().getNowPlayingMovieTotalPages();
      setState(() {
        _nowPlayingMovieList = nextMovieList;
        _totalPages = totalPagesAvailable;
      });
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //* Previous page movie list
  void _onPreviousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      _getNowPlayingMovies();
    }
  }

  //* Next page movie list
  void _onNextPage() {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
      });
      _getNowPlayingMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Now Playing - Movies"),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xff006494),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _nowPlayingMovieList.length + 1,
                        itemBuilder: (context, index) {
                          if (index > _nowPlayingMovieList.length - 1) {
                            log("index is: $index , ${_nowPlayingMovieList.length}");
                            return _buildPageControllers();
                          } else {
                            return MovieListCard(
                              movieModel: _nowPlayingMovieList[index],
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildPageControllers() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: _currentPage > 1 ? _onPreviousPage : null,
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Color(0xff003554)),
          ),
          child: Text(
            "Previous",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          "Page $_currentPage of $_totalPages",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
        TextButton(
          onPressed: _currentPage < _totalPages ? _onNextPage : null,
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Color(0xff003554)),
          ),
          child: Text(
            "Next",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
