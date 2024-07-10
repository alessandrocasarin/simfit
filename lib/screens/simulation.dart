import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simfit/models/activity.dart';
import 'package:simfit/providers/simulation_provider.dart';
import 'package:simfit/utils/graphic_elements.dart';

class SessionSimulation extends StatefulWidget {
  static const routename = 'SessionSimulation';

  late final SimulationProvider simProv;

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
      'sliderValue': widget.simProv.algorithm.restHR,
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Session Simulation',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ChangeNotifierProvider<SimulationProvider>(
            create: (context) => widget.simProv,
            builder: (context, child) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.only(top: 5, bottom: 10, left: 5, right: 5),
                    child: Center(
                      child: Text(
                        'Plan the physical activities you want to do today and simulate your performance score.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  ..._activityBlocks.map((block) {
                    TextEditingController durationController =
                        block['controller'];
                    double sliderValue = block['sliderValue'];
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: Text(
                              'Activity #${_activityBlocks.indexOf(block) + 1}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextField(
                            controller: durationController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Duration (minutes)',
                              labelStyle: TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Session intensity (avg bpm)',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '${sliderValue.toInt()} bpm',
                                style: TextStyle(fontSize: 16),
                              ),
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
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _activityBlocks.add({
                              'controller': TextEditingController(),
                              'sliderValue': widget.simProv.algorithm.restHR,
                            });
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Icon(Icons.add),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor:
                              Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                      SizedBox(width: 5.0), // Space between buttons
                      ElevatedButton(
                        onPressed: () {
                          if (_activityBlocks.length > 1) {
                            setState(() {
                              _activityBlocks.removeLast();
                            });
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Icon(Icons.remove),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor:
                              Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                      SizedBox(width: 5.0), // Space between buttons
                      ElevatedButton(
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
                                  activityName:
                                      'Simulated activity #${_activityBlocks.indexOf(block) + 1}',
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
                                content: Center(
                                  child: Text(
                                    'Some activity parameters are empty!',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                              ),
                            );
                            return;
                          }
                          setState(() {
                            _firstSetup = false;
                          });
                          widget.simProv.computeSimulatedScores(simActivities);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor:
                              Theme.of(context).secondaryHeaderColor,
                        ),
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          child: Text(
                            'RUN SIMULATION',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
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
                        return CircularProgressIndicator(
                          strokeWidth: 5,
                          color: Theme.of(context).primaryColor,
                        );
                      } else {
                        return Column(
                          children: [
                            const Text(
                              'Training scores post simulation',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 5),
                            TRIMPDisplay(
                              index: (provider.simulatedScores['TRIMP'] ?? 0.0),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Acute Training Load: ${provider.simulatedScores['ACL']!.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Chronic Training Load: ${provider.simulatedScores['CTL']!.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Training Stress Balance: ${provider.simulatedScores['TSB']!.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 18,
                              ),
                            ),
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
      ),
    );
  }
}
