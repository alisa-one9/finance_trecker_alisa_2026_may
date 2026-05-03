import 'package:finance_trecker_alisa/models/model_transaction.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LocalSumProvider with ChangeNotifier {
  final _box = Hive.box<Model_Trancaction>('transactions');
  double get totalBalance {
    double total = 0.0;
    for (var transaction in _box.values) {
      if (transaction.type == 'income') {
        total += transaction.amount;
      } else {
        if (total < 0 || total < transaction!.amount) {
        } else {
          total -= transaction.amount;
        }
      }
    }
    return total;
  }

  Future<List<Model_Trancaction>> sortCategoryListTransactions(
    String categoryName,
  ) async {
    return _box.values.where((item) => item.category == categoryName).toList();
    ;
  }

  List<Model_Trancaction> sortMonthListTransactions(int month) {
    return _box.values
        .where(
          (item) =>
              item.date.month == month && item.date.year == DateTime.now().year,
        )
        .toList();
  }

  List<Model_Trancaction> sortDateListTransactions(DateTime date) {
    return _box.values
        .where(
          (item) =>
              item.date.day == date.day &&
              item.date.month == date.month &&
              item.date.year == date.year,
        )
        .toList();
  }

  List<Model_Trancaction> sortTypeTransactions(String type) {
    return _box.values.where((item) => item.type == type).toList();
  }

  List<Model_Trancaction> sortListYearTransactions(int year) {
    return _box.values.where((item) => item.date.year == year).toList();
  }

  List<Model_Trancaction> querySearchListCommentTransactions(String query) {
    if (query.isEmpty) return _box.values.toList();

    return _box.values
        .where(
          (item) => item.comment.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  bool canAfford(double amount) {
    return totalBalance >= amount;
  }

  void refresh() {
    notifyListeners();
  }
}
