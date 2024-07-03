import 'package:flutter/material.dart';
import 'package:simfit/screens/home.dart';
import 'package:simfit/screens/login.dart';
import 'package:simfit/server/impact.dart';

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
    Future.delayed(const Duration(seconds: 3), () => _checkLogin(context));
    return Scaffold(
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
                  SizedBox(height: 10),
                  const CircularProgressIndicator.adaptive(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
