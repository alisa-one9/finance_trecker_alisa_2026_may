import 'package:flutter/material.dart';

import '../models/model_transaction.dart';
import 'category_icon.dart';

class ItemTransaction extends StatelessWidget {
  final Model_Trancaction transaction;

  ItemTransaction({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    bool isIncome = transaction.type == 'income';
    String textDollarsSum = transaction.dollarSum.toStringAsFixed(2);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFBDE1F4),
        borderRadius: BorderRadius.circular(20),
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
            child: CategoryIcon(categoryName: transaction.category),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${isIncome ? '+' : '-'} ${transaction.amount} KGS",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${isIncome ? '+' : '-'} ${textDollarsSum} USD",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan,
                  ),
                ),
                Text(
                  transaction.category,
                  style: const TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  transaction.comment,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "${transaction.date.day}/${transaction.date.month.toString().padLeft(2, '0')}/${transaction.date.year}",
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
