import 'package:flutter/material.dart';
import 'package:simfit/server/impact.dart';
import 'package:simfit/screens/home.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static const routename = 'Login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Impact impact = Impact();

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Login',
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
      onSubmitAnimationCompleted: () async {
        _toHomePage(context);
      },
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
      final result = await impact.getAndStoreTokens(
          data.name, data.password);
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

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 24.0, right: 24.0, top: 50, bottom: 20),
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Image.asset(
                'assets/logo.png',
                scale: 4,
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Welcome',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Login',
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Username is required';
                  }
                  return null;
                },
                controller: userController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  prefixIcon: const Icon(
                    Icons.person,
                  ),
                  hintText: 'Username',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
                controller: passwordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  prefixIcon: const Icon(
                    Icons.lock,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      _showPassword();
                    },
                  ),
                  hintText: 'Password',
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final result = await impact.getAndStoreTokens(
                            userController.text, passwordController.text);
                        if (result == 200) {
                          final sp = await SharedPreferences.getInstance();
                          await sp.setString('username', userController.text);
                          await sp.setString(
                              'password', passwordController.text);
                          await impact.getPatient();
                          if (sp.getString('purpleAirKey') != null) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const Home()));
                          } else {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => ApiKeyOnboarding()));
                          }
                        } else {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(const SnackBar(
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.all(8),
                                duration: Duration(seconds: 2),
                                content:
                                    Text("username or password incorrect")));
                        }
                      }
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 12)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF384242))),
                    child: const Text('Log In'),
                  ),
                ),
              ),
              const Spacer(),
              const Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "By logging in, you agree to Pollutrack's\nTerms & Conditions and Privacy Policy",
                    style: TextStyle(fontSize: 12),
                  )),
            ]),
          ),
        ),
      ),
    );
  }
*/
}
