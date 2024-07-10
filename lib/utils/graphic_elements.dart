import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:simfit/providers/score_provider.dart';

class CustomPlot extends StatelessWidget {
  final Map<DateTime, Map<String, double>> scores;
  final ScoreProvider scoreProvider;

  CustomPlot({required this.scores, required this.scoreProvider});

  @override
  Widget build(BuildContext context) {
    final xValues = scores.keys
        .map((date) => date.millisecondsSinceEpoch.toDouble())
        .toList()
      ..sort();

    double minX = xValues.first;
    double maxX = xValues.last;

    // Calculate interval for the x-axis
    double? intervalX;
    if (scores.length >= 6) {
      intervalX = (maxX - minX) / 4;
    }

    double minY = double.infinity;
    double maxY = double.negativeInfinity;
    scores.values.forEach((map) {
      map.forEach((type, value) {
        if (type != 'TRIMP') {
          if (value < minY) minY = value;
          if (value > maxY) maxY = value;
        }
      });
    });
    minY = ((minY / 10).ceil() - 2) * 10.0;
    maxY = ((maxY / 10).floor() + 2) * 10.0;

    double intervalY = ((maxY.abs() + minY.abs()) / 100).ceil() * 10.toDouble();

    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: intervalX,
              getTitlesWidget: (value, meta) {
                DateTime date =
                    DateTime.fromMillisecondsSinceEpoch(value.toInt());
                if (intervalX == null) {
                  if (value == minX || value == maxX) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      angle: -pi / 5,
                      child: Text(
                        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}',
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    return Container();
                  }
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  angle: -pi / 5,
                  child: Text(
                    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: intervalY,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toInt().toString(),
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          drawVerticalLine: false,
          drawHorizontalLine: true,
          horizontalInterval: intervalY,
        ),
        borderData: FlBorderData(show: true),
        clipData:
            FlClipData(top: true, bottom: true, left: false, right: false),
        lineBarsData: [
          _buildLineChartBarData('ACL', Colors.red),
          _buildLineChartBarData('CTL', Colors.blue),
          _buildLineChartBarData('TSB', Colors.deepPurple),
        ],
        minY: minY,
        maxY: maxY,
        lineTouchData: LineTouchData(
          enabled: true,
          handleBuiltInTouches: true,
          touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
            if (event is FlTapUpEvent || event is FlLongPressEnd) {
              if (response != null && response.lineBarSpots != null) {
                final spot = response.lineBarSpots!.first;
                final DateTime date =
                    DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
                scoreProvider.setNewScoresOfDay(date, scores[date]!);
              }
            }
          },
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((touchedSpot) {
                return null;
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  LineChartBarData _buildLineChartBarData(String key, Color color) {
    return LineChartBarData(
      spots: _getSpots(key),
      isCurved: false,
      barWidth: 3,
      color: color,
      belowBarData: BarAreaData(show: false),
    );
  }

  List<FlSpot> _getSpots(String key) {
    return scores.entries
        .where((entry) => entry.value.containsKey(key))
        .map((entry) => FlSpot(
            entry.key.millisecondsSinceEpoch.toDouble(), entry.value[key]!))
        .toList()
      ..sort(
          (a, b) => a.x.compareTo(b.x)); // Ensure the spots are sorted by date
  }
}

class TRIMPDisplay extends StatelessWidget {
  final double index;

  TRIMPDisplay({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String badgeText = '';
    Color badgeColor = Colors.green;

    // Determine the badge text and color based on the TRIMP value
    if (index < 50) {
      badgeText = 'Easy';
      badgeColor = Colors.green;
    } else if (index < 120) {
      badgeText = 'Moderate';
      badgeColor = Colors.orange;
    } else if (index < 250) {
      badgeText = 'Hard';
      badgeColor = Colors.red;
    } else {
      badgeText = 'Very hard';
      badgeColor = Colors.black;
    }

    return Container(
      padding: EdgeInsets.all(5.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'TRIMP: ${double.parse((index).toStringAsFixed(2))}',
              style: TextStyle(fontSize: 18),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                badgeText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
