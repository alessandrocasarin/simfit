import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simfit/providers/user_provider.dart';
import 'package:simfit/screens/splash.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          primary: Colors.blue,
          secondary: Colors.white,
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const Splash(),
    );
  }
}
