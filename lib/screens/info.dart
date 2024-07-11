import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'About SimFit',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).secondaryHeaderColor,
        ),
        body: Container(
            color: Colors.white,
            padding: EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/simfit-logo.png',
                      scale: 1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'What is SimFit?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    'SimFit is an app to help you in tracking and planning your trainings. It provides you an overview on your daily health data and sports activities detected and tracked by your Fitbit watch.',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.black,
                      
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Who is SimFit designed for?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    'SimFit is dedicated to users who want to plan a training mesocycle. It keeps track of how the performance and training load varies during the mesocycle period and it allows to perform simulations about your next activity sessions to better calibrate training load and performance parameters.',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'What is a training mesocycle?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    'It is a training program period characterized by training objectives for the improvement of performance-related parameters.',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                ])));
  }
}
