import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CustomPlot extends StatelessWidget {
  final Map<DateTime, Map<String, double>> scores;

  CustomPlot({required this.scores});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                DateTime date =
                    DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return Text('${date.day}/${date.month}');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: true),
        clipData:
            FlClipData(top: true, bottom: true, left: false, right: false),
        lineBarsData: [
          LineChartBarData(
            spots: _getSpots('ACL'),
            isCurved: false,
            barWidth: 3,
            color: Colors.red,
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: _getSpots('CTL'),
            isCurved: false,
            barWidth: 3,
            color: Colors.blue,
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _getSpots(String key) {
    List<FlSpot> spots = [];
    scores.forEach((date, scores) {
      final timestamp = date.millisecondsSinceEpoch.toDouble();
      if (scores.containsKey(key)) {
        spots.add(FlSpot(timestamp, scores[key]!));
      }
    });
    spots.sort(
        (a, b) => a.x.compareTo(b.x)); // Ensure the spots are sorted by date
    return spots;
  }
}
