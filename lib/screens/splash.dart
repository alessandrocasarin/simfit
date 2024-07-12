import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simfit/providers/user_provider.dart';
import 'package:simfit/screens/home.dart';
import 'package:simfit/screens/login.dart';
import 'package:simfit/screens/profile.dart';
import 'package:simfit/server/impact.dart';
import 'package:simfit/screens/onboarding.dart';

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
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => OnBoarding())));
  }

  void _toProfilePage(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Profile()));
  }

  void _checkLogin(BuildContext context) async {
    UserProvider userProv = Provider.of<UserProvider>(context, listen: false);
    if (await userProv.checkOnboarding() == false) {
      _toOnboardingPage(context);
    } else {
      final result = await Impact().refreshTokens();
      if (result == 200) {
        if (userProv.firstLogin == true) {
          _toProfilePage(context);
        } else {
          _toHomePage(context);
        }
      } else {
        _toLoginPage(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () => _checkLogin(context));
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
