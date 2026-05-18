import 'package:finance_trecker_alisa/components/myGradient.dart';
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

    final box = Hive.box<Model_Trancaction>('history');
    final transactions = box.values.toList();

    List<FlSpot> incomeSpots = [];
    List<FlSpot> outcomeSpots = [];
    List<FlSpot> balanceSpots = [];

    double runningBalance = 0;
    // начальный баланс: все средства за последние 30 дней
    DateTime tenDaysAgo = DateTime.now().subtract(const Duration(days: 10));
    for (var tx in transactions) {
      if (tx.date.isBefore(tenDaysAgo)) {
        runningBalance += (tx.type == 'income' ? tx.amount : -tx.amount);
      }
    }
    //считывание  -/+   за 30 дней
    for (int i = 30; i >= 0; i--) {
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
      double x = (30 - i).toDouble();
      //добавим точки (одну точку  в день)
      incomeSpots.add(FlSpot(x, dayIncome));
      outcomeSpots.add(FlSpot(x, dayOutcome));
      balanceSpots.add(FlSpot(x, runningBalance));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Статистика"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: myGradient),
        ),
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
                "Доходы и Расходы за 30 дней",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 40),
                child: SizedBox(
                  height: 300,
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
              const SizedBox(height: 20),
              const Text(
                "Баланс за 30 дней",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  height: 300,
                  child: LineChart(
                    _baseChartData([
                      _lineData(balanceSpots, Colors.indigo, isBold: true),
                    ]),
                  ),
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

      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),

        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 60,
            interval: _calculateInterval(lines),
            getTitlesWidget: (value, meta) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  _formatYAxis(value),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ),
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

  String _formatYAxis(double value) {
    String formatNumber(double number, String suffix) {
      if (number % 1 == 0) {
        return '${number.toInt()}$suffix';
      }
      return '${number.toStringAsFixed(1)}$suffix';
    }

    // Миллиарды
    if (value >= 1000000000) {
      return formatNumber(value / 1000000000, 'B');
    }
    // Миллионы
    if (value >= 1000000) {
      return formatNumber(value / 1000000, 'M');
    }
    // Тысячи
    if (value >= 1000) {
      return formatNumber(value / 1000, 'K');
    }
    // Обычные числа
    return value.toInt().toString();
  }

  double _calculateMaxY(List<LineChartBarData> lines) {
    double max = 0;
    for (var line in lines) {
      for (var spot in line.spots) {
        if (spot.y > max) {
          max = spot.y;
        }
      }
    }
    return max * 1.2;
  }

  double _calculateInterval(List<LineChartBarData> lines) {
    double max = _calculateMaxY(lines);
    return max / 5;
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
      belowBarData: BarAreaData(show: isBold, color: color.withValues()),
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
