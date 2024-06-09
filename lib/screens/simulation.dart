import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simfit/models/activity.dart';
import 'package:simfit/providers/simulation_provider.dart';

class SessionSimulation extends StatefulWidget {
  static const routename = 'SessionSimulation';

  //final Map<DateTime, Map<String, double>> scores;
  //final Algorithm algorithm;
  late SimulationProvider simProv;

  SessionSimulation({super.key, required scores, required algorithm}) {
    simProv = SimulationProvider(scores: scores, algorithm: algorithm);
  }

  @override
  State<SessionSimulation> createState() => _SessionSimulationState();
}

class _SessionSimulationState extends State<SessionSimulation> {
  final _durationController = TextEditingController();
  double _intensitySliderValue = 130; // Initial slider value (130 bpm)
  bool _firstSetup = true;

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _firstSetup = true;
    _intensitySliderValue = 130;
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
                TextField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Duration (minutes)',
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Session intensity (bpm)'),
                    Text('${_intensitySliderValue.toInt()} bpm'),
                  ],
                ),
                Slider(
                  value: _intensitySliderValue,
                  min: widget.simProv.algorithm.restHR,
                  max: widget.simProv.algorithm.maxHR,
                  onChanged: (newValue) {
                    setState(() {
                      _intensitySliderValue = newValue;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_durationController.text != '') {
                      List<Activity> simActivities = [];
                      simActivities.add(
                        Activity(
                          activityName: 'Simulated activity',
                          avgHR: _intensitySliderValue.toInt(),
                          calories: 0,
                          distance: 0,
                          duration: Duration(
                              minutes:
                                  int.tryParse(_durationController.text) ?? 0),
                          steps: 0,
                          zonesHR: [],
                          avgSpeed: 0.0,
                          vo2Max: 0.0,
                          elevationGain: 0.0,
                          startingTime: DateUtils.dateOnly(DateTime.now()),
                        ),
                      );
                      setState(() {
                        _firstSetup = false;
                      });
                      widget.simProv.computeSimulatedScores(simActivities);
                    }
                  },
                  child: const Text('SIMULATE SESSION'),
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
                              'TRIMP simulation: ${provider.simulatedScores['TRIMP']}'),
                          Text(
                              'ACL simulation: ${provider.simulatedScores['ACL']}'),
                          Text(
                              'CTL simulation: ${provider.simulatedScores['CTL']}'),
                          Text(
                              'TSB simulation: ${provider.simulatedScores['TSB']}'),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
