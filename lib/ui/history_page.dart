import 'package:finance_trecker_alisa/components/item_transaction.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../components/myGradient.dart';
import '../models/model_transaction.dart';
import '../river_states/local_sum_provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<StatefulWidget> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Builder(
        builder: (context) {
          try {
            if (!Hive.isBoxOpen('history')) {
              return const Center(
                child: Text("Box 'history' is NOT OPEN.\nCheck main.dart"),
              );
            }
            final historyBox = Hive.box<Model_Trancaction>('history');
            return ValueListenableBuilder(
              valueListenable: historyBox.listenable(),
              builder: (context, Box<Model_Trancaction> box, _) {
                final hisTransactions = box.values.toList().reversed.toList();
                final sumProvider = context.watch<LocalSumProvider>();
                final real_balance = sumProvider.real_totalBalance;

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 120.0,
                      pinned: true,
                      backgroundColor: Colors.indigo,
                      flexibleSpace: FlexibleSpaceBar(
                        title: const Text("Permanent History"),
                        centerTitle: true,
                        background: Container(
                          decoration: const BoxDecoration(gradient: myGradient),
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Text('Ваш постоянный баланс:'),
                            Text(
                              "${real_balance.toStringAsFixed(2)} KGS",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(height: 10),
                          ],
                        ),
                      ),
                    ),
                    hisTransactions.isEmpty
                        ? const SliverFillRemaining(
                          child: Center(child: Text("No transactions yet")),
                        )
                        : SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final tx = hisTransactions[index];
                            return Column(
                              children: [
                                ItemTransaction(transaction: tx),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 20,
                                    bottom: 10,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "Wallet :  ${tx.balanceAtPoint?.toStringAsFixed(2) ?? '0.00'} KGS",
                                      style: const TextStyle(
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),

                                const Divider(indent: 20, endIndent: 20),
                              ],
                            );
                          }, childCount: hisTransactions.length),
                        ),

                    const SliverToBoxAdapter(child: SizedBox(height: 80)),
                  ],
                );
              },
            );
          } catch (e) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Fatal Error: $e",
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
