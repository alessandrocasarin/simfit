import 'package:flutter/material.dart';
import 'package:simfit/models/activity.dart';
import 'package:simfit/utils/algorithm.dart';

class SimulationProvider extends ChangeNotifier {
  DateTime simDate = DateUtils.dateOnly(DateTime.now());
  Map<String, double> simulatedScores = {};

  final Map<DateTime, Map<String, double>> scores;
  final Algorithm algorithm;

  SimulationProvider({required this.scores, required this.algorithm});

  void computeSimulatedScores(List<Activity> simActivities) async {
    _loading(); // method to give a loading ui feedback to the user
    await Future.delayed(
      const Duration(seconds: 1),
    ); // faking time required to get compute scores

    simulatedScores = algorithm.computeScoresOfNewDay(simDate, simActivities, scores);
    
    notifyListeners();
  }

  void _loading() {
    simulatedScores.clear();
    notifyListeners();
  }
}
