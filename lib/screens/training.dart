import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simfit/models/activity.dart';
import 'package:simfit/navigation/navtools.dart';
import 'package:simfit/screens/simulation.dart';
import 'package:simfit/server/impact.dart';
import 'package:simfit/utils/algorithm.dart';
import 'package:simfit/utils/custom_plot.dart';

class Training extends StatelessWidget {
  static const routename = 'Training';

  final DateTime showDate = DateUtils.dateOnly(DateTime.now().subtract(const Duration(days: 1)));
  final Impact impact = Impact();

  Training({super.key});

  Future<Map<String, dynamic>> _fetchData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String gender = sp.getString('gender') ?? 'male';
    int age = sp.getInt('age') ?? 0;
    int mesoLen = sp.getInt('mesocycleLength') ?? 42;
    DateTime mesoStart = showDate.subtract(Duration(days: 30));
    String? firstDay = sp.getString('mesocycleStart');
    if (firstDay != null) {
      mesoStart = DateUtils.dateOnly(DateFormat('yyyy-MM-dd').parse(firstDay));
    }

    // Simulate network calls
    await Future.delayed(const Duration(seconds: 2));

    Map<DateTime, List<Activity>> activities = await impact.getActivitiesFromDateRange(mesoStart, showDate);
    double restHR = await impact.getRestHRFromDay(showDate);

    return {
      'gender': gender,
      'age': age,
      'mesocycleLength': mesoLen,
      'daysFromMesocycleStart': showDate.difference(mesoStart).inDays+1,
      'activities': activities,
      'restHR': restHR,
    };
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
            String gender = snapshot.data!['gender'];
            int age = snapshot.data!['age'];
            int mesoLen = snapshot.data!['mesocycleLength'];
            int daysFromStart= snapshot.data!['daysFromMesocycleStart'];
            Map<DateTime, List<Activity>> activities = snapshot.data!['activities'];
            double restHR = snapshot.data!['restHR'];

            Algorithm algorithm = Algorithm(gender: gender, age: age, rHR: restHR, mesoLen: mesoLen, daysFromMesoStart: daysFromStart);
            Map<DateTime, Map<String, double>> mesocycleScores = algorithm.computeScoresOfMesocycle(showDate, activities);

            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TRIMPBadgeDisplay(
                      index: (mesocycleScores[showDate]?['TRIMP'] ?? 0.0),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 0.8*screenWidth,
                      height: 0.5*screenHeight,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: CustomPlot(scores: mesocycleScores),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        Text('Acute Training Load: ${(mesocycleScores[showDate]!['ACL']!).toStringAsFixed(2)}'),
                        Text('Chronic Training Load: ${(mesocycleScores[showDate]!['CTL']!).toStringAsFixed(2)}'),
                        Text('Training Stress Balance: ${(mesocycleScores[showDate]!['TSB']!).toStringAsFixed(2)}'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _toSimulationPage(context, mesocycleScores, algorithm),
                      child: Text('RUN SIMULATION'),
                    ),
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

  void _toSimulationPage(BuildContext context, Map<DateTime, Map<String, double>> mesocycleScores, Algorithm algorithm) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SessionSimulation(scores: mesocycleScores, algorithm: algorithm),
      ),
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
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: badgeColor,
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            badgeText,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
