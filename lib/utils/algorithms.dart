import 'dart:math';
import 'package:simfit/models/activity.dart';

class Algorithmms {
  double genderConst = 1.92;
  int ageConst = 0;
  int mesocycleLength = 0;

  Algorithmms({required String gender, required int age, required int mesocycle}) {
    if (gender == 'female') {
      genderConst = 1.67;
    }
    ageConst = age;
    mesocycleLength = mesocycle;
  }

  double _computeTRIMPOfDay(DateTime day, List<Activity> activities, double restHR) {
    if (activities.isEmpty) return 0.0;
    
    double trimpTot = 0.0;

    for (Activity currentActivity in activities) {
      double percHRR = (currentActivity.avgHR - restHR) / ((220 - ageConst) - restHR);
      double y = 0.64 * pow(e, genderConst * percHRR);
      double currentTrimp = currentActivity.duration.inMinutes * percHRR * y;
      trimpTot += currentTrimp;
    }
    return trimpTot;
  }

  Map<String, double> computeScoresOfDay(DateTime day, Map<DateTime, List<Activity>> activityList, Map<DateTime, double> restHRList) {
    Map<String, double> scores = {};

    Map<DateTime, double> mesocycleTRIMPs = {};
    for (var i = 0; i < mesocycleLength; i++) {
      DateTime currentDay = day.subtract(Duration(days:i));
      mesocycleTRIMPs[currentDay] = _computeTRIMPOfDay(currentDay, activityList[currentDay] ?? [], restHRList[currentDay] ?? 0.0);
    }
    scores['TRIMP'] = mesocycleTRIMPs[day] ?? 0.0;

    // computing Acute Training Load (ACL) from TRIMP values over last week
    double num = 0.0;
    double den = 0.0;
    for (var i = 0; i < 7; i++) {
      DateTime currentDay = day.subtract(Duration(days:i));
      num += (mesocycleTRIMPs[currentDay] ?? 0.0) * pow(e, -i/7);
      den += pow(e, -i/7);
    }
    double acl = num/den;
    scores['ACL'] = acl;

    // computing Chronic Training Load (CTL) from TRIMP values over mesocycle
    num = 0.0;
    den = 0.0;
    for (var i = 0; i < mesocycleLength; i++) {
      DateTime currentDay = day.subtract(Duration(days:i));
      num += (mesocycleTRIMPs[currentDay] ?? 0.0)*pow(e, -i/mesocycleLength);
      den += pow(e, -i/mesocycleLength);
    }
    double ctl = num/den;
    scores['CTL'] = ctl;

    // Training Stress Balance (TSB)
    double tsb = ctl - acl;
    scores['TSB'] = tsb;

    return scores;
  }


}
