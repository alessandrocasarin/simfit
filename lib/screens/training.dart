import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simfit/models/activity.dart';
import 'package:simfit/navigation/navtools.dart';
import 'package:simfit/server/impact.dart';
import 'package:simfit/utils/algorithms.dart';

class Training extends StatelessWidget {
  static const routename = 'Training';

  final DateTime showDate =
      DateUtils.dateOnly(DateTime.now().subtract(const Duration(days: 1)));
  final Impact impact = Impact();

  Training({super.key});

  Future<Map<String, dynamic>> _fetchData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String gender = sp.getString('gender') ?? 'male';
    int age = sp.getInt('age') ?? 0;
    int mesocycle = sp.getInt('mesocycle') ?? 30;

    // Simulate network calls
    await Future.delayed(const Duration(seconds: 2));

    Map<DateTime, List<Activity>> activities =
        await impact.getActivitiesFromDateRange(
            showDate.subtract(Duration(days: mesocycle * 2)), showDate);
    Map<DateTime, double> restHRs = await impact.getRestHRsFromDateRange(
        showDate.subtract(Duration(days: mesocycle * 2)), showDate);

    return {
      'gender': gender,
      'age': age,
      'mesocycle': mesocycle,
      'activities': activities,
      'restHRs': restHRs,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Page'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            String gender = snapshot.data!['gender'] ?? 'male';
            int age = snapshot.data!['age'] ?? 0;
            int mesocycle = snapshot.data!['mesocycle'] ?? 30;
            Map<DateTime, List<Activity>> activities =
                snapshot.data!['activities'];
            Map<DateTime, double> restHRs = snapshot.data!['restHRs'];

            Algorithmms algorithms =
                Algorithmms(gender: gender, age: age, mesocycle: mesocycle);
            Map<DateTime, Map<String, double>> mesocycleScores = algorithms
                .computeScoresOfMesocycle(showDate, activities, restHRs);

            return SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    TRIMPBadgeDisplay(
                        index: (mesocycleScores[showDate]?['TRIMP'] ?? 0.0)),
                  ],
                ),
              ),
            );
          }
        },
      ),
      drawer: NavDrawer(),
    );
  }
}

class TRIMPBadgeDisplay extends StatelessWidget {
  final double index;
  final double maxIndex;

  TRIMPBadgeDisplay({super.key, required this.index, this.maxIndex = 1000});

  @override
  Widget build(BuildContext context) {
    String badgeText = '';
    Color badgeColor = Colors.green;

    // Determine the badge text and color based on the index
    if (index < 350) {
      badgeText = 'Easy';
      badgeColor = Colors.green;
    } else if (index < 700) {
      badgeText = 'Moderate';
      badgeColor = Colors.orange;
    } else {
      badgeText = 'Hard';
      badgeColor = Colors.red;
    }

    // Calculate progress percentage
    double progress = index / maxIndex;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'TRIMP: ${double.parse((index).toStringAsFixed(2))}',
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 20),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: badgeColor,
            minHeight: 10,
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            badgeText,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
