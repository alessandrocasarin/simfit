import 'package:intl/intl.dart';

class Sleep {
  final DateTime day;
  final Duration duration;
  final int efficiency;
  final bool mainSleep;

  Sleep({required this.day, required this.duration, required this.efficiency, required this.mainSleep});

  Sleep.fromJson(String date, Map<String, dynamic> json) :
      day = DateFormat('yyyy-MM-dd').parse(date),
      duration = Duration(milliseconds: json["duration"] ?? 0),
      efficiency = json["efficiency"] ?? 0,
      mainSleep = json["mainSleep"] ?? false;
}