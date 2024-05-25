import 'package:intl/intl.dart';

class HR {
  final DateTime timestamp;
  final int value;

  HR({required this.timestamp, required this.value});

  HR.fromJson(String date, Map<String, dynamic> json) :
      timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
      value = json["value"] ?? 0;
}

double getHRAVGFromDay(List<HR> dataHR) {
  if (dataHR.isEmpty) {
    return 0.0;
  }
  int sum = dataHR.map((hr) => hr.value).reduce((a, b) => a + b);
  return sum / dataHR.length;
}
