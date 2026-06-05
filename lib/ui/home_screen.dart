import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../components/deleteAcceptDialog.dart';
import '../components/item_transaction.dart';
import '../components/myGradient.dart';
import '../models/model_transaction.dart';
import '../river_states/currencyProvider.dart';
import '../river_states/local_sum_provider.dart';

class HomeSreen extends StatefulWidget {
  const HomeSreen({super.key});
  @override
  State<HomeSreen> createState() => _HomeSreenState();
}

class _HomeSreenState extends State<HomeSreen> {
  final Box<Model_Trancaction> transactionBox = Hive.box<Model_Trancaction>(
    'transactions',
  );
  final Box<Model_Trancaction> historyBox = Hive.box<Model_Trancaction>(
    'history',
  );

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CurrencyProvider>().fetchCurrency());
  }

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

  Map<String, double> getIncomeData() {
    Map<String, double> result = {};
    for (var tx in historyBox.values) {
      if (tx.type == 'income') {
        result.update(
          tx.category,
          (value) => value + tx.amount,
          ifAbsent: () => tx.amount,
        );
      }
    }
    return result;
  }

  Map<String, double> getExpenseData() {
    Map<String, double> result = {};
    for (var tx in historyBox.values) {
      if (tx.type == 'outcome') {
        result.update(
          tx.category,
          (value) => value + tx.amount,
          ifAbsent: () => tx.amount,
        );
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final sumProvider = context.watch<LocalSumProvider>();
    final currencyProvider = context.watch<CurrencyProvider>();
    final real_balance = sumProvider.real_totalBalance;
    final usd_balance = currencyProvider.convertToUsd(real_balance);

    return ValueListenableBuilder(
      valueListenable: transactionBox.listenable(),
      builder: (context, Box<Model_Trancaction> box, _) {
        final transactions = box.values.toList().reversed.toList();
        return Scaffold(
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 120.0,
                floating: false,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text("My Wallet"),
                  centerTitle: true,
                  background: Container(
                    decoration: const BoxDecoration(gradient: myGradient),
                  ),
                ),
                iconTheme: const IconThemeData(color: Colors.white),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: myGradient,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "TOTAL BALANCE",
                              style: TextStyle(
                                color: Colors.white70,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "${real_balance.toStringAsFixed(2)} KGS",
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "~~ ${usd_balance.toStringAsFixed(2)} USD",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.tealAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                context.push('/add_operation');
                              },
                              child: const Text("ADD"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                context.push('/history_page');
                              },
                              child: const Text("VIEW REPORTS"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 220,
                              child: Column(
                                children: [
                                  const Text(
                                    "Доходы",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Expanded(
                                    child: buildPieChart(getIncomeData(), [
                                      Colors.green,
                                      Colors.blue,
                                      Colors.orange,
                                      Colors.purple,
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Expanded(
                            child: SizedBox(
                              height: 220,
                              child: Column(
                                children: [
                                  const Text(
                                    "Расходы",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Expanded(
                                    child: buildPieChart(getExpenseData(), [
                                      Colors.red,
                                      Colors.orange,
                                      Colors.pink,
                                      Colors.brown,
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Последние операции",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (transactions.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: Text("No transactions yet")),
                )
              else
                SliverList.builder(
                  itemCount: transactions.length > 5 ? 5 : transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8.0,
                      ),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        clipBehavior: Clip.antiAlias,
                        elevation: 1,
                        child: InkWell(
                          splashColor: Colors.deepPurple,
                          highlightColor: Colors.redAccent,

                          onTap: () {
                            deleteAcceptDialog(
                              context: context,
                              modelTrancaction: tx,
                            );
                          },
                          child: ItemTransaction(transaction: tx),
                        ),
                      ),
                    );
                  },
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        );
      },
    );
  }

  Widget buildPieChart(Map<String, double> data, List<Color> colors) {
    if (data.isEmpty) {
      return PieChart(
        PieChartData(
          centerSpaceRadius: 25,
          sectionsSpace: 0,
          sections: [
            PieChartSectionData(
              value: 1,
              color: Colors.grey.shade300,
              radius: 40,
              title: '',
            ),
          ],
        ),
      );
    }
    double total = data.values.fold(0, (sum, item) => sum + item);
    int colorIndex = 0;

    return PieChart(
      PieChartData(
        centerSpaceRadius: 25,
        sectionsSpace: 2,
        sections:
            data.entries.map((entry) {
              final color = colors[colorIndex % colors.length];
              colorIndex++;
              double percentage = (entry.value / total) * 100;
              return PieChartSectionData(
                value: entry.value,
                color: color,
                radius: 60,
                title: '${entry.key}\n${percentage.toStringAsFixed(0)}%',
                titleStyle: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 2)],
                ),
                titlePositionPercentageOffset: 0.6,
              );
            }).toList(),
      ),
    );
  }
}
