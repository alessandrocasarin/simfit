import 'package:flutter/material.dart';
import 'package:simfit/navigation/navtools.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static const routename = 'Home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController dateBirthController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Initialize state variables if necessary
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1970, 1),
      lastDate: DateTime(2024, 12),
    );
    if (picked != null && picked != selectedDate) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'SimFit',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      border: Border.all(
                        color: Color.fromARGB(255, 20, 24, 27),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Color.fromARGB(255, 20, 24, 27),
                        size: 30,
                      ),
                      onPressed: () => selectedDate =
                          selectedDate.subtract(Duration(days: 1)),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 248, 248, 248),
                        border: Border.all(
                          color: Color.fromARGB(255, 20, 24, 27),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(
                        onPressed: () =>
                            _selectDate(context, dateBirthController),
                        child: Text(
                          selectedDate.toString(),
                          style: TextStyle(
                            color: Color(0xFF14181B),
                            fontSize: 16,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      border: Border.all(
                        color: Color.fromARGB(255, 20, 24, 27),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Color.fromARGB(255, 20, 24, 27),
                        size: 30,
                      ),
                      onPressed: () =>
                          selectedDate = selectedDate.add(Duration(days: 1)),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                width: 405,
                height: 240,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(14),
                  shape: BoxShape.rectangle,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(6, 4, 0, 0),
                            child: Text(
                              'Daily activity',
                              style: TextStyle(
                                color: Color(0xFF14181B),
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.shoePrints,
                                            color: Color(0xFF29C51F),
                                            size: 20,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    8, 4, 4, 4),
                                            child: Text(
                                              'Steps',
                                              style: TextStyle(
                                                color: Color(0xFF14181B),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 22,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            '12500',
                                            style: TextStyle(
                                              color: Color(0xFF14181B),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.favorite_rounded,
                                            color: Color(0xFFFF0000),
                                            size: 26,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(4),
                                            child: Text(
                                              'Heart rate',
                                              style: TextStyle(
                                                color: Color(0xFF14181B),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 22,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            '68 bpm',
                                            style: TextStyle(
                                              color: Color(0xFF14181B),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.local_fire_department,
                                            color: Color(0xFFF024F0),
                                            size: 26,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(4),
                                            child: Text(
                                              'Calories',
                                              style: TextStyle(
                                                color: Color(0xFF14181B),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 22,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            '1650',
                                            style: TextStyle(
                                              color: Color(0xFF14181B),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.bedtime_rounded,
                                            color: Color(0xFF253CF8),
                                            size: 26,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(4),
                                            child: Text(
                                              'Sleep',
                                              style: TextStyle(
                                                color: Color(0xFF14181B),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 22,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            '7 h 53 min',
                                            style: TextStyle(
                                              color: Color(0xFF14181B),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Color(0x33000000),
                      offset: Offset(
                        0,
                        2,
                      ),
                    )
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(2),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: FaIcon(
                                FontAwesomeIcons.running,
                                color: Colors.blue,
                                size: 26,
                              ),
                            ),
                            Text(
                              '7:30 - Run (manual)',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Color(0xFF14181B),
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(4),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.timer_outlined,
                                      color: Color(0xFFFF8A2C),
                                      size: 24,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        '00:53:49',
                                        style: TextStyle(
                                          color: Color(0xFF14181B),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.speed_outlined,
                                      color: Color(0xFF118D4F),
                                      size: 24,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        '9.50 km/h',
                                        style: TextStyle(
                                          color: Color(0xFF14181B),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.favorite_border_rounded,
                                      color: Color(0xFFFF0000),
                                      size: 24,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        '143 bpm',
                                        style: TextStyle(
                                          color: Color(0xFF14181B),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.air_outlined,
                                      color: Color(0xFF08D3FF),
                                      size: 24,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        '48.8 ml/kg/min',
                                        style: TextStyle(
                                          color: Color(0xFF14181B),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.outlined_flag_rounded,
                                      color: Color(0xFF6800FF),
                                      size: 24,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        '8.47 km',
                                        style: TextStyle(
                                          color: Color(0xFF14181B),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.shoePrints,
                                      color: Color(0xFF28DA32),
                                      size: 16,
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(-1, 0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8, 4, 4, 4),
                                        child: Text(
                                          '8604 steps',
                                          style: TextStyle(
                                            color: Color(0xFF14181B),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.local_fire_department_outlined,
                                      color: Color(0xFFF024F0),
                                      size: 24,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        '727 kcal',
                                        style: TextStyle(
                                          color: Color(0xFF14181B),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.trending_up_rounded,
                                      color: Color(0xFEF0C500),
                                      size: 24,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        '28 m',
                                        style: TextStyle(
                                          color: Color(0xFF14181B),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: Color(0xFFE0E3E7),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 4, 0, 8),
                        child: Text(
                          'Heart Rate Training Zones',
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.rotate(
                            angle: 90 * (math.pi / 180),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 1,
                        color: Color(0xFFE0E3E7),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 248, 248, 248),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 20, 24, 27),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Simulate session',
                                    style: TextStyle(
                                      color: Color(0xFF14181B),
                                      fontSize: 16,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Color(0x33000000),
                      offset: Offset(
                        0,
                        2,
                      ),
                    )
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(2),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: FaIcon(
                                FontAwesomeIcons.biking,
                                color: Colors.blue,
                                size: 26,
                              ),
                            ),
                            Text(
                              '16:25 - Bike (auto)',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Color(0xFF14181B),
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(4),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.timer_outlined,
                                      color: Color(0xFFFF8A2C),
                                      size: 24,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        '04:52:31',
                                        style: TextStyle(
                                          color: Color(0xFF14181B),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.speed_outlined,
                                      color: Color(0xFF118D4F),
                                      size: 24,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        '28.73 km/h',
                                        style: TextStyle(
                                          color: Color(0xFF14181B),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.favorite_border_rounded,
                                      color: Color(0xFFFF0000),
                                      size: 24,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        '150 bpm',
                                        style: TextStyle(
                                          color: Color(0xFF14181B),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.outlined_flag_rounded,
                                      color: Color(0xFF6800FF),
                                      size: 24,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        '140.14 km',
                                        style: TextStyle(
                                          color: Color(0xFF14181B),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.trending_up_rounded,
                                      color: Color(0xFEF0C500),
                                      size: 24,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        '664 m',
                                        style: TextStyle(
                                          color: Color(0xFF14181B),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.local_fire_department_outlined,
                                      color: Color(0xFFF024F0),
                                      size: 24,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        '3893 kcal',
                                        style: TextStyle(
                                          color: Color(0xFF14181B),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: Color(0xFFE0E3E7),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 4, 0, 8),
                        child: Text(
                          'Heart Rate Training Zones',
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.rotate(
                            angle: 90 * (math.pi / 180),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 1,
                        color: Color(0xFFE0E3E7),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 248, 248, 248),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 20, 24, 27),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Simulate session',
                                    style: TextStyle(
                                      color: Color(0xFF14181B),
                                      fontSize: 16,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: NavDrawer(),
    );
  }
}
