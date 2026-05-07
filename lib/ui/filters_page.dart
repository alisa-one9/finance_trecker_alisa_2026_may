import 'package:finance_trecker_alisa/components/myGradient.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../components/item_transaction.dart';
import '../components/searchWordWidget.dart';
import '../models/model_transaction.dart';
import '../river_states/local_sum_provider.dart';

class FiltersPage extends StatefulWidget {
  const FiltersPage({super.key});
  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  String _activeFilter = 'outcome';
  String _currentSearchQuery = '';

  @override
  Widget build(BuildContext context) {
    final sum_provider = Provider.of<LocalSumProvider>(context);
    List<Model_Trancaction> displayList;

    switch (_activeFilter) {
      case 'Income':
        displayList = sum_provider.sortTypeTransactions('income');
        break;
      case 'Outcome':
        displayList = sum_provider.sortTypeTransactions('outcome');
        break;
      case 'Category':
        displayList = sum_provider.sortCategoryListTransactions('food');
        break;
      case 'Date':
        displayList =
            Hive.box<Model_Trancaction>('transactions').values.toList();
        break;
      case 'SearchWord':
        displayList = sum_provider.sortQuerySearchList(_currentSearchQuery);
        break;

      default:
        displayList =
            Hive.box<Model_Trancaction>('transactions').values.toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Фильтр операций"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: myGradient),
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                _buildFilterChip('Income'),
                _buildFilterChip('Outcome'),
                _buildFilterChip('Category'),
                _buildFilterChip('Date'),
                _buildFilterChip('SearchWord'),
              ],
            ),
          ),

          if (_activeFilter == 'SearchWord')
            SearchWordWidget(
              onQueryChanged: (value) {
                setState(() {
                  _currentSearchQuery = value;
                });
              },
            ),

          Expanded(
            child:
                displayList.isEmpty
                    ? const Center(child: Text("Нет операций"))
                    : ListView.builder(
                      itemCount: displayList.length,
                      itemBuilder: (context, index) {
                        return ItemTransaction(transaction: displayList[index]);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _activeFilter == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (val) {
          setState(() => _activeFilter = label);
          if (label != 'SearchWord') _currentSearchQuery = '';
        },
      ),
    );
  }
}
