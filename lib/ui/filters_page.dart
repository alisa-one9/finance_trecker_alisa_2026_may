import 'package:finance_trecker_alisa/components/myGradient.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/item_transaction.dart';
import '../components/searchDateWidget.dart';
import '../components/searchWordWidget.dart';
import '../models/model_category.dart';
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
  late List<Model_category> redCategories;
  late List<Model_category> greenCategories;
  List<Model_category> all_categories = [];

  DateTime? _searchDate;
  String _name_category = '';

  @override
  void initState() {
    super.initState();
    redCategories = Model_category.getRedCategories();
    greenCategories = Model_category.getGreenCategories();
    all_categories.addAll(redCategories);
    all_categories.addAll(greenCategories);
  }

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
        displayList =
            _name_category.isEmpty
                ? []
                : sum_provider.sortCategoryListTransactions(_name_category);
        break;
      case 'Date':
        displayList =
            _searchDate == null
                ? []
                : sum_provider.sortDateListTransactions(_searchDate!);
        break;
      case 'SearchWord':
        displayList = sum_provider.sortQuerySearchList(_currentSearchQuery);
        break;

      default:
        displayList = sum_provider.sortDateListTransactions(DateTime.now());
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
          if (_activeFilter == 'Category') _buildCategoryList(),

          if (_activeFilter == 'Date')
            SearchDateWidget(
              onValueChanged: (date) {
                setState(() {
                  _searchDate = date;
                });
              },
            ),

          const Divider(),

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
        onSelected: (selected_chip) {
          if (selected_chip) {
            setState(() {
              _activeFilter = label;

              if (label != 'SearchWord') {
                _currentSearchQuery = '';
              }
              if (label != 'Date') {
                _searchDate = null;
              }
            });
          }
        },
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 85,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: all_categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final item = all_categories[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                for (var c in all_categories) {
                  c.isSelected = false;
                }
                item.isSelected = true;
                _name_category = item.name;
              });
            },
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        item.isSelected
                            ? item.color.withOpacity(0.4)
                            : Colors.white,
                    border: Border.all(
                      color: item.isSelected ? item.color : Colors.grey,
                      width: item.isSelected ? 3 : 1,
                    ),
                  ),
                  child: item.icon,
                ),
                const SizedBox(height: 4),
                Text(item.name, style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}
