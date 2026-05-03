import 'package:finance_trecker_alisa/river_states/local_sum_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'app_navigation.dart';
import 'models/model_transaction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ModelTrancactionAdapter());
  await Hive.openBox<Model_Trancaction>('transactions');

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LocalSumProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppNavigation.home,
      onGenerateRoute: AppNavigation.generateRoute,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
