import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:reel_box/models/movie_model.dart';
import 'package:reel_box/services/movie_api_services.dart';

class MovieDetailsView extends StatefulWidget {
  MovieModel movieModel;
  MovieDetailsView({
    super.key,
    required this.movieModel,
  });

  @override
  State<MovieDetailsView> createState() => _MovieDetailsViewState();
}

class _MovieDetailsViewState extends State<MovieDetailsView> {
  @override
  void initState() {
    super.initState();
    _getSimilarMovies();
    _getRecommendedMovies();
    _getMovieImages();
  }

  List<MovieModel> _similarMovieList = [];
  List<MovieModel> _recommendedMovieList = [];
  List<String> _movieImageUrlList = [];

  bool _isLoadigSimilar = true;
  bool _isLoadigRecommended = true;
  bool _isLoadigImageUrl = true;

  final String _imageBaseUrl = "https://image.tmdb.org/t/p/w500";
  final String _placeholderImageUrl = "https://placehold.co/500.png";

  //* Get Similar movies from API Service
  Future<void> _getSimilarMovies() async {
    try {
      List<MovieModel> similarMovieList = await MovieApiServices()
          .getSimilarMovieListByID(widget.movieModel.id);
      setState(() {
        _similarMovieList = similarMovieList;
        _isLoadigSimilar = false;
      });
    } catch (e) {
      log("Error in _getSimilarMovies: $e");
      setState(() {
        _isLoadigSimilar = false;
      });
    }
  }

  //* Get Recommended movies from API Service
  Future<void> _getRecommendedMovies() async {
    try {
      List<MovieModel> recommendedMovieList = await MovieApiServices()
          .getRecommendedMovieListByID(widget.movieModel.id);
      setState(() {
        _recommendedMovieList = recommendedMovieList;
        _isLoadigRecommended = false;
      });
    } catch (e) {
      log("Error in _getRecommendedMovies: $e");
      setState(() {
        _isLoadigRecommended = false;
      });
    }
  }

  //* Get Movie Images from API Service
  Future<void> _getMovieImages() async {
    try {
      List<String> movieImagesList =
          await MovieApiServices().getImageUrlListByID(widget.movieModel.id);
      setState(() {
        _movieImageUrlList = movieImagesList;
        _isLoadigImageUrl = false;
      });
    } catch (e) {
      log("Error in _getMoiveImages: $e");
      setState(() {
        _isLoadigImageUrl = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movieModel.title),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    "$_imageBaseUrl${widget.movieModel.posterImgUrl}",
                    height: MediaQuery.sizeOf(context).height * 0.50,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Released: ${widget.movieModel.releaseDate}",
                style: TextStyle(
                  color: Color(0xff00A6FB),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Overview",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.movieModel.overview,
                style: TextStyle(
                  color: Color(0xff006494),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatData(
                      widget.movieModel.voteAverage.toStringAsFixed(1),
                      Icons.thumb_up_rounded),
                  _buildStatData(
                      widget.movieModel.popularity.toStringAsFixed(2),
                      Icons.trending_up_rounded),
                ],
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Text(
                "Movie Images",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              _buildImageSection(),
              SizedBox(height: 16),
              Text(
                "Similar Movies",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              _buildOptinalMoviesSection(_similarMovieList, _isLoadigSimilar),
              SizedBox(height: 16),
              Text(
                "Recommended Movies",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              _buildOptinalMoviesSection(
                  _recommendedMovieList, _isLoadigRecommended),
            ],
          ),
        ),
      ),
    );
  }

  //* Stat widget - for avg vote and popularity
  Widget _buildStatData(String value, IconData icon) {
    return Row(
      spacing: 4,
      children: [
        Icon(
          icon,
          size: 16,
          color: Color(0xff006494),
        ),
        Text(
          value,
          style: TextStyle(
            color: Color(0xff006494),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  //* image section widget for movie images
  Widget _buildImageSection() {
    if (_isLoadigImageUrl) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xff006494),
        ),
      );
    } else if (_movieImageUrlList.isEmpty) {
      return Center(
        child: Text(
          "No images to show",
          style: TextStyle(
            color: Color(0xff003554),
            fontSize: 14,
          ),
        ),
      );
    }
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.25,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _movieImageUrlList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: 8),
            width: MediaQuery.sizeOf(context).width * 0.40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _movieImageUrlList[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  //* Movies section widget - for similar and recommended movies
  Widget _buildOptinalMoviesSection(
      List<MovieModel> movieList, bool loadingState) {
    if (loadingState) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xff006494),
        ),
      );
    } else if (movieList.isEmpty) {
      return Center(
        child: Text(
          "No movies to show",
          style: TextStyle(
            color: Color(0xff003554),
            fontSize: 14,
          ),
        ),
      );
    }
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.36,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: movieList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                widget.movieModel = movieList[index];
                _getSimilarMovies();
                _getRecommendedMovies();
                _getMovieImages();
              });
            },
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.40,
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xff003554).withAlpha(56),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      movieList[index].posterImgUrl == "" ||
                              movieList[index].posterImgUrl == null
                          ? _placeholderImageUrl
                          : "$_imageBaseUrl${movieList[index].posterImgUrl}",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    movieList[index].title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Vote (avg.): ${movieList[index].voteAverage.toStringAsFixed(1)}",
                    style: TextStyle(
                      color: Color(0xff00A6FB),
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
