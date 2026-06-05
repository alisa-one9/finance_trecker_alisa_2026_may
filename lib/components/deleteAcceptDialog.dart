import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../models/model_transaction.dart';
import '../river_states/local_sum_provider.dart';

final Box<Model_Trancaction> transactionBox = Hive.box<Model_Trancaction>(
  'transactions',
);
Future<void> deleteAcceptDialog({
  required BuildContext context,
  required Model_Trancaction modelTrancaction,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Are you sure to delete this transaction?'),

        actions: <Widget>[
          TextButton(
            child: const Text(
              'No',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              context.pop();
            },
          ),
          TextButton(
            child: const Text(
              'Yes',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () async {
              await modelTrancaction.delete();
              Provider.of<LocalSumProvider>(context, listen: false).refresh();
              context.pop();
            },
          ),
        ],
      );
    },
  );
}
