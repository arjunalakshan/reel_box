import 'package:flutter/material.dart';
import 'package:reel_box/models/movie_model.dart';

class MovieListCard extends StatelessWidget {
  final MovieModel movieModel;
  const MovieListCard({
    super.key,
    required this.movieModel,
  });

  @override
  Widget build(BuildContext context) {
    String imageBaseUrl = "https://image.tmdb.org/t/p/w500";
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xff003554),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              "$imageBaseUrl${movieModel.posterImgUrl}",
              height: MediaQuery.sizeOf(context).height * 0.30,
              width: MediaQuery.sizeOf(context).width * 0.40,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 8),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.30,
            width: MediaQuery.sizeOf(context).width * 0.45,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  movieModel.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Released: ${movieModel.releaseDate}",
                  style: TextStyle(
                    color: Color(0xff00A6FB),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Overview",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        movieModel.overview,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xff003554),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _bottomVoteData(movieModel.voteAverage.toStringAsFixed(1),
                        Icons.thumb_up_rounded),
                    _bottomVoteData(movieModel.popularity.toStringAsFixed(2),
                        Icons.trending_up_rounded),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _bottomVoteData(String value, IconData icon) {
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
}
