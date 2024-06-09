import 'dart:math';
import 'package:flutter/material.dart';
import 'package:simfit/models/activity.dart';

class Algorithm {
  late double genderConst;
  late double maxHR;
  late double restHR;
  late int mesocycleLength;
  late int daysFromStart;

  Algorithm({required String gender, required int age, required double rHR, required int mesoLen, required int daysFromMesoStart}) {
    genderConst = (gender == 'female') ? 1.67 : 1.92;
    maxHR = (220-age).toDouble();
    restHR = rHR;
    mesocycleLength = mesoLen;
    daysFromStart = daysFromMesoStart;
  }

  double computeTRIMP(List<Activity> activities) {
    if (activities.isEmpty) return 0.0;
    
    double trimpTot = 0.0;

    for (Activity currentActivity in activities) {
      double percHRR = (currentActivity.avgHR - restHR) / (maxHR - restHR);
      double y = 0.64 * pow(e, genderConst * percHRR);
      double currentTrimp = currentActivity.duration.inMinutes * percHRR * y;
      trimpTot += currentTrimp;
    }
    return trimpTot;
  }

  Map<DateTime, Map<String, double>> computeScoresOfMesocycle(DateTime day, Map<DateTime, List<Activity>> activityList) {
    Map<DateTime, Map<String, double>> scores = {};
    
    for (var i = 0; i < daysFromStart; i++) {
      DateTime currentDay = DateUtils.dateOnly(day.subtract(Duration(days:i)));
      scores[currentDay] ??= {};
      scores[currentDay]?['TRIMP'] = computeTRIMP(activityList[currentDay] ?? []);
    }

    for (var i = 0; i < daysFromStart; i++) {
      DateTime currentDay = DateUtils.dateOnly(day.subtract(Duration(days:i)));
      // computing Acute Training Load (ACL) from TRIMP values over last week
      double num = 0.0;
      double den = 0.0;
      int limit = (daysFromStart < 7) ? daysFromStart : 7;
      for (var j = 0; j < limit; j++) {
        DateTime tempDay = currentDay.subtract(Duration(days:j));
        num += (scores[tempDay]?['TRIMP'] ?? 0.0) * pow(e, -j/7);
        den += pow(e, -j/7);
      }
      double acl = num/den;
      scores[currentDay]?['ACL'] = acl;
    }

    for (var i = 0; i < daysFromStart; i++) {
      DateTime currentDay = DateUtils.dateOnly(day.subtract(Duration(days:i)));
      // computing Chronic Training Load (CTL) from TRIMP values over mesocycle
      double num = 0.0;
      double den = 0.0;
      for (var j = 0; j < (daysFromStart-i); j++) {
        DateTime tempDay = currentDay.subtract(Duration(days:j));
        num += (scores[tempDay]?['TRIMP'] ?? 0.0)*pow(e, -j/mesocycleLength);
        den += pow(e, -j/mesocycleLength);
      }
      double ctl = num/den;
      scores[currentDay]?['CTL'] = ctl;
    }

    for (var i = 0; i < mesocycleLength; i++) {
      DateTime currentDay = DateUtils.dateOnly(day.subtract(Duration(days:i)));
      scores[currentDay]?['TSB'] = (scores[currentDay]?['CTL'] ?? 0.0) - (scores[currentDay]?['ACL'] ?? 0.0);
    }

    return scores;
  }

  Map<String, double> computeScoresOfNewDay(DateTime newDay, List<Activity> newActivities, Map<DateTime, Map<String, double>> scores ) {
    scores[newDay]?['TRIMP'] = computeTRIMP(newActivities);

    // computing Acute Training Load (ACL) from TRIMP values over last week
    double num = 0.0;
    double den = 0.0;
    int limit = (daysFromStart < 7) ? daysFromStart : 7;
    for (var i = 0; i < limit; i++) {
      DateTime currentDay = newDay.subtract(Duration(days:i));
      num += (scores[currentDay]?['TRIMP'] ?? 0.0) * pow(e, -i/7);
      den += pow(e, -i/7);
    }
    double acl = num/den;
    scores[newDay]?['ACL'] = acl;

    // computing Chronic Training Load (CTL) from TRIMP values over mesocycle
    num = 0.0;
    den = 0.0;
    for (var i = 0; i < daysFromStart; i++) {
      DateTime currentDay = newDay.subtract(Duration(days:i));
      num += (scores[currentDay]?['TRIMP'] ?? 0.0)*pow(e, -i/mesocycleLength);
      den += pow(e, -i/mesocycleLength);
    }
    double ctl = num/den;
    scores[newDay]?['CTL'] = ctl;

    // Training Stress Balance (TSB)
    double tsb = ctl - acl;
    scores[newDay]?['TSB'] = tsb;

    return (scores[newDay] ?? {});
  }

}
