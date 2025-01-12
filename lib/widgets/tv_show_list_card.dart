import 'package:flutter/material.dart';
import 'package:reel_box/models/tv_show_model.dart';

class TvShowListCard extends StatelessWidget {
  final TvShowModel tvShowModel;
  const TvShowListCard({
    super.key,
    required this.tvShowModel,
  });

  @override
  Widget build(BuildContext context) {
    String imageBaseUrl = "https://image.tmdb.org/t/p/w500";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(0xff003554).withAlpha(40),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              "$imageBaseUrl${tvShowModel.posterImgUrl}",
              height: MediaQuery.sizeOf(context).height * 0.28,
              width: MediaQuery.sizeOf(context).width * 0.40,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 8),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.28,
            width: MediaQuery.sizeOf(context).width * 0.45,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tvShowModel.name,
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
                  "Aired: ${tvShowModel.firstAirDate}",
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
                        tvShowModel.overview == ""
                            ? "N/A"
                            : tvShowModel.overview,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xff006494),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
