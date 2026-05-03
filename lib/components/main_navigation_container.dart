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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.black26,
        backgroundColor: Color(0xFF9DD5F3),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Filters'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Stats'),
        ],
      ),
    );
  }
}
