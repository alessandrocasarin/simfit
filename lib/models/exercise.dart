class Exercise {
  final String activityName;
  final int avgHR;
  final int calories;
  final double distance;
  final double duration;
  final double activeDuration;
  final int steps;
  final List<HRZone> zonesHR;
  final double avgSpeed;
  final double vo2Max;
  final double elevationGain;
  final DateTime startingTime;

  Exercise({
    required this.activityName,
    required this.avgHR,
    required this.calories,
    required this.distance,
    required this.duration,
    required this.activeDuration,
    required this.steps,
    required this.zonesHR,
    required this.avgSpeed,
    required this.vo2Max,
    required this.elevationGain,
    required this.startingTime,
  });
}

class HRZone {
  final String name;
  final int min;
  final int max;
  final int minutes;
  final double caloriesOut;

  HRZone({
    required this.name,
    required this.min,
    required this.max,
    required this.minutes,
    required this.caloriesOut,
  });

  factory HRZone.fromJson(Map<String, dynamic> json) {
    return HRZone(
      name: json['name'] is List ? json['name'] : json['name'] ?? '',
      min: json['min'] ?? 0,
      max: json['max'] ?? 0,
      minutes: json['minutes'] ?? 0,
      caloriesOut: json['caloriesOut'] ?? 0.0,
    );
  }
}
