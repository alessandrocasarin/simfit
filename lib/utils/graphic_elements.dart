import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:simfit/models/activity.dart';
import 'package:simfit/providers/score_provider.dart';

class CustomPlot extends StatelessWidget {
  final Map<DateTime, Map<String, double>> scores;
  final ScoreProvider scoreProvider;

  CustomPlot({required this.scores, required this.scoreProvider});

  @override
  Widget build(BuildContext context) {
    // Use the first date as the reference date
    final referenceDate = scores.keys.first;

    final xValues = scores.keys
        .map((date) => date.difference(referenceDate).inDays.toDouble())
        .toList()
      ..sort();

    double minX = xValues.first;
    double maxX = xValues.last;

    // Calculate interval for the x-axis
    double? intervalX;
    if (scores.length > 2 && scores.length < 10) {
      intervalX = (maxX - minX) / (scores.length-1);
    } else if (scores.length >= 10) {
      intervalX = (maxX - minX) / 3;
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
                DateTime date = referenceDate.add(Duration(days: value.toInt()));
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
                    referenceDate.add(Duration(days: spot.x.toInt()));
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
    final referenceDate = scores.keys.first;
    return scores.entries
        .where((entry) => entry.value.containsKey(key))
        .map((entry) => FlSpot(
            entry.key.difference(referenceDate).inDays.toDouble(), entry.value[key]!))
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

class HRZoneBarChart extends StatelessWidget {
  final List<HRZone> zonesHR;

  HRZoneBarChart({required this.zonesHR});

  @override
  Widget build(BuildContext context) {
    int maxMinutes = zonesHR
        .map((zone) => zone.minutes)
        .reduce((max, minutes) => max > minutes ? max : minutes);
    double intervalY =
        (maxMinutes < 50) ? 5 : (maxMinutes.abs() / 100).ceil() * 10.toDouble();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barGroups: zonesHR.map((zone) {
          int index = zonesHR.indexOf(zone);
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: zone.minutes.toDouble(),
                color: Theme.of(context).primaryColor,
                width: 30,
                borderRadius: BorderRadius.circular(0),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      zonesHR[value.toInt()].name.replaceAll(' ', '\n'),
                      softWrap: true,
                    ));
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
                  child: (Text(value.toInt().toString())),
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
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
      ),
    );
  }
}

class PerformanceEmoji extends StatelessWidget {
  final double tsb;
  String emoji = '';

  PerformanceEmoji({super.key, required this.tsb}) {
    if (tsb < -25.0) {
      emoji = '🥵';
    } else if (tsb < -10.0) {
      emoji = '😟';
    } else if (tsb < 5.0) {
      emoji = '😐';
    } else if (tsb < 20.0) {
      emoji = '😊';
    } else {
      emoji = '🤩';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      emoji,
      style: TextStyle(
        fontSize: 24,
        color: Colors.deepPurple,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
