import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simfit/screens/login.dart';
import 'package:simfit/screens/profile.dart';

class NavDrawer extends StatelessWidget {
  NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text('Profile Page'),
            onTap: () {
              Navigator.pop(context);
              _toProfilePage(context);
            },
          ),
          ListTile(
            title: Text('LOG OUT'),
            onTap: () {
              Navigator.pop(context);
              _toLoginPage(context);
            },
          )
        ],
      ),
    );
  }

  void _toProfilePage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: ((context) => const Profile())));
  }

  void _toLoginPage(BuildContext context) async {
    final sp = await SharedPreferences.getInstance();
    await sp.clear(); // clear whole shared preferences

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => const Login())));
  }
}
