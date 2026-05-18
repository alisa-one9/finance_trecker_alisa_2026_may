import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final sumProvider = context.watch<LocalSumProvider>();
    final real_balance = sumProvider.real_totalBalance;

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
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Ваш  баланс:'),
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
              if (transactions.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: Text("No transactions yet")),
                )
              else
                SliverList.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        clipBehavior: Clip.antiAlias,
                        elevation: 1,
                        child: InkWell(
                          splashColor: Colors.cyanAccent.withOpacity(0.1),
                          highlightColor: Colors.cyanAccent.withOpacity(0.7),
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
          floatingActionButton: Container(
            height: 60,
            width: 60,
            decoration: const BoxDecoration(
              gradient: myGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: const Icon(Icons.add, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pushNamed(context, '/add_operation');
              },
            ),
          ),
        );
      },
    );
  }
}
