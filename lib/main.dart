import 'package:flutter/material.dart';
import 'package:simfit/screens/splash.dart';

void main() {
  runApp(const MyApp());
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
          background: const Color(0xFFFFFFFF),
          primary: const Color(0xFF07389e),
          secondary: const Color(0xFFFFFFFF),
          seedColor: const Color(0xFF07389e),
        ),
        useMaterial3: true,
      ),
      home: const Splash(),
    );
  }
}
