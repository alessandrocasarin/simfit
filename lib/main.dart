import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simfit/providers/user_provider.dart';
import 'package:simfit/providers/home_provider.dart';
import 'package:simfit/screens/splash.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SimFit',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            primary: Colors.blue,
            secondary: Colors.white,
            seedColor: Colors.blue,
          ),
          useMaterial3: true,
        ),
        home: const Splash(),
      ),
    );
  }
}
