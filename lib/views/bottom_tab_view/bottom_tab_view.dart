import 'package:flutter/material.dart';
import 'package:reel_box/views/home_view/home_view.dart';
import 'package:reel_box/views/now_playing_view/now_playing_view.dart';
import 'package:reel_box/views/search_view/search_view.dart';
import 'package:reel_box/views/tv_shows_view/tv_shows_view.dart';

class BottomTabView extends StatefulWidget {
  const BottomTabView({super.key});

  @override
  State<BottomTabView> createState() => _BottomTabViewState();
}

class _BottomTabViewState extends State<BottomTabView> {
  //* Selected view index
  int _selectedIndex = 0;

  //* Bottom nav views
  final List bottomNavViewList = [
    HomeView(),
    NowPlayingView(),
    TvShowsView(),
    SearchView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xff051923),
        elevation: 0,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Color(0xff00A6FB),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_filled_rounded),
            label: "Now Playing",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv_rounded),
            label: "TV Shows",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: "Search",
          ),
        ],
      ),
      body: bottomNavViewList[_selectedIndex],
    );
  }
}
