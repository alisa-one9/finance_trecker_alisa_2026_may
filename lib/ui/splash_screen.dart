import 'package:finance_trecker_alisa/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() {
    Future.delayed(const Duration(seconds: 2), () {
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
