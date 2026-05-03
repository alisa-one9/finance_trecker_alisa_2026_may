import 'package:flutter/material.dart';

import '../models/model_transaction.dart';

class ItemTransaction extends StatelessWidget {
  final Model_Trancaction transaction;

  ItemTransaction({super.key, required this.transaction});

  Widget _getCategoryIcon(String categoryName) {
    switch (categoryName) {
      case 'Food':
        return const Icon(Icons.fastfood_outlined, color: Colors.red);
      case 'Transport':
        return const Icon(
          Icons.emoji_transportation_outlined,
          color: Colors.red,
        );
      case 'Hobby/Fun':
        return const Icon(Icons.sports_football_sharp, color: Colors.red);
      case 'Salary':
        return const Icon(Icons.currency_bitcoin_sharp, color: Colors.green);
      case 'Gift':
        return const Icon(Icons.card_giftcard_sharp, color: Colors.green);
      case 'Bonus':
        return const Icon(Icons.star, color: Colors.green);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isIncome = transaction.type == 'income';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isIncome ? Colors.green : Colors.red,
                width: 2,
              ),
            ),
            child: _getCategoryIcon(transaction.category),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${isIncome ? '+' : '-'} ${transaction.amount} KGS",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  transaction.category,
                ),
                Text(
                  transaction.comment,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
