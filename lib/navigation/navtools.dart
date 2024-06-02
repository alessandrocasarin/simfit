import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simfit/screens/login.dart';
import 'package:simfit/screens/profile.dart';
import 'package:profile_photo/profile_photo.dart';

class NavDrawer extends StatelessWidget {
  NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
            color: Colors.blue,
            ), // BoxDecoration
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:[
                Text(
                  'Hello User!',
                  style: TextStyle(
                    fontWeight:FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
                ProfilePhoto(
                  totalWidth: 80,
                  cornerRadius: 360,
                  color: Colors.white,
                  image: const AssetImage('assets/user_avatar.jpg'),
                ),
              ]
            ),
          ),
          ListTile(
            trailing: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: () {_toProfilePage(context);}
          ),
          ListTile(
            trailing: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {_toSettingPage(context); }
          ),
          ListTile(
            trailing: const Icon(Icons.info),
            title: const Text('Info'),
            onTap: () {_toInfoPage(context);}
          ),
          Padding(
              padding: EdgeInsets.only(left:60, right:60, top:370),
              child: ElevatedButton(
                onPressed: () async {
                  _toLoginPage(context);
                },
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 10)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                ),
                child: Text('Log out',
                  style: TextStyle(
                    fontWeight:FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
        ] 
      )
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

void _toInfoPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: ((context) => const Info())));
  }

void _toSettingPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: ((context) => const Settings())));
  }