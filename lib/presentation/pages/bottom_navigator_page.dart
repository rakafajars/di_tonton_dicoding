import 'package:ditonton/presentation/pages/movie_page.dart';
import 'package:ditonton/presentation/pages/tv_series_page.dart';
import 'package:flutter/material.dart';

import '../../common/routes.dart';

class BottomNavigatorPage extends StatefulWidget {
  const BottomNavigatorPage({Key? key}) : super(key: key);

  @override
  State<BottomNavigatorPage> createState() => _BottomNavigatorPageState();
}

class _BottomNavigatorPageState extends State<BottomNavigatorPage> {
  int _currentSelectIndex = 0;

  List<Widget> _bodyWidget = [
    MoviePage(),
    TvSeriesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Movie Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WATCHLIST_MOVIE_ROUTE);
              },
            ),
            ListTile(
              leading: Icon(Icons.tv),
              title: Text('Tv Series Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, TV_SERIES_WATCHLIST_ROUTE);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, ABOUT_ROUTE);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SEARCH_ROUTE);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: _bodyWidget.elementAt(_currentSelectIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Movie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv_outlined),
            label: 'TV Series',
          ),
        ],
        currentIndex: _currentSelectIndex,
        onTap: (int index) {
          setState(() {
            _currentSelectIndex = index;
          });
        },
        showUnselectedLabels: true,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
      ),
    );
  }
}
