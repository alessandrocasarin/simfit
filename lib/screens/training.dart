import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simfit/models/activity.dart';
import 'package:simfit/navigation/navtools.dart';
import 'package:simfit/providers/score_provider.dart';
import 'package:simfit/providers/user_provider.dart';
import 'package:simfit/screens/simulation.dart';
import 'package:simfit/server/impact.dart';
import 'package:simfit/utils/algorithm.dart';
import 'package:simfit/utils/custom_plot.dart';

class Training extends StatefulWidget {
  static const routename = 'Training';

  @override
  _TrainingState createState() => _TrainingState();
}

class _TrainingState extends State<Training> {
  final DateTime showDate =
      DateUtils.dateOnly(DateTime.now().subtract(const Duration(days: 1)));
  final Impact impact = Impact();
  late ScoreProvider scoreProvider;
  late Future<Map<String, dynamic>> _fetchDataFuture;
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _fetchDataFuture = _fetchData(context);
  }

  Future<Map<String, dynamic>> _fetchData(BuildContext context) async {
    try {
      // Simulate network calls
      await Future.delayed(const Duration(seconds: 2));

      // Fetch activities and restHR based on userProvider data
      final Map<DateTime, List<Activity>> activities =
          await impact.getActivitiesFromDateRange(
        _userProvider.mesocycleStartDate ?? DateUtils.dateOnly(DateTime.now().subtract(const Duration(days: 30))),
        showDate,
      );
      final double restHR = await impact.getRestHRFromDay(showDate);

      return {
        'activities': activities,
        'restHR': restHR,
      };
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Page'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            Map<DateTime, List<Activity>> activities =
                snapshot.data!['activities'];
            double restHR = snapshot.data!['restHR'];

            Algorithm algorithm = Algorithm(
              gender: _userProvider.gender ?? 'male',
              age: _userProvider.age ?? 0,
              rHR: restHR,
              mesoLen: _userProvider.mesocycleLength ?? 42,
              daysFromMesoStart: showDate.difference(_userProvider.mesocycleStartDate ?? DateUtils.dateOnly(DateTime.now().subtract(const Duration(days: 30))))
                      .inDays + 1,
            );
            Map<DateTime, Map<String, double>> mesocycleScores =
                algorithm.computeScoresOfMesocycle(showDate, activities);

            scoreProvider = ScoreProvider(
              day: showDate,
              scoresOfDay: mesocycleScores[showDate]!,
            );

            return SafeArea(
              child: SingleChildScrollView(
                child: ChangeNotifierProvider<ScoreProvider>(
                  create: (context) => scoreProvider,
                  builder: (context, child) => Column(
                    children: [
                      TRIMPDisplay(
                        index: (mesocycleScores[showDate]?['TRIMP'] ?? 0.0),
                      ),
                      PlotContainer(
                        scores: mesocycleScores,
                        scoreProvider: scoreProvider,
                      ),
                      const SizedBox(height: 20),
                      Consumer<ScoreProvider>(
                        builder: (context, provider, child) {
                          return Column(
                            children: [
                              Text(
                                'Date: ${provider.day.day}/${provider.day.month}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Acute Training Load: ${(provider.scoresOfDay['ACL']!).toStringAsFixed(2)}',
                                style: TextStyle(color: Colors.red),
                              ),
                              Text(
                                'Chronic Training Load: ${(provider.scoresOfDay['CTL']!).toStringAsFixed(2)}',
                                style: TextStyle(color: Colors.blue),
                              ),
                              Text(
                                'Training Stress Balance: ${(provider.scoresOfDay['TSB']!).toStringAsFixed(2)}',
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _toSimulationPage(
                          context,
                          mesocycleScores,
                          algorithm,
                        ),
                        child: Text('RUN SIMULATION'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
      drawer: NavDrawer(),
    );
  }

  void _toSimulationPage(
    BuildContext context,
    Map<DateTime, Map<String, double>> mesocycleScores,
    Algorithm algorithm,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SessionSimulation(
          scores: mesocycleScores,
          algorithm: algorithm,
        ),
      ),
    );
  }
}

class PlotContainer extends StatelessWidget {
  final Map<DateTime, Map<String, double>> scores;
  final ScoreProvider scoreProvider;

  PlotContainer({Key? key, required this.scores, required this.scoreProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    if (scores.length == 1) {
      return Container();
    } else {
      return Container(
        width: 0.8 * screenWidth,
        height: 0.5 * screenHeight,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: CustomPlot(
            scores: scores,
            scoreProvider: scoreProvider,
          ),
        ),
      );
    }
  }
}

class TRIMPDisplay extends StatelessWidget {
  final double index;

  TRIMPDisplay({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String badgeText = '';
    Color badgeColor = Colors.green;

    // Determine the badge text and color based on the index
    if (index < 50) {
      badgeText = 'Easy';
      badgeColor = Colors.green;
    } else if (index < 120) {
      badgeText = 'Moderate';
      badgeColor = Colors.orange;
    } else if (index < 250) {
      badgeText = 'Hard';
      badgeColor = Colors.red;
    } else {
      badgeText = 'Very hard';
      badgeColor = Colors.black;
    }

    return Container(
      margin: EdgeInsets.all(20.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Yesterday training load: TRIMP=${double.parse((index).toStringAsFixed(2))}',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 10),
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
        ),
      ),
    );
  }
}
