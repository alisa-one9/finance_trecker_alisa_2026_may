import 'package:finance_trecker_alisa/ui/add_operation.dart';
import 'package:finance_trecker_alisa/ui/filters_page.dart';
import 'package:finance_trecker_alisa/ui/history_page.dart';
import 'package:finance_trecker_alisa/ui/splash_sceen.dart';
import 'package:finance_trecker_alisa/ui/statistic_page.dart';
import 'package:flutter/material.dart';

import 'components/main_navigation_container.dart';

class AppNavigation {
  static const String splash = '/splash';
  static const String home = '/';
  static const String add_operation = '/add_operation';
  static const String filters_page = '/filters_page';
  static const String statistic_page = '/statistic_page';
  static const String history_page = '/history_page';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case home:
        return MaterialPageRoute(
          builder: (_) => const MainNavigationContainer(),
        );
      case add_operation:
        return MaterialPageRoute(builder: (_) => AddOperation());
      case filters_page:
        return MaterialPageRoute(builder: (_) => FiltersPage());
      case statistic_page:
        return MaterialPageRoute(builder: (_) => StatisticPage());
      case history_page:
        return MaterialPageRoute(builder: (_) => HistoryPage());
      default:
        return MaterialPageRoute(
          builder: (_) => const MainNavigationContainer(),
        );
    }
  }
}
