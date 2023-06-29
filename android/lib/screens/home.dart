import 'package:android/screens/bookshelf.dart';
import 'package:android/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  List<Widget> _pages = [
    SearchScreen(),
    BookShelfScreen(),
  ];

  void _onItemSelected(int index) {
    setState(() {
      print(index);
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemSelected,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '搜索',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              label: '书架',
            ),
          ],
        ),
      ),
    );
  }
}
