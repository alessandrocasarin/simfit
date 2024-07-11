import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('About SimFit',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18
        )),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_sharp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding:EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Image.asset(
                    'assets/simfit-logo.png',
                    scale: 1,
            ),
            const Spacer(),
            Text(
              'What is SimFit?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.blue,
              ),
            ),
            Text(
              'SimFit is an app to help you in tracking and planning your trainings. It provides you an overview on your daily health data and sports activities detected and tracked by your Fitbit watch.',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            Text(
              'To whom SimFit is addressed?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.blue,
              ),
            ),
            Text(
              'SimFit is dedicated to users who want to plan a training mesocycle. It keeps track of how the performance and training load varies during the mesocycle period and allows to perform simulations to better calibrate training and performance parameters such as duration, Training Impulse (TRIMP) and average beats per minute (avg bpm).',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            Text(
              'What is a training mesocycle?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.blue,
              ),
            ),
            Text(
              'It is a training program period, that usually coincides with 4 weeks, characterized by training objectives for the improvement of performance-related parameters.',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            const Spacer(),
          ]
        )
      )
    );
  }
}
