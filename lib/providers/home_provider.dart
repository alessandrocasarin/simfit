import 'package:flutter/material.dart';
import 'package:simfit/models/activity.dart';
import 'package:simfit/models/calories.dart';
import 'package:simfit/models/sleep.dart';
import 'package:simfit/models/steps.dart';
import 'package:simfit/server/impact.dart';

class HomeProvider extends ChangeNotifier {
  List<Steps> dailySteps = [];
  int totDailySteps = 0;
  List<Calories> dailyCalories = [];
  int totDailyCalories = 0;
  List<Sleep> dailySleep = [];
  Duration mainDailySleep = const Duration(hours: 0, minutes: 0);
  int dailyRestHR = 0;
  List<Activity> dailyActivities = [];

  bool dataReady = false;

  final Impact impact = Impact();

  void getDataOfDay(DateTime showDate) async {
    _loading();

    dailySteps = await impact.getStepsFromDay(showDate);
    totDailySteps = getTotalStepsFromDay(dailySteps);

    dailyCalories = await impact.getCaloriesFromDay(showDate);
    totDailyCalories = getTotalCaloriesFromDay(dailyCalories).toInt();

    dailySleep = await impact.getSleepsFromDay(showDate);
    mainDailySleep = getMainSleepFromDay(dailySleep);

    dailyRestHR = (await impact.getRestHRFromDay(showDate)).toInt();

    dailyActivities = await impact.getActivitiesFromDay(showDate);

    dataReady = true;
    _notifyListeners();
  }

  void _loading() {
    dailySteps = [];
    totDailySteps = 0;
    dailyCalories = [];
    totDailyCalories = 0;
    dailySleep = [];
    mainDailySleep = Duration(hours: 0, minutes: 0);
    dailyRestHR = 0;
    dailyActivities = [];

    dataReady = false;
    _notifyListeners();
  }

  void _notifyListeners() {
    Future.microtask(() => notifyListeners());
  }
}
