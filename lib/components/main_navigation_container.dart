import 'package:finance_trecker_alisa/components/myGradient.dart';
import 'package:flutter/material.dart';

import '../ui/filters_page.dart' show FiltersPage;
import '../ui/history_page.dart';
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
  late List<Widget> _visualPages;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _visualPages = [HomeSreen(), FiltersPage(), StatisticPage(), HistoryPage()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _visualPages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(gradient: myGradient),

        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.white,

          selectedIconTheme: const IconThemeData(size: 28, color: Colors.green),
          unselectedIconTheme: const IconThemeData(
            size: 24,
            color: Colors.white,
          ),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Filters',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
          ],
        ),
      ),
    );
  }
}
