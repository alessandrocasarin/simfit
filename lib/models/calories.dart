import 'package:intl/intl.dart';

class Calories {
  final DateTime timestamp;
  final double value;

  Calories({required this.timestamp, required this.value});

  Calories.fromJson(String date, Map<String, dynamic> json) :
      timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
      value = json["value"] ?? 0.0;
}

double getTotalCaloriesFromDay(List<Calories> dataCals) {
  if (dataCals.isEmpty) {
    return 0.0;
  }
  return dataCals.map((cals) => cals.value).reduce((a, b) => a + b);
}