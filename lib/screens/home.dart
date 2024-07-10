import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:simfit/models/activity.dart';
import 'package:simfit/navigation/navtools.dart';
import 'package:simfit/providers/home_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static const routename = 'Home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime selectedDate = DateTime.now().subtract(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    Provider.of<HomeProvider>(context, listen: false)
        .getDataOfDay(DateTime.now());
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000, 1),
      lastDate:
          DateUtils.dateOnly(DateTime.now().subtract(const Duration(days: 1))),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
    }
  }

  Widget trainingSessionRecap({required Activity activity}) {
    // activity values
    DateTime startingTime = activity.startingTime;
    String activityName = activity.activityName;
    Duration duration = activity.duration;
    double avgSpeed = activity.avgSpeed;
    int avgHR = activity.avgHR;
    double vo2Max = activity.vo2Max;
    double distance = activity.distance;
    int steps = activity.steps;
    int calories = activity.calories;
    double elevationGain = activity.elevationGain;
    List<HRZone> zonesHR = activity.zonesHR;

    // strings for the graphic visualization of the activity values, with checks for missing values
    String activityLabel =
        '${DateFormat('HH:mm').format(startingTime)} - $activityName';

    String secondsLabel = '';
    (duration.inSeconds.remainder(60) < 10)
        ? (secondsLabel = '0${duration.inSeconds.remainder(60)}')
        : ('${duration.inSeconds.remainder(60)}');
    String durationLabel =
        '${duration.inHours}:${duration.inMinutes.remainder(60)}:$secondsLabel';
    if (durationLabel == '00:00:00') {
      durationLabel = ' - ';
    }

    String avgSpeedLabel = '${avgSpeed.toStringAsFixed(2)} km/h';
    if (avgSpeedLabel == '0.00 km/h') {
      avgSpeedLabel = ' - ';
    }

    String avgHRLabel = '$avgHR bpm';
    if (avgHRLabel == '0 bpm') {
      avgHRLabel = ' - ';
    }

    String vo2MaxLabel = '${vo2Max.toStringAsFixed(1)} ml/kg/min';
    if (vo2MaxLabel == '0.0 ml/kg/min') {
      vo2MaxLabel = ' - ';
    }

    String distanceLabel = '${distance.toStringAsFixed(2)} km';
    if (distanceLabel == '0.00 km') {
      distanceLabel = ' - ';
    }

    String stepsLabel = '$steps steps';
    if (stepsLabel == '0 steps') {
      stepsLabel = ' - ';
    }

    String caloriesLabel = '$calories kcal';
    if (caloriesLabel == '0 kcal') {
      caloriesLabel = ' - ';
    }

    String elevationGainLabel = '${elevationGain.toStringAsFixed(0)} m';
    if (elevationGainLabel == '0 m') {
      elevationGainLabel = ' - ';
    }

    // activity icon switch based on the type of activity
    IconData trainingIcon = FontAwesomeIcons.dumbbell;
    switch (activityName) {
      case 'Corsa':
        trainingIcon = FontAwesomeIcons.personRunning;
        break;
      case 'Bici':
        trainingIcon = FontAwesomeIcons.personBiking;
        break;
      case 'Camminata':
        trainingIcon = FontAwesomeIcons.personWalking;
        break;
    }

    // widget graphic structure
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x33000000),
              offset: Offset(
                0,
                2,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(2),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: FaIcon(
                        trainingIcon,
                        color: Colors.blue,
                        size: 26,
                      ),
                    ),
                    Text(
                      activityLabel,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Color(0xFF14181B),
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              color: Color(0xFFFF8A2C),
                              size: 24,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                durationLabel,
                                style: const TextStyle(
                                  color: Color(0xFF14181B),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Icon(
                              Icons.speed_outlined,
                              color: Color(0xFF118D4F),
                              size: 24,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                avgSpeedLabel,
                                style: const TextStyle(
                                  color: Color(0xFF14181B),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Icon(
                              Icons.favorite_border_rounded,
                              color: Color(0xFFFF0000),
                              size: 24,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                avgHRLabel,
                                style: const TextStyle(
                                  color: Color(0xFF14181B),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Icon(
                              Icons.air_outlined,
                              color: Color(0xFF08D3FF),
                              size: 24,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                vo2MaxLabel,
                                style: const TextStyle(
                                  color: Color(0xFF14181B),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Icon(
                              Icons.outlined_flag_rounded,
                              color: Color(0xFF6800FF),
                              size: 24,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                distanceLabel,
                                style: const TextStyle(
                                  color: Color(0xFF14181B),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.shoePrints,
                              color: Color(0xFF28DA32),
                              size: 16,
                            ),
                            Align(
                              alignment: const AlignmentDirectional(-1, 0),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    8, 4, 4, 4),
                                child: Text(
                                  stepsLabel,
                                  style: const TextStyle(
                                    color: Color(0xFF14181B),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Icon(
                              Icons.local_fire_department_outlined,
                              color: Color(0xFFF024F0),
                              size: 24,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                caloriesLabel,
                                style: const TextStyle(
                                  color: Color(0xFF14181B),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Icon(
                              Icons.trending_up_rounded,
                              color: Color(0xFEF0C500),
                              size: 24,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                elevationGainLabel,
                                style: const TextStyle(
                                  color: Color(0xFF14181B),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
                color: Color(0xFFE0E3E7),
              ),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12, 4, 0, 8),
                child: Text(
                  'Heart Rate Training Zones',
                  textAlign: TextAlign.start,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: 90 * (math.pi / 180),
                  ), // child of Transform.rotate will be the bar graph with the HT training zones
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'SimFit',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          border: Border.all(
                            color: const Color.fromARGB(255, 20, 24, 27),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Color.fromARGB(255, 20, 24, 27),
                            size: 30,
                          ),
                          onPressed: () {
                            selectedDate =
                                selectedDate.subtract(const Duration(days: 1));
                            provider.getDataOfDay(selectedDate);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 248, 248, 248),
                            border: Border.all(
                              color: const Color.fromARGB(255, 20, 24, 27),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              await selectDate(context);
                              provider.getDataOfDay(selectedDate);
                            },
                            child: Text(
                              DateFormat('EEE, d MMM').format(selectedDate),
                              style: const TextStyle(
                                color: Color(0xFF14181B),
                                fontSize: 24,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          border: Border.all(
                            color: const Color.fromARGB(255, 20, 24, 27),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Color.fromARGB(255, 20, 24, 27),
                            size: 30,
                          ),
                          onPressed: () {
                            if (!selectedDate.isAtSameMomentAs(
                                DateUtils.dateOnly(DateTime.now()
                                    .subtract(const Duration(days: 1))))) {
                              selectedDate =
                                  selectedDate.add(const Duration(days: 1));
                              provider.getDataOfDay(selectedDate);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: 405,
                    height: 240,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(14),
                      shape: BoxShape.rectangle,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(4),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(6, 4, 0, 0),
                                child: Text(
                                  'Daily activity',
                                  style: TextStyle(
                                    color: Color(0xFF14181B),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          const Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              FaIcon(
                                                FontAwesomeIcons.shoePrints,
                                                color: Color(0xFF29C51F),
                                                size: 20,
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(8, 4, 4, 4),
                                                child: Text(
                                                  'Steps',
                                                  style: TextStyle(
                                                    color: Color(0xFF14181B),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 22,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text( 
                                                provider.totDailySteps
                                                    .toString(),
                                                style: const TextStyle(
                                                  color: Color(0xFF14181B),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          const Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Icon(
                                                Icons.favorite_rounded,
                                                color: Color(0xFFFF0000),
                                                size: 26,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(4),
                                                child: Text(
                                                  'Heart rate',
                                                  style: TextStyle(
                                                    color: Color(0xFF14181B),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 22,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                '${provider.dailyRestHR.toInt().toString()} bpm',
                                                style: const TextStyle(
                                                  color: Color(0xFF14181B),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          const Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Icon(
                                                Icons.local_fire_department,
                                                color: Color(0xFFF024F0),
                                                size: 26,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(4),
                                                child: Text(
                                                  'Calories',
                                                  style: TextStyle(
                                                    color: Color(0xFF14181B),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 22,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                '${provider.totDailyCalories.toInt()} kcal',
                                                style: const TextStyle(
                                                  color: Color(0xFF14181B),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          const Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Icon(
                                                Icons.bedtime_rounded,
                                                color: Color(0xFF253CF8),
                                                size: 26,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(4),
                                                child: Text(
                                                  'Sleep',
                                                  style: TextStyle(
                                                    color: Color(0xFF14181B),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 22,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                '${provider.mainDailySleep.inHours} h ${provider.mainDailySleep.inMinutes.remainder(60)} min',
                                                style: const TextStyle(
                                                  color: Color(0xFF14181B),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (provider.dailyActivities.isNotEmpty)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      provider.dailyActivities.length,
                      (index) => trainingSessionRecap(
                        activity: provider.dailyActivities[index],
                      ),
                    ),
                  )
                else
                  const Text(
                    'No training session recorded.',
                    style: TextStyle(
                      color: Color.fromARGB(255, 126, 127, 129),
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      drawer: NavDrawer(),
    );
  }
}
