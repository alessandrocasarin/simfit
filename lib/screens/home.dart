import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:simfit/models/activity.dart';
import 'package:simfit/navigation/navtools.dart';
import 'package:simfit/providers/home_provider.dart';
import 'package:simfit/utils/graphic_elements.dart';

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
        .getDataOfDay(selectedDate);
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            selectedDate =
                                selectedDate.subtract(const Duration(days: 1));
                            provider.getDataOfDay(selectedDate);
                          },
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Theme.of(context).secondaryHeaderColor,
                            size: 26,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                await selectDate(context);
                                provider.getDataOfDay(selectedDate);
                              },
                              child: Text(
                                DateFormat('EEE, d MMM').format(selectedDate),
                                style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
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
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            if (!selectedDate.isAfter(DateUtils.dateOnly(
                                DateTime.now()
                                    .subtract(const Duration(days: 1))))) {
                              selectedDate =
                                  selectedDate.add(const Duration(days: 1));
                              provider.getDataOfDay(selectedDate);
                            }
                          },
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Theme.of(context).secondaryHeaderColor,
                            size: 26,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Consumer<HomeProvider>(
                    builder: (context, provider, child) {
                      if (!provider.dataReady) {
                        return Column(
                          children: [
                            const SizedBox(height: 100),
                            CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                              strokeWidth: 5,
                            ),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Container(
                              width: 0.9 * screenWidth,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(14),
                                shape: BoxShape.rectangle,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Center(
                                      child: Text(
                                        'Daily recap',
                                        style: TextStyle(
                                          color: Color(0xFF14181B),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    const Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        FaIcon(
                                                          FontAwesomeIcons
                                                              .shoePrints,
                                                          color:
                                                              Color(0xFF29C51F),
                                                          size: 20,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(8,
                                                                      4, 4, 4),
                                                          child: Text(
                                                            'Steps',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF14181B),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 22,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          (provider.totDailySteps >
                                                                  0)
                                                              ? provider
                                                                  .totDailySteps
                                                                  .toString()
                                                              : '-',
                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xFF14181B),
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    const Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .favorite_rounded,
                                                          color:
                                                              Color(0xFFFF0000),
                                                          size: 26,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(4),
                                                          child: Text(
                                                            'Heart rate',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF14181B),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 22,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          (provider.dailyRestHR > 0) ? '${provider.dailyRestHR.toString()} bpm' : '-',
                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xFF14181B),
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    const Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .local_fire_department,
                                                          color:
                                                              Color(0xFFF024F0),
                                                          size: 26,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(4),
                                                          child: Text(
                                                            'Calories',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF14181B),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 22,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          (provider.totDailyCalories > 0) ? '${provider.totDailyCalories.toString()} kcal' : '-',
                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xFF14181B),
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    const Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Icon(
                                                          Icons.bedtime_rounded,
                                                          color:
                                                              Color(0xFF253CF8),
                                                          size: 26,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(4),
                                                          child: Text(
                                                            'Sleep',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF14181B),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 22,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          (provider.mainDailySleep.inMinutes > 0) ? '${provider.mainDailySleep.inHours} h ${provider.mainDailySleep.inMinutes.remainder(60)} min' : '-',
                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xFF14181B),
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                (index) => ActivityRecap(
                                  activity: provider.dailyActivities[index],
                                ),
                              ),
                            )
                          else
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              child: Text(
                                'No training session recorded.',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 126, 127, 129),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          const SizedBox(height: 40),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
      drawer: NavDrawer(),
    );
  }
}

class ActivityRecap extends StatelessWidget {
  final Activity activity;

  ActivityRecap({required this.activity});

  @override
  Widget build(BuildContext context) {
    String activityLabel =
        '${activity.activityName} - ${DateFormat('HH:mm').format(activity.startingTime)}';

    String secondsLabel = '';
    if (activity.duration.inSeconds.remainder(60) < 10) {
      secondsLabel = '0${activity.duration.inSeconds.remainder(60)}';
    } else {
      secondsLabel = '${activity.duration.inSeconds.remainder(60)}';
    }

    String durationLabel =
        '${activity.duration.inHours.toString().padLeft(2, '0')}:${activity.duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:$secondsLabel';
    if (durationLabel == '00:00:00') {
      durationLabel = ' - ';
    }

    String avgSpeedLabel = '${activity.avgSpeed.toStringAsFixed(2)} km/h';
    if (avgSpeedLabel == '0.00 km/h') {
      avgSpeedLabel = ' - ';
    }

    String avgHRLabel = '${activity.avgHR} bpm';
    if (avgHRLabel == '0 bpm') {
      avgHRLabel = ' - ';
    }

    String vo2MaxLabel = '${activity.vo2Max.toStringAsFixed(1)} ml/kg/min';
    if (vo2MaxLabel == '0.0 ml/kg/min') {
      vo2MaxLabel = ' - ';
    }

    String distanceLabel = '${activity.distance.toStringAsFixed(2)} km';
    if (distanceLabel == '0.00 km') {
      distanceLabel = ' - ';
    }

    String stepsLabel = '${activity.steps} steps';
    if (stepsLabel == '0 steps') {
      stepsLabel = ' - ';
    }

    String caloriesLabel = '${activity.calories} kcal';
    if (caloriesLabel == '0 kcal') {
      caloriesLabel = ' - ';
    }

    String elevationGainLabel =
        '${activity.elevationGain.toStringAsFixed(0)} m';
    if (elevationGainLabel == '0 m') {
      elevationGainLabel = ' - ';
    }

    IconData trainingIcon = FontAwesomeIcons.dumbbell;
    switch (activity.activityName) {
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

    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: 0.8 * screenWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x33000000),
              offset: Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: FaIcon(
                        trainingIcon,
                        color: Theme.of(context).primaryColor,
                        size: 26,
                      ),
                    ),
                    Text(
                      activityLabel,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.black,
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
              ExpansionTile(
                title: const Center(
                  child: Text('Heart Rate Training Zones'),
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide(color: Colors.transparent),
                ),
                initiallyExpanded: false,
                backgroundColor: Colors.transparent,
                collapsedBackgroundColor: Colors.transparent,
                children: [
                  const Center(
                    child: Text('Minutes spent in each zone'),
                  ),
                  Container(
                    height: 200,
                    padding: EdgeInsets.all(10),
                    child: HRZoneBarChart(zonesHR: activity.zonesHR),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
