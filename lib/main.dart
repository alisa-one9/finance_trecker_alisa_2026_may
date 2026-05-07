import 'package:finance_trecker_alisa/river_states/currencyProvider.dart';
import 'package:finance_trecker_alisa/river_states/local_sum_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'app_navigation.dart';
import 'models/model_transaction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Hive.initFlutter();
    Hive.registerAdapter(ModelTrancactionAdapter());
    await Hive.openBox<Model_Trancaction>('transactions');
    await Hive.openBox<Model_Trancaction>('history');
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocalSumProvider()),
          ChangeNotifierProvider(create: (_) => CurrencyProvider()),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    print("Initialization Error: $e");
    runApp(
      MaterialApp(
        home: Scaffold(body: Center(child: Text("Restart the App please! $e"))),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppNavigation.splash,
      onGenerateRoute: AppNavigation.generateRoute,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
