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
      avgHR = json["averageHeartRate"] ?? 0,
      calories = json["calories"] ?? 0,
      distance = (json["distance"] ?? 0).toDouble(),
      duration = Duration(milliseconds: json['duration'] ?? 0),
      steps = json["steps"] ?? 0,
      zonesHR = List<HRZone>.from(json["heartRateZones"].map((zone) => HRZone.fromJson(zone))),
      avgSpeed = (json["speed"] ?? 0).toDouble(),
      vo2Max = json["vo2Max"]?["vo2Max"]?.toDouble() ?? 0.0,
      elevationGain = (json["elevationGain"] ?? 0).toDouble(),
      startingTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}');
     
}

class HRZone {
  final String name;
  final int minHR;
  final int maxHR;
  final int minutes;
  final double caloriesOut;

  HRZone({
    required this.name,
    required this.minHR,
    required this.maxHR,
    required this.minutes,
    required this.caloriesOut,
  });

  HRZone.fromJson(Map<String, dynamic> json) :
      name = json["name"] ?? '',
      minHR = json["min"] ?? 0,
      maxHR = json["max"] ?? 0,
      minutes = json["minutes"] ?? 0,
      caloriesOut = (json["caloriesOut"] is int)
          ? (json["caloriesOut"] as int).toDouble()
          : (json["caloriesOut"] ?? 0.0);
}