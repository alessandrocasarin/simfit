import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simfit/models/activity.dart';
import 'package:simfit/providers/simulation_provider.dart';

class SessionSimulation extends StatefulWidget {
  static const routename = 'SessionSimulation';

  late SimulationProvider simProv;

  SessionSimulation({super.key, required scores, required algorithm}) {
    simProv = SimulationProvider(scores: scores, algorithm: algorithm);
  }

  @override
  State<SessionSimulation> createState() => _SessionSimulationState();
}

class _SessionSimulationState extends State<SessionSimulation> {
  bool _firstSetup = true;
  List<Map<String, dynamic>> _activityBlocks = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _firstSetup = true;
    _activityBlocks.add({
      'controller': TextEditingController(),
      'sliderValue': 130.0,
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Simulation'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ChangeNotifierProvider<SimulationProvider>(
          create: (context) => widget.simProv,
          builder: (context, child) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ..._activityBlocks.map((block) {
                  TextEditingController durationController = block['controller'];
                  double sliderValue = block['sliderValue'];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          'Activity #${_activityBlocks.indexOf(block)+1}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextField(
                        controller: durationController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Duration [minutes]',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Session intensity [avg bpm]'),
                          Text('${sliderValue.toInt()} bpm'),
                        ],
                      ),
                      Slider(
                        value: sliderValue,
                        min: widget.simProv.algorithm.restHR,
                        max: widget.simProv.algorithm.maxHR,
                        onChanged: (newValue) {
                          setState(() {
                            block['sliderValue'] = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _activityBlocks.add({
                              'controller': TextEditingController(),
                              'sliderValue': 130.0,
                            });
                          });
                        },
                        child: Icon(Icons.add),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_activityBlocks.length > 1) {
                            setState(() {
                              _activityBlocks.removeLast();
                            });
                          }
                        },
                        child: Icon(Icons.remove),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: ElevatedButton(
                        onPressed: () {
                          bool allFilled = true;
                          List<Activity> simActivities = [];
                          for (var block in _activityBlocks) {
                            if (block['controller'].text.isEmpty) {
                              allFilled = false;
                              break;
                            } else {
                              simActivities.add(
                                Activity(
                                  activityName: 'Simulated activity',
                                  avgHR: block['sliderValue'].toInt(),
                                  calories: 0,
                                  distance: 0,
                                  duration: Duration(
                                    minutes: int.tryParse(
                                            block['controller'].text) ??
                                        0,
                                  ),
                                  steps: 0,
                                  zonesHR: [],
                                  avgSpeed: 0.0,
                                  vo2Max: 0.0,
                                  elevationGain: 0.0,
                                  startingTime:
                                      DateUtils.dateOnly(DateTime.now()),
                                ),
                              );
                            }
                          }
                          if (!allFilled) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Some activity parameters are empty!'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          setState(() {
                            _firstSetup = false;
                          });
                          widget.simProv.computeSimulatedScores(simActivities);
                        },
                        child: const Text('SIMULATE SESSION'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Consumer<SimulationProvider>(
                  builder: (context, provider, child) {
                    if (_firstSetup) {
                      return Container();
                    } else if (provider.simulatedScores.isEmpty) {
                      return const CircularProgressIndicator.adaptive();
                    } else {
                      return Column(
                        children: [
                          Text(
                              'TRIMP simulation: ${provider.simulatedScores['TRIMP']!.toStringAsFixed(2)}'),
                          Text(
                              'ACL simulation: ${provider.simulatedScores['ACL']!.toStringAsFixed(2)}'),
                          Text(
                              'CTL simulation: ${provider.simulatedScores['CTL']!.toStringAsFixed(2)}'),
                          Text(
                              'TSB simulation: ${provider.simulatedScores['TSB']!.toStringAsFixed(2)}'),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
