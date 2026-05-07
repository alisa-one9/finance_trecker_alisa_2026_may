import 'package:finance_trecker_alisa/components/myText.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../components/myGradient.dart';
import '../components/my_textfield.dart';
import '../models/model_category.dart';
import '../models/model_transaction.dart';
import '../river_states/currencyProvider.dart';
import '../river_states/local_sum_provider.dart';

class AddOperation extends StatefulWidget {
  const AddOperation({super.key});

  @override
  State<AddOperation> createState() => _AddOperationState();
}

class _AddOperationState extends State<AddOperation> {
  final TextEditingController _sumController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  late List<Model_category> redCategories;
  late List<Model_category> greenCategories;

  String _selectedType = 'income';
  String _selectedCategory = '';

  @override
  void initState() {
    super.initState();
    _sumController.text = "";
    _commentController.text = "";
    redCategories = Model_category.getRedCategories();
    greenCategories = Model_category.getGreenCategories();
    _sumController.addListener(() {
      setState(() {});
    });
  }

  void makeTransaction() {
    final double? enteredAmount = double.tryParse(_sumController.text);
    final sumProvider = Provider.of<LocalSumProvider>(context, listen: false);
    final currencyProv = Provider.of<CurrencyProvider>(context, listen: false);
    if (_selectedCategory == '') {
      _showSnackBar('Категория не выбрана!');
      return;
    }
    if (enteredAmount == null || enteredAmount <= 0) {
      _showSnackBar('Введите сумму транзакции!');
      return;
    }

    double finalTodayUsd = currencyProv.convertToUsd(enteredAmount);
    double newBalance =
        sumProvider.real_totalBalance +
        (_selectedType == 'income' ? enteredAmount : -enteredAmount);

    final transactionForList = Model_Trancaction(
      id: Uuid().v4(),
      type: _selectedType,
      amount: enteredAmount,
      category: _selectedCategory,
      date: DateTime.now(),
      comment: _commentController.text,
      dollarSum: finalTodayUsd,
      balanceAtPoint: newBalance,
    );
    final transactionForHistory = Model_Trancaction(
      id: transactionForList.id, // Same ID
      type: transactionForList.type,
      amount: transactionForList.amount,
      category: transactionForList.category,
      date: transactionForList.date,
      comment: transactionForList.comment,
      dollarSum: transactionForList.dollarSum,
      balanceAtPoint: transactionForList.balanceAtPoint,
    );

    Hive.box<Model_Trancaction>('transactions').add(transactionForList);
    Hive.box<Model_Trancaction>('history').add(transactionForHistory);

    sumProvider.refresh();
    Navigator.pop(context);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildFilterChip(String label, String type) {
    final bool isSelected = _selectedType == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor:
          type == 'income' ? Colors.green.shade100 : Colors.red.shade100,
      onSelected: (bool selected) {
        if (selected) {
          setState(() => _selectedType = type);
        }
      },
    );
  }

  Widget _buildCategoryList(List<Model_category> categories, Color themeColor) {
    return SizedBox(
      height: 85,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final item = categories[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                for (var c in redCategories) {
                  c.isSelected = false;
                }
                for (var c in greenCategories) {
                  c.isSelected = false;
                }
                item.isSelected = true;
                _selectedCategory = item.name;
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
                            ? themeColor.withValues()
                            : Colors.white,
                    border: Border.all(
                      color: themeColor,
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

  @override
  void dispose() {
    _sumController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyProv = context.watch<CurrencyProvider>();
    final sumProvider = context.watch<LocalSumProvider>();

    double kgs = double.tryParse(_sumController.text) ?? 0.0;
    double displayUsd = currencyProv.convertToUsd(kgs);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "USD currency: ${currencyProv.dollarCourse.toStringAsFixed(2)} KGS",
          style: TextStyle(fontSize: 14),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: myGradient),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Доступный баланс: ${sumProvider.real_totalBalance} KGS',
              style: const TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterChip('Доход', 'income'),
                const SizedBox(width: 10),
                _buildFilterChip('Расход', 'outcome'),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                const Text('KGS', style: TextStyle(fontSize: 14)),
                Expanded(
                  child: MyTextField(
                    hintText: '0.00',
                    controller: _sumController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text('USD', style: TextStyle(fontSize: 14)),
                Expanded(
                  child: MyText(
                    text: displayUsd.toStringAsFixed(2),
                    textColor: Colors.cyan,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            MyTextField(
              hintText:
                  _selectedType == 'income'
                      ? 'Источник дохода'
                      : 'На что потратили?',
              controller: _commentController,
            ),

            const SizedBox(height: 30),
            Text(
              "Выберите категорию",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _selectedType == 'income'
                ? _buildCategoryList(greenCategories, Colors.green)
                : _buildCategoryList(redCategories, Colors.red),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                  gradient: myGradient,
                  borderRadius: BorderRadius.circular(30),
                ),

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  onPressed: makeTransaction,
                  child: const Text(
                    "СОХРАНИТЬ",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
