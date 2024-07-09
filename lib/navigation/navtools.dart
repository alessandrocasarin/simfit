import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:simfit/providers/user_provider.dart';
import 'package:simfit/screens/home.dart';
import 'package:simfit/screens/login.dart';
import 'package:simfit/screens/profile.dart';
import 'package:profile_photo/profile_photo.dart';
import 'package:simfit/screens/info.dart';
import 'package:simfit/screens/settings.dart';
import 'package:simfit/screens/training.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Hi ${(userProvider.name != null) ? userProvider.name : 'User'}!',
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
                    image: AssetImage(
                      userProvider.gender == 'female'
                          ? 'assets/female-avatar.png'
                          : 'assets/male-avatar.png',
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            trailing:
                const Icon(Icons.home_filled, color: Colors.black, size: 28),
            title: const Text('Home',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              _toHomePage(context);
            },
          ),
          ListTile(
            trailing:
                const Icon(Icons.account_circle, color: Colors.black, size: 28),
            title: const Text('Profile',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              _toProfilePage(context);
            },
          ),
          ListTile(
            trailing:
                const Icon(Icons.trending_up, color: Colors.black, size: 28),
            title: const Text('Training',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              _toTrainingPage(context);
            },
          ),
          ListTile(
            trailing: const Icon(Icons.settings, color: Colors.black, size: 28),
            title: const Text('Settings',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              _toSettingPage(context);
            },
          ),
          ListTile(
            trailing: const Icon(Icons.info, color: Colors.black, size: 28),
            title: const Text('Info',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              _toInfoPage(context);
            },
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
              child: ElevatedButton(
                onPressed: () async {
                  _toLoginPage(context);
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                child: Text(
                  'LOG OUT',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toHomePage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: ((context) => Home())),
    );
  }

  void _toProfilePage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: ((context) => const Profile())),
    );
  }

  void _toLoginPage(BuildContext context) async {
    final sp=await SharedPreferences.getInstance();
    await sp.remove("username");
    await sp.remove("password");
    await sp.remove("access");
    await sp.remove("refresh");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: ((context) => const Login())),
    );
  }

  void _toTrainingPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: ((context) => Training())),
    );
  }

  void _toInfoPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: ((context) => const Info())),
    );
  }

  void _toSettingPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: ((context) => const Settings())),
    );
  }
}
