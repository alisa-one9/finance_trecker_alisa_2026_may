import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../components/item_transaction.dart';
import '../models/model_transaction.dart';

class HomeSreen extends StatefulWidget {
  const HomeSreen({super.key});

  @override
  State<HomeSreen> createState() => _HomeSreenState();
}

class _HomeSreenState extends State<HomeSreen> {
  final Box<Model_Trancaction> transactionBox = Hive.box<Model_Trancaction>(
    'transactions',
  );

  double calculateBalance() {
    double total = 0;
    for (var item in transactionBox.values) {
      if (item.type == 'income') {
        total += item.amount;
      } else {
        total -= item.amount;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: transactionBox.listenable(),
      builder: (context, Box<Model_Trancaction> box, _) {
        final transactions = box.values.toList().reversed.toList();
        final balance = calculateBalance();

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Ваш баланс на сегодня:'),
                    Text(
                      "$balance KGS",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                  },
                ),
              ),
            ],
          ),
              onPressed: () {
              },
          ),
        );
      },
    );
  }
}
