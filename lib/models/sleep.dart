import 'package:intl/intl.dart';

class Sleep {
  final DateTime day;
  final Duration duration;
  final int efficiency;
  final bool mainSleep;

  Sleep(
      {required this.day,
      required this.duration,
      required this.efficiency,
      required this.mainSleep});

  Sleep.fromJson(String date, Map<String, dynamic> json)
      : day = DateFormat('yyyy-MM-dd').parse(date),
        duration = Duration(milliseconds: (json["duration"] ?? 0).toInt()),
        efficiency = (json["efficiency"] ?? 0).toInt(),
        mainSleep = json["mainSleep"] ?? false;
}

Duration getMainSleepFromDay(List<Sleep> dataSleep) {
  if (dataSleep.isEmpty) {
    return const Duration(hours: 0, minutes: 0);
  }
  for (var sleep in dataSleep) {
    if (sleep.mainSleep) {
      return sleep.duration;
    }
  }
  return const Duration(hours: 0, minutes: 0);
}
