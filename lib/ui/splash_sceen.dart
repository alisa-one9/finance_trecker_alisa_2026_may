import 'package:finance_trecker_alisa/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../river_states/currencyProvider.dart';
import '../services/dollarApiService.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  DollarApiService dollarApiService = DollarApiService();
  double dollarCourse = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    context.read<CurrencyProvider>().fetchCurrency();
    _navigateToNext();
  }

  void _navigateToNext() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppNavigation.home,
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF6C0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 400,
              height: 400,

              child: Lottie.asset('assets/lotties/bitcoin_trade.json'),
            ),

            const SizedBox(height: 30),
            const Text(
              'Finance \nTracker',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF250739),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.indigo),
          ],
        ),
      ),
    );
  }
}
