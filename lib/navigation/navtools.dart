import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simfit/providers/user_provider.dart';
import 'package:simfit/screens/home.dart';
import 'package:simfit/screens/login.dart';
import 'package:simfit/screens/profile.dart';
import 'package:profile_photo/profile_photo.dart';
import 'package:simfit/screens/info.dart';
import 'package:simfit/screens/settings.dart';
import 'package:simfit/screens/training.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

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
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Hi ${(userProvider.name != null) ? userProvider.name : 'User'}!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  ProfilePhoto(
                    totalWidth: 90,
                    cornerRadius: 90,
                    color: Theme.of(context).secondaryHeaderColor,
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
            trailing: Icon(Icons.home_filled,
                color: Theme.of(context).primaryColor, size: 30),
            title: Text('Home',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Theme.of(context).primaryColor)),
            onTap: () {
              _toHomePage(context);
            },
          ),
          ListTile(
            trailing: Icon(Icons.account_circle,
                color: Theme.of(context).primaryColor, size: 30),
            title: Text('Profile',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Theme.of(context).primaryColor)),
            onTap: () {
              _toProfilePage(context);
            },
          ),
          ListTile(
            trailing: Icon(Icons.trending_up,
                color: Theme.of(context).primaryColor, size: 30),
            title: Text('Training',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Theme.of(context).primaryColor)),
            onTap: () {
              _toTrainingPage(context);
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Theme.of(context).secondaryHeaderColor,
                ),
                child: const Text(
                  'LOG OUT',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
    final sp = await SharedPreferences.getInstance();
    await sp.remove('username');
    await sp.remove('password');
    await sp.remove('access');
    await sp.remove('refresh');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: ((context) => const Login())),
    );
  }

  void _toTrainingPage(BuildContext context) {
    Navigator.of(context).pushReplacement(
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
