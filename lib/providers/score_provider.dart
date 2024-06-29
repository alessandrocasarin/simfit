import 'package:flutter/material.dart';

class ScoreProvider extends ChangeNotifier {

  DateTime day;
  Map<String, double> scoresOfDay;

  ScoreProvider({required this.day, required this.scoresOfDay});

  void setNewScoresOfDay(DateTime newDay, Map<String, double> scoresOfNewDay) {
    day = newDay;
    scoresOfDay = scoresOfNewDay;
    notifyListeners();
  }
}
