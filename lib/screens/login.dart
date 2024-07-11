import 'package:flutter/material.dart';
import 'package:simfit/providers/user_provider.dart';
import 'package:simfit/server/impact.dart';
import 'package:simfit/screens/home.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simfit/screens/profile.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  static const routename = 'Login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Impact impact = Impact();

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'SimFit',
      theme: LoginTheme(
        pageColorLight: Theme.of(context).primaryColor,
        primaryColor: Theme.of(context).primaryColor,
        titleStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
      ),
      onLogin: _userLogin,
      hideForgotPasswordButton: true,
      onRecoverPassword: _recoverPassword,
      userType: LoginUserType.name,
      messages: LoginMessages(
        userHint: 'Username',
        passwordHint: 'Password',
        loginButton: 'LOG IN',
      ),
      userValidator: _validateUsername,
      passwordValidator: _validatePassword,
      onSubmitAnimationCompleted: () => _checkFirstLogin(context),
    );
  }

  String? _validateUsername(String? username) {
    if (username!.isEmpty) {
      return 'The username field is empty!';
    }
    return null;
  }

  String? _validatePassword(String? password) {
    if (password!.isEmpty) {
      return 'The password field is empty!';
    }
    return null;
  }

  Future<String> _userLogin(LoginData data) async {
    if (data.name == 'gMQWqcZXKO' && data.password == '12345678!') {
      final result = await impact.getAndStoreTokens(data.name, data.password);
      if (result == 200) {
        final sp = await SharedPreferences.getInstance();
        await sp.setString('username', data.name);
        await sp.setString('password', data.password);
      }
      print('User ${data.name} logged in');
      return '';
    } else {
      return 'Wrong credentials';
    }
  }

  Future<String> _recoverPassword(String email) async {
    return 'This function is not currently implemented';
  }

  void _toHomePage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
  }

  void _toProfilePage(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Profile()));
  }

  void _checkFirstLogin(BuildContext context) {
    UserProvider userProv = UserProvider();

    if (userProv.firstLogin == true) {
      _toProfilePage(context);
    } else {
      _toHomePage(context);
    }
  }
}
