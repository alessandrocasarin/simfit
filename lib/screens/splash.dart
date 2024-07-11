import 'package:flutter/material.dart';
import 'package:simfit/screens/home.dart';
import 'package:simfit/screens/login.dart';
import 'package:simfit/server/impact.dart';
import 'package:simfit/screens/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  void _toHomePage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
  }

  void _toLoginPage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: ((context) => Login())));
  }

  void _toOnboardingPage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: ((context) => OnBoarding())));
  }

  Future <void> _firstSeen(BuildContext context) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool _introSeen = sp.getBool('_introSeen') ?? false;
    
    if(_introSeen==true){
      _checkLogin(context);
    }
    else{
      await sp.setBool('_introSeen',true);
      _toOnboardingPage(context);
    }
  }

  void _checkLogin(BuildContext context) async {
    final result = await Impact().refreshTokens();
    if (result == 200) {
      _toHomePage(context); 
    } else {
      _toLoginPage(context);
    }  
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () => _firstSeen(context));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/simfit-logo.png',
                    scale: 4,
                  ),
                  const SizedBox(height: 10),
                  CircularProgressIndicator(
                    strokeWidth: 5,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
