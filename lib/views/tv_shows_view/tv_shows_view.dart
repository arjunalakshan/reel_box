import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:reel_box/models/tv_show_model.dart';
import 'package:reel_box/services/tvshow_api_service.dart';
import 'package:reel_box/widgets/tv_show_list_card.dart';

class TvShowsView extends StatefulWidget {
  const TvShowsView({super.key});

  @override
  State<TvShowsView> createState() => _TvShowsViewState();
}

class _TvShowsViewState extends State<TvShowsView> {
  @override
  void initState() {
    super.initState();
    _getTVShows();
  }

  List<TvShowModel> _tvShowList = [];
  bool _isLoading = true;
  String _errorText = "";

  //* Get TV Show list from API service
  Future<void> _getTVShows() async {
    try {
      List<TvShowModel> tvShows = await TvshowApiService().getTVShowList();
      setState(() {
        _tvShowList = tvShows;
        _isLoading = false;
        log(_tvShowList.length.toString());
      });
    } catch (e) {
      log(e.toString());
      setState(() {
        _errorText = "Somethig went wrong!";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TV Shows"),
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
              : _errorText.isNotEmpty
                  ? Center(
                      child: Text(
                        _errorText,
                        style: TextStyle(color: Colors.red[600]),
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: _tvShowList.length,
                            itemBuilder: (context, index) {
                              return TvShowListCard(
                                  tvShowModel: _tvShowList[index]);
                            },
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
