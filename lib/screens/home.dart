import 'package:flutter/material.dart';
import 'package:simfit/navigation/navtools.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static const routename = 'Home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                    child: const Icon(Icons.arrow_back_ios), onPressed: () {}),
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'DATE',
                    filled: true,
                    prefixIcon: Icon(Icons.calendar_today),
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                  ),
                  readOnly: true,
                  onTap: () {
                    _selectDate();
                  },
                ),
                FloatingActionButton(
                    child: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {})
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(100)),
              width: 400,
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularPercentIndicator(
                        radius: 50,
                        lineWidth: 10,
                        animation: true,
                        percent: 0.6,
                        center: Text(
                          "60 %",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        footer: Text(
                          "1200/6000 Steps",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.green[200],
                      ),
                      Icon(Icons.favorite),
                      Text("90 bpm"),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularPercentIndicator(
                        radius: 50,
                        lineWidth: 10,
                        animation: true,
                        percent: 0.6,
                        center: Text(
                          "30 %",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        footer: Text(
                          "400/1000 Calories",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.pink[300],
                      ),
                      Icon(Icons.bedtime),
                      Text("7h 23 min"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          //ExpansionTile
        ],
      ),
      drawer: NavDrawer(),
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    
    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }
}
