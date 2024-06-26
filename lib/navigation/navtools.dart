import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simfit/screens/login.dart';
import 'package:simfit/screens/profile.dart';
import 'package:profile_photo/profile_photo.dart';
import 'package:simfit/screens/info.dart';
import 'package:simfit/screens/settings.dart';
import 'package:simfit/screens/training.dart';

class NavDrawer extends StatelessWidget {
  NavDrawer({Key? key}) : super(key: key);
  final sp = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
      DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ), // BoxDecoration
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Hi {nome_da_provider}!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.left,
              ),
              ProfilePhoto(
                totalWidth: 100,
                cornerRadius: 100,
                color: Colors.white,
                image: const AssetImage('assets/user.png'),
              ),
            ]),
      ),
      ListTile(
          trailing:
              const Icon(Icons.account_circle, color: Colors.black, size: 28),
          title: const Text('Profile',
              style: TextStyle(fontWeight: FontWeight.bold)),
          onTap: () {
            _toProfilePage(context);
          }),
      ListTile(
          trailing:
              const Icon(Icons.trending_up, color: Colors.black, size: 28),
          title: const Text('Training',
              style: TextStyle(fontWeight: FontWeight.bold)),
          onTap: () {
            _toTrainingPage(context);
          }),
      ListTile(
          trailing: const Icon(Icons.settings, color: Colors.black, size: 28),
          title: const Text('Settings',
              style: TextStyle(fontWeight: FontWeight.bold)),
          onTap: () {
            _toSettingPage(context);
          }),
      ListTile(
          trailing: const Icon(Icons.info, color: Colors.black, size: 28),
          title:
              const Text('Info', style: TextStyle(fontWeight: FontWeight.bold)),
          onTap: () {
            _toInfoPage(context);
          }),
      Padding(
        padding: EdgeInsets.only(left: 55, right: 55, top: 320),
        child: ElevatedButton(
          onPressed: () async {
            _toLoginPage(context);
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(horizontal: 60, vertical: 10)),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          child: Text(
            'Log out',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.white,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    ]));
  }

  void _toProfilePage(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => const Profile())));
  }

  void _toLoginPage(BuildContext context) async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => const Login())));
  }

  void _toTrainingPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: ((context) => Training())));
  }

  void _toInfoPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: ((context) => const Info())));
  }

  void _toSettingPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: ((context) => const Settings())));
  }
}
