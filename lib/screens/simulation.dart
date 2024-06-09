import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simfit/models/activity.dart';
import 'package:simfit/providers/simulation_provider.dart';

class Simulation extends StatefulWidget {
  static const routename = 'Simulation';

  late final SimulationProvider simProv;

  Simulation({super.key, required scores, required algorithm}) {
    simProv = SimulationProvider(scores: scores, algorithm: algorithm);
  }

  @override
  State<Simulation> createState() => _SimulationState();
}

class _SimulationState extends State<Simulation> {
  final _durationController = TextEditingController();
  double _intensitySliderValue = 130; // Initial slider value (130 bpm)

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Simulation'),
      ),
      body: Padding(
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
                const Text('Training intensity (bpm)'),
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
                List<Activity> simActivities = [];
                simActivities.add(
                  Activity(
                    activityName: 'Simulated activity',
                    avgHR: _intensitySliderValue.toInt(),
                    calories: 0,
                    distance: 0,
                    duration: Duration(minutes: int.tryParse(_durationController.text) ?? 0),
                    steps: 0,
                    zonesHR: [],
                    avgSpeed: 0.0,
                    vo2Max: 0.0,
                    elevationGain: 0.0,
                    startingTime: DateUtils.dateOnly(DateTime.now()),
                  ),
                );
                widget.simProv.computeSimulatedScores(simActivities);
              },
              child: const Text('SIMULATE SESSION'),
            ),
            const SizedBox(height: 40),
            Consumer<SimulationProvider>(
              builder: (context, provider, child) {
                if (provider.simulatedScores.isEmpty) {
                  return Container();
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
    );
  }
}
