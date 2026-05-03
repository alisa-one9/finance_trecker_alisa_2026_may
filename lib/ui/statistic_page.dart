import 'package:finance_trecker_alisa/models/model_transaction.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../river_states/local_sum_provider.dart';

class StatisticPage extends StatelessWidget {
  const StatisticPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<LocalSumProvider>();

    final box = Hive.box<Model_Trancaction>('transactions');
    final transactions = box.values.toList();

    List<FlSpot> incomeSpots = [];
    List<FlSpot> outcomeSpots = [];
    List<FlSpot> balanceSpots = [];

    double runningBalance = 0;
    DateTime tenDaysAgo = DateTime.now().subtract(const Duration(days: 10));
    for (var tx in transactions) {
      if (tx.date.isBefore(tenDaysAgo)) {
        runningBalance += (tx.type == 'income' ? tx.amount : -tx.amount);
      }
    }
      DateTime date = DateTime.now().subtract(Duration(days: i));

      double dayIncome = 0;
      double dayOutcome = 0;
      //Суммируем все транзакции за текущий конкретный день
      for (var tx in transactions) {
        if (tx.date.day == date.day &&
            tx.date.month == date.month &&
            tx.date.year == date.year) {
          if (tx.type == 'income') {
            dayIncome += tx.amount; //копим сумму доходов за день
          } else if (tx.type == 'outcome') {
            dayOutcome += tx.amount; //копим сумму расх за день
          }
        }
      }
      //Выясним общий текущий баланс
      // ПОСЛЕ проверки всех транзакций за день:
      runningBalance += (dayIncome - dayOutcome);
      //добавим точки (одну точку  в день)
      incomeSpots.add(FlSpot(x, dayIncome));
      outcomeSpots.add(FlSpot(x, dayOutcome));
      balanceSpots.add(FlSpot(x, runningBalance));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Статистика"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),

        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 40),
                child: SizedBox(
                  height: 260,
                  child: LineChart(
                    _baseChartData([
                      _lineData(incomeSpots, Colors.green),
                      _lineData(outcomeSpots, Colors.red),
                    ]),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              _buildLegend([
                _legendItem("Income", Colors.green),
                _legendItem("Outcome", Colors.red),
              ]),
              const SizedBox(height: 40),
              const Text(
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: LineChart(
                  _baseChartData([
                    _lineData(balanceSpots, Colors.indigo, isBold: true),
                  ]),
                ),
              ),
              const SizedBox(height: 10),
              _buildLegend([_legendItem("Total Balance", Colors.indigo)]),
            ],
          ),
        ),
      ),
    );
  }

  LineChartData _baseChartData(List<LineChartBarData> lines) {
    return LineChartData(
      gridData: const FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: true,
      ),
      titlesData: const FlTitlesData(
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.black12),
          left: BorderSide(color: Colors.black12),
        ),
      ),
      lineBarsData: lines,
    );
  }

  LineChartBarData _lineData(
    List<FlSpot> spots,
    Color color, {
    bool isBold = false,
  }) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: isBold ? 4 : 2,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(show: isBold, color: color.withOpacity(0.1)),
    );
  }

  Widget _buildLegend(List<Widget> items) {
    return Wrap(spacing: 20, children: items);
  }

  Widget _legendItem(String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
