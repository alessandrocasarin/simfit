import 'package:intl/intl.dart';

class Activity {
  final String activityName;
  final int avgHR;
  final int calories;
  final double distance;
  final Duration duration;
  final int steps;
  final List<HRZone> zonesHR;
  final double avgSpeed;
  final double vo2Max;
  final double elevationGain;
  final DateTime startingTime;

  Activity({
    required this.activityName,
    required this.avgHR,
    required this.calories,
    required this.distance,
    required this.duration,
    required this.steps,
    required this.zonesHR,
    required this.avgSpeed,
    required this.vo2Max,
    required this.elevationGain,
    required this.startingTime,
  });

  Activity.fromJson(String date, Map<String, dynamic> json) :
      activityName = json["activityName"] ?? '',
      avgHR = (json["averageHeartRate"] ?? 0).toInt(),
      calories = (json["calories"] ?? 0).toInt(),
      distance = (json["distance"] ?? 0).toDouble(),
      duration = Duration(milliseconds: (json["duration"] ?? 0).toInt()),
      steps = (json["steps"] ?? 0).toInt(),
      zonesHR = List<HRZone>.from(json["heartRateZones"].map((zone) => HRZone.fromJson(zone))),
      avgSpeed = (json["speed"] ?? 0).toDouble(),
      vo2Max = (json["vo2Max"]?["vo2Max"] ?? 0.0).toDouble(),
      elevationGain = (json["elevationGain"] ?? 0).toDouble(),
      startingTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}');
     
}

class HRZone {
  final String name;
  final int minHR;
  final int maxHR;
  final int minutes;

  HRZone({
    required this.name,
    required this.minHR,
    required this.maxHR,
    required this.minutes,
  });

  HRZone.fromJson(Map<String, dynamic> json) :
      name = json["name"] ?? '',
      minHR = (json["min"] ?? 0).toInt(),
      maxHR = (json["max"] ?? 0).toInt(),
      minutes = (json["minutes"] ?? 0).toInt();
}