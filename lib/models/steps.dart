import 'package:intl/intl.dart';

class Steps {
  final DateTime timestamp;
  final int value;

  Steps({required this.timestamp, required this.value});

  Steps.fromJson(String date, Map<String, dynamic> json) :
      timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
      value = (json["value"] ?? 0).toInt();
}

int getTotalStepsFromDay(List<Steps> dataSteps) {
  if (dataSteps.isEmpty) {
    return 0;
  }
  return dataSteps.map((steps) => steps.value).reduce((a, b) => a + b);
}