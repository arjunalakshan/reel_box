import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:reel_box/models/movie_model.dart';
import 'package:reel_box/services/movie_api_services.dart';
import 'package:reel_box/widgets/search_result_card.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _editingController = TextEditingController();
  List<MovieModel> _searchResultList = [];
  bool _isLoading = false;
  String _errorText = "";

  //* Get search result by using API service
  Future<void> _getMoviesFromQuery() async {
    setState(() {
      _isLoading = true;
      _errorText = "";
    });
    try {
      List<MovieModel> results = await MovieApiServices()
          .getMovieListBySearchQuery(_editingController.text);
      setState(() {
        _searchResultList = results;
      });
    } catch (e) {
      log(e.toString());
      setState(() {
        _errorText = "Somethig went wrong!";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Movies"),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _editingController,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: "Search here...",
                        hintStyle: TextStyle(
                          color: Color(0xff003554),
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Color(0xff003554),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Color(0xff006494),
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Color(0xff003554),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Color(0xff00A6FB),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: _getMoviesFromQuery,
                      icon: Icon(
                        Icons.search_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _isLoading
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
                      : _searchResultList.isEmpty
                          ? Center(
                              child: Text("No movies found for entered search"),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: _searchResultList.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      SearchResultCard(
                                          movieModel: _searchResultList[index]),
                                      Divider(),
                                      SizedBox(height: 8),
                                    ],
                                  );
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
