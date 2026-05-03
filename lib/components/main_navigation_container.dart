import 'package:flutter/material.dart';

import '../ui/filters_page.dart' show FiltersPage;
import '../ui/home_screen.dart';
import '../ui/statistic_page.dart';

class MainNavigationContainer extends StatefulWidget {
  const MainNavigationContainer({super.key});

  @override
  State<MainNavigationContainer> createState() =>
      _MainNavigationContainerState();
}

class _MainNavigationContainerState extends State<MainNavigationContainer> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [HomeSreen(), FiltersPage(), StatisticPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          unselectedItemColor: Colors.black26,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          ],
      ),
    );
  }
}
