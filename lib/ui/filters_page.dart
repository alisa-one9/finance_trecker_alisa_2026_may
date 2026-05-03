import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../components/item_transaction.dart';
import '../models/model_transaction.dart';
import '../river_states/local_sum_provider.dart';

class FiltersPage extends StatefulWidget {
  const FiltersPage({super.key});
  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  String _activeFilter = 'All';
  @override
  Widget build(BuildContext context) {
    final sum_provider = Provider.of<LocalSumProvider>(context);
    List<Model_Trancaction> displayList;
    if (_activeFilter == 'Income') {
      displayList = sum_provider.sortTypeTransactions('income');
    } else if (_activeFilter == 'Outcome') {
      displayList = sum_provider.sortTypeTransactions('outcome');
    } else {
      displayList = Hive.box<Model_Trancaction>('transactions').values.toList();
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Фильтр операций"), centerTitle: true),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('Income'),
                _buildFilterChip('Outcome'),
                _buildFilterChip('Date'),
                _buildFilterChip('Month'),
                _buildFilterChip('Year'),
              ],
            ),
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
        },
      ),
    );
  }
}
