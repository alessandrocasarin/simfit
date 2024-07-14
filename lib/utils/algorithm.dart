import 'dart:math';
import 'package:flutter/material.dart';
import 'package:simfit/models/activity.dart';

// Class `Algorithm` for computing training metrics based on activity data
class Algorithm {
  late double genderConst; // Constant based on gender
  late double maxHR; // Maximum heart rate based on age
  late double restHR; // Resting heart rate
  late int mesocycleLength; // Length of mesocycle in days
  late int daysFromStart; // Number of days from mesocycle start

  // Constructor to initialize Algorithm class with necessary parameters
  Algorithm({
    required String gender,
    required int age,
    required double rHR,
    required int mesoLen,
    required int daysFromMesoStart,
  }) {
    genderConst = (gender == 'female') ? 1.67 : 1.92; // Setting gender constant
    maxHR = (220 - age).toDouble(); // Calculating maximum heart rate
    restHR = rHR; // Setting resting heart rate
    mesocycleLength = mesoLen; // Setting mesocycle length
    daysFromStart = daysFromMesoStart; // Setting days from mesocycle start
  }

  // Method to compute TRIMP (Training Impulse) from a list of activities
  double computeTRIMP(List<Activity> activities) {
    if (activities.isEmpty) return 0.0; // Returning 0.0 if activities list is empty
    
    double trimpTot = 0.0; // Initializing total TRIMP value

    // Iterating through activities to calculate TRIMP
    for (Activity currentActivity in activities) {
      double percHRR = (currentActivity.avgHR - restHR) / (maxHR - restHR); // Calculating percentage of Heart Rate Reserve (HRR)
      double y = 0.64 * pow(e, genderConst * percHRR); // Computing multiplier based on gender and HRR
      double currentTrimp = currentActivity.duration.inMinutes * percHRR * y; // Calculating TRIMP for current activity
      trimpTot += currentTrimp; // Accumulating total TRIMP
    }
    return trimpTot; // Returning total TRIMP
  }

  // Method to compute training scores (TRIMP, ACL, CTL, TSB) for each day in a mesocycle
  Map<DateTime, Map<String, double>> computeScoresOfMesocycle(DateTime day, Map<DateTime, List<Activity>> activityList) {
    Map<DateTime, Map<String, double>> scores = {}; // Initializing scores map
    
    // Computing scores for each day from the start of mesocycle
    for (var i = 0; i < daysFromStart; i++) {
      DateTime currentDay = DateUtils.dateOnly(day.subtract(Duration(days: i))); // Getting date for current day
      scores[currentDay] ??= {}; // Initializing score map for current day
      scores[currentDay]?['TRIMP'] = computeTRIMP(activityList[currentDay] ?? []); // Calculating TRIMP for current day's activities
    }

    // Computing ACL (Acute Training Load) for each day
    for (var i = 0; i < daysFromStart; i++) {
      DateTime currentDay = DateUtils.dateOnly(day.subtract(Duration(days: i))); // Getting date for current day
      double num = 0.0; // Initializing numerator for ACL calculation
      double den = 0.0; // Initializing denominator for ACL calculation
      int limit = (daysFromStart - i < 7) ? (daysFromStart - i) : 7; // Determining limit for ACL calculation
      for (var j = 0; j < limit; j++) {
        DateTime tempDay = currentDay.subtract(Duration(days: j)); // Getting date for temporary day within ACL window
        num += (scores[tempDay]?['TRIMP'] ?? 0.0) * pow(e, -j / 7); // Accumulating numerator based on TRIMP and exponential decay
        den += pow(e, -j / 7); // Accumulating denominator based on exponential decay
      }
      double acl = num / den; // Computing ACL for current day
      scores[currentDay]?['ACL'] = acl; // Storing ACL in scores map
    }

    // Computing CTL (Chronic Training Load) for each day
    for (var i = 0; i < daysFromStart; i++) {
      DateTime currentDay = DateUtils.dateOnly(day.subtract(Duration(days: i))); // Getting date for current day
      double num = 0.0; // Initializing numerator for CTL calculation
      double den = 0.0; // Initializing denominator for CTL calculation
      for (var j = 0; j < (daysFromStart - i); j++) {
        DateTime tempDay = currentDay.subtract(Duration(days: j)); // Getting date for temporary day within CTL window
        num += (scores[tempDay]?['TRIMP'] ?? 0.0) * pow(e, -j / mesocycleLength); // Accumulating numerator based on TRIMP and exponential decay
        den += pow(e, -j / mesocycleLength); // Accumulating denominator based on exponential decay
      }
      double ctl = num / den; // Computing CTL for current day
      scores[currentDay]?['CTL'] = ctl; // Storing CTL in scores map
    }

    // Computing TSB (Training Stress Balance) for each day
    for (var i = 0; i < mesocycleLength; i++) {
      DateTime currentDay = DateUtils.dateOnly(day.subtract(Duration(days: i))); // Getting date for current day
      scores[currentDay]?['TSB'] = (scores[currentDay]?['CTL'] ?? 0.0) - (scores[currentDay]?['ACL'] ?? 0.0); // Computing TSB and storing in scores map
    }

    return scores; // Returning computed scores map
  }

  // Method to compute training scores for a new day and update scores map
  Map<String, double> computeScoresOfNewDay(DateTime newDay, List<Activity> newActivities, Map<DateTime, Map<String, double>> scores) {
    scores[newDay] = {}; // Initializing scores map for new day

    scores[newDay]?['TRIMP'] = computeTRIMP(newActivities); // Calculating TRIMP for new activities

    // Computing ACL (Acute Training Load) for new day
    double num = 0.0; // Initializing numerator for ACL calculation
    double den = 0.0; // Initializing denominator for ACL calculation
    int limit = (daysFromStart < 7) ? daysFromStart : 7; // Determining limit for ACL calculation
    for (var i = 0; i < limit; i++) {
      DateTime currentDay = newDay.subtract(Duration(days: i)); // Getting date for current day within ACL window
      num += (scores[currentDay]?['TRIMP'] ?? 0.0) * pow(e, -i / 7); // Accumulating numerator based on TRIMP and exponential decay
      den += pow(e, -i / 7); // Accumulating denominator based on exponential decay
    }
    double acl = num / den; // Computing ACL for new day
    scores[newDay]?['ACL'] = acl; // Storing ACL in scores map

    // Computing CTL (Chronic Training Load) for new day
    num = 0.0; // Resetting numerator for CTL calculation
    den = 0.0; // Resetting denominator for CTL calculation
    for (var i = 0; i < daysFromStart; i++) {
      DateTime currentDay = newDay.subtract(Duration(days: i)); // Getting date for current day within CTL window
      num += (scores[currentDay]?['TRIMP'] ?? 0.0) * pow(e, -i / mesocycleLength); // Accumulating numerator based on TRIMP and exponential decay
      den += pow(e, -i / mesocycleLength); // Accumulating denominator based on exponential decay
    }
    double ctl = num / den; // Computing CTL for new day
    scores[newDay]?['CTL'] = ctl; // Storing CTL in scores map

    // Computing TSB (Training Stress Balance) for new day
    double tsb = ctl - acl; // Computing TSB
    scores[newDay]?['TSB'] = tsb; // Storing TSB in scores map

    return (scores[newDay] ?? {}); // Returning computed scores for new day
  }
}
