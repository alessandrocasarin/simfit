import 'package:flutter/material.dart';
import 'package:simfit/navigation/navtools.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static const routename = 'Home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home Page'),
          ],
        ),
      ),
      drawer: NavDrawer(),
    );
  }

}
