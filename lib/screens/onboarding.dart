import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:simfit/screens/login.dart';
import 'package:simfit/screens/info.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({Key? key}) : super(key: key); // ({super.key});

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      finishButtonText: 'Login',
      onFinish: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => const Login())));
      },
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: Colors.blue,
      ),
      skipTextButton: Text(
        'Skip',
        style: TextStyle(
          fontSize: 20,
          color:  Colors.blue,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
        'Learn more',
        style: TextStyle(
          fontSize: 20,
          color:  Colors.blue,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailingFunction: () {
        Navigator.of(context).push(MaterialPageRoute(builder: ((context) => const Info())));
      },
      controllerColor:  Colors.blue,
      totalPage: 3,
      headerBackgroundColor: Colors.white,
      pageBackgroundColor: Colors.white,
      centerBackground: true,
      background: [
        Padding(
          padding: EdgeInsets.all(10),
          child:Image.asset(
          'assets/allenamento1.png',
          height: 400,
        ),),
        Padding(
          padding: EdgeInsets.all(10),
          child:Image.asset(
          'assets/ciclista.jpg',
          height: 400,
        ),),
        Padding(
          padding: EdgeInsets.all(10),
          child:Image.asset(
          'assets/grafico2.jpg',
          height: 400,
        ),),
      ],
      speed: 1.8,
      pageBodies: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 480,
              ),
              Text(
                'Track',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:  Colors.blue,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Keep track of your training data collected by your Fitbit watch',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 480,
              ),
              Text(
                'Simulate',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:  Colors.blue,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Simulate the training loads according to your features and objectives',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 480,
              ),
              Text(
                'Train',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:  Colors.blue,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Improve your performance by planning the trainings with mesocycles',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}