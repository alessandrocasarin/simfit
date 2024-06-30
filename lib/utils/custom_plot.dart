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
    if (scores.length < 6 && scores.length > 2) {
      intervalX = (maxX - minX) / (scores.length);
    } else if (scores.length >= 6) {
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

    final legendItems = {
      'ACL': Colors.red,
      'CTL': Colors.blue,
      'TSB': Colors.green,
    };

    return Stack(
      children: [
        LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
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
                            '${date.day}/${date.month}',
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
                        '${date.day}/${date.month}',
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
                  reservedSize: 40,
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
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: true),
            clipData:
                FlClipData(top: true, bottom: true, left: false, right: false),
            lineBarsData: [
              _buildLineChartBarData('ACL', Colors.red),
              _buildLineChartBarData('CTL', Colors.blue),
              _buildLineChartBarData('TSB', Colors.green),
            ],
            minY: minY,
            maxY: maxY,
            lineTouchData: LineTouchData(
                enabled: true,
                handleBuiltInTouches: true,
                touchCallback:
                    (FlTouchEvent event, LineTouchResponse? response) {
                  if (event is FlTapUpEvent) {
                    if (response != null && response.lineBarSpots != null) {
                      final spot = response.lineBarSpots!.first;
                      final DateTime date =
                          DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
                      scoreProvider.setNewScoresOfDay(date, scores[date]!);
                    }
                  }
                },
                touchTooltipData:
                    LineTouchTooltipData(getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((touchedSpot) {
                    return null;
                  }).toList();
                })),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ChartLegend(legendItems: legendItems),
        ),
      ],
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

class ChartLegend extends StatelessWidget {
  final Map<String, Color> legendItems;

  ChartLegend({required this.legendItems});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: legendItems.entries.map((entry) {
        return Row(
          children: [
            Container(
              width: 12,
              height: 12,
              color: entry.value,
              margin: EdgeInsets.only(right: 4),
            ),
            Text(entry.key),
            SizedBox(width: 8),
          ],
        );
      }).toList(),
    );
  }
}
