import 'package:intl/intl.dart';

class HR {
  final DateTime timestamp;
  final int value;

  HR({required this.timestamp, required this.value});

  HR.fromJson(String date, Map<String, dynamic> json) :
      timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
      value = json["value"] ?? 0;
}

Map<String, dynamic> getHRStatisticsFromDay(List<HR> dataHR) {
  if (dataHR.isEmpty) {
    return {};
  }

  dynamic avg = dataHR.map((hr) => hr.value).reduce((a, b) => (a + b)) / dataHR.length;
  int min = dataHR.map((hr) => hr.value).reduce((a, b) => a < b ? a : b);
  int max = dataHR.map((hr) => hr.value).reduce((a, b) => a > b ? a : b);

  return {
    'avg': avg,
    'min': min,
    'max': max,
  };
}
