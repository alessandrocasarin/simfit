import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simfit/models/activity.dart';
import 'package:simfit/navigation/navtools.dart';
import 'package:simfit/providers/score_provider.dart';
import 'package:simfit/providers/user_provider.dart';
import 'package:simfit/screens/help.dart';
import 'package:simfit/screens/simulation.dart';
import 'package:simfit/server/impact.dart';
import 'package:simfit/utils/algorithm.dart';
import 'package:simfit/utils/graphic_elements.dart';

class Training extends StatefulWidget {
  static const routename = 'Training';

  const Training({super.key});

  @override
  _TrainingState createState() => _TrainingState();
}

class _TrainingState extends State<Training> {
  final Impact impact = Impact();

  DateTime lastDate =
      DateUtils.dateOnly(DateTime.now().subtract(const Duration(days: 1)));
  late Future<Map<String, dynamic>> _fetchDataFuture;
  late UserProvider _userProvider;
  bool isMesocycleStartToday = false;
  bool isMesocycleStartFuture = false;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    DateTime? startDate = _userProvider.mesocycleStartDate;
    DateTime? endDate = _userProvider.mesocycleEndDate;

    if (startDate != null) {
      DateTime today = DateUtils.dateOnly(DateTime.now());
      if (DateUtils.dateOnly(startDate) == today) {
        isMesocycleStartToday = true;
      } else if (startDate.isAfter(today)) {
        isMesocycleStartFuture = true;
      }
    }

    if (endDate != null &&
        endDate.isBefore(DateUtils.dateOnly(DateTime.now()))) {
      lastDate = endDate;
    }

    _fetchDataFuture = _fetchData(context);
  }

  Future<Map<String, dynamic>> _fetchData(BuildContext context) async {
    try {
      // Simulate network calls
      await Future.delayed(const Duration(seconds: 2));

      // Fetch activities and restHR based on userProvider data
      DateTime start = _userProvider.mesocycleStartDate ?? DateUtils.dateOnly(DateTime.now().subtract(const Duration(days: 30)));
      final Map<DateTime, List<Activity>> activities = await impact.getActivitiesFromDateRange(
        start,
        lastDate,
      );
      final double restHR = await impact.getRestHRFromDay(lastDate);

      return {
        'activities': activities,
        'restHR': restHR,
      };
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  _toHelpPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const Help()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Training Load',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).secondaryHeaderColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              icon: Icon(Icons.help_outline_rounded,
                  color: Theme.of(context).secondaryHeaderColor, size: 28),
              tooltip: 'Help',
              onPressed: () => _toHelpPage(context),
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 5,
                color: Theme.of(context).primaryColor,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            if (isMesocycleStartToday) {
              return _buildMesocycleStartTodayUI(snapshot.data!['restHR']);
            } else if (isMesocycleStartFuture) {
              return _buildMesocycleStartFutureUI();
            } else {
              return _buildTrainingLoadUI(snapshot.data!);
            }
          }
        },
      ),
      drawer: NavDrawer(),
    );
  }

  Widget _buildMesocycleStartTodayUI(double restHR) {
    Algorithm algorithm = Algorithm(
      gender: _userProvider.gender ?? 'male',
      age: _userProvider.age ?? 0,
      rHR: restHR,
      mesoLen: _userProvider.mesocycleLength ?? 42,
      daysFromMesoStart: 1,
    );
    Map<DateTime, Map<String, double>> mesocycleScores = {};

    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Your training mesocycle starts today! You can try to simulate your first training session.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _toSimulationPage(
                  context,
                  mesocycleScores,
                  algorithm,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Theme.of(context).secondaryHeaderColor,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Text(
                  'SIMULATE TRAINING',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMesocycleStartFutureUI() {
    DateTime startDate = _userProvider.mesocycleStartDate!;
    String startDateString =
        '${startDate.day.toString().padLeft(2, '0')}/${startDate.month.toString().padLeft(2, '0')}';

    return SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Your training mesocycle will start on $startDateString',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildTrainingLoadUI(Map<String, dynamic> data) {
    Map<DateTime, List<Activity>> activities = data['activities'];
    double restHR = data['restHR'];

    int dfms = ((lastDate.difference(_userProvider.mesocycleStartDate!).inHours)/24).round()+1;
    Algorithm algorithm = Algorithm(
      gender: _userProvider.gender ?? 'male',
      age: _userProvider.age ?? 0,
      rHR: restHR,
      mesoLen: _userProvider.mesocycleLength ?? 42,
      daysFromMesoStart: dfms,
    );
    Map<DateTime, Map<String, double>> mesocycleScores =
        algorithm.computeScoresOfMesocycle(lastDate, activities);

    ScoreProvider scoreProvider = ScoreProvider(
      day: lastDate,
      scoresOfDay: mesocycleScores[lastDate]!,
    );

    return SafeArea(
      child: SingleChildScrollView(
        child: ChangeNotifierProvider<ScoreProvider>(
          create: (context) => scoreProvider,
          builder: (context, child) => Column(
            children: [
              PlotContainer(
                scores: mesocycleScores,
                scoreProvider: scoreProvider,
              ),
              SizedBox(height: 20),
              Consumer<ScoreProvider>(
                builder: (context, provider, child) {
                  return Column(
                    children: [
                      Text(
                        'Training scores of ${provider.day.day.toString().padLeft(2, '0')}/${provider.day.month.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 5),
                      TRIMPDisplay(
                        index: (provider.scoresOfDay['TRIMP']!),
                      ),
                      Text(
                        'Acute Training Load: ${(provider.scoresOfDay['ACL']!).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Chronic Training Load: ${(provider.scoresOfDay['CTL']!).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Training Stress Balance: ${(provider.scoresOfDay['TSB']!).toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(width: 5),
                          PerformanceEmoji(tsb: provider.scoresOfDay['TSB']!),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (lastDate.isBefore(DateUtils.dateOnly(
                      DateTime.now().subtract(Duration(days: 1))))) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(
                          child: Text(
                            'Your mesocycle ended on ${lastDate.day.toString().padLeft(2, '0')}/${lastDate.month.toString().padLeft(2, '0')}!',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } else {
                    _toSimulationPage(
                      context,
                      mesocycleScores,
                      algorithm,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Theme.of(context).secondaryHeaderColor,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Text(
                    'SIMULATE TRAINING',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
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
      return Container(
        height: screenHeight*0.25,
      );
    } else {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding:
                  EdgeInsets.only(top: 20, bottom: 14, left: 20, right: 20),
              child: Center(
                child: Text(
                  'Plot of the training load and performance',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  color: Colors.red,
                  margin: EdgeInsets.only(right: 4),
                ),
                Text(
                  'ACL',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(width: 10),
                Container(
                  width: 12,
                  height: 12,
                  color: Colors.blue,
                  margin: EdgeInsets.only(right: 4),
                ),
                Text(
                  'CTL',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(width: 10),
                Container(
                  width: 12,
                  height: 12,
                  color: Colors.deepPurple,
                  margin: EdgeInsets.only(right: 4),
                ),
                Text(
                  'TSB',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            Container(
              width: 0.9 * screenWidth,
              height: 0.4 * screenHeight,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 0),
                child: CustomPlot(
                  scores: scores,
                  scoreProvider: scoreProvider,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Text(
                'Click on data points in the chart to display their values below.',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }
  }
}
