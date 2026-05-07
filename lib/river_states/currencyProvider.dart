import 'package:flutter/material.dart';

import '../services/dollarApiService.dart';

class CurrencyProvider with ChangeNotifier {
  double _dollarCourse = 0.0;
  bool _isLoading = true;
  String _errorMessage = '';

  double get dollarCourse => _dollarCourse;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchCurrency() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final apiService = DollarApiService();
      final course = await apiService.getDollarCourse();
      _dollarCourse = course;
    } catch (e) {
      _errorMessage = e.toString();
      // значение на всякий случай, чтобы не ломалось когда данные ноль
      _dollarCourse = 89.0;
      print("CurrencyProvider Error: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  double convertToUsd(double kgsAmount) {
    if (_dollarCourse <= 0) return 0.0;
    return kgsAmount / _dollarCourse;
  }
}
