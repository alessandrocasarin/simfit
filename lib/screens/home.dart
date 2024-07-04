import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static const routename = 'Home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Define any necessary state variables here

  @override
  void initState() {
    super.initState();
    // Initialize state variables if necessary
  }

  @override
  void dispose() {
    // Dispose state variables if necessary
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          'SimFit',
          style: GoogleFonts.outfit(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
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
                  child: IconButton(
                    iconSize: 40,
                    color: Color(0x2939A9EF),
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Color.fromARGB(255, 20, 24, 27),
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      '12-06-2023',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Outfit',
                          color: Color.fromARGB(255, 20, 24, 27),
                          fontSize: 24,
                          letterSpacing: 0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: IconButton(
                    iconSize: 40,
                    color: Color(0x2939A9EF),
                    icon: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color.fromARGB(255, 20, 24, 27),
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                width: 405,
                height: 216,
                decoration: BoxDecoration(
                  color: Color(0x2939A9EF),
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
                            padding: EdgeInsets.all(4),
                            child: Text(
                              'Daily activity',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 24,
                                letterSpacing: 0,
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
                                                fontFamily: 'Readex Pro',
                                                fontSize: 20,
                                                letterSpacing: 0,
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
                                              fontFamily: 'Readex Pro',
                                              fontSize: 22,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.w600,
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
                                                fontFamily: 'Readex Pro',
                                                fontSize: 20,
                                                letterSpacing: 0,
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
                                              fontFamily: 'Readex Pro',
                                              fontSize: 22,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.w600,
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
                                                fontFamily: 'Readex Pro',
                                                fontSize: 20,
                                                letterSpacing: 0,
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
                                              fontFamily: 'Readex Pro',
                                              fontSize: 22,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.w600,
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
                                                fontFamily: 'Readex Pro',
                                                fontSize: 20,
                                                letterSpacing: 0,
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
                                              fontFamily: 'Readex Pro',
                                              fontSize: 22,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.w600,
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
                                color: Color(0xFF107CFF),
                                size: 26,
                              ),
                            ),
                            Text(
                              '7:30 - Run (manual)',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 24,
                                letterSpacing: 0,
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
                                          fontFamily: 'Readex Pro',
                                          fontSize: 18,
                                          letterSpacing: 0,
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
                                          fontFamily: 'Readex Pro',
                                          fontSize: 18,
                                          letterSpacing: 0,
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
                                          fontFamily: 'Readex Pro',
                                          fontSize: 18,
                                          letterSpacing: 0,
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
                                          fontFamily: 'Readex Pro',
                                          fontSize: 18,
                                          letterSpacing: 0,
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
                                          fontFamily: 'Readex Pro',
                                          fontSize: 18,
                                          letterSpacing: 0,
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
                                            fontFamily: 'Readex Pro',
                                            fontSize: 18,
                                            letterSpacing: 0,
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
                                          fontFamily: 'Readex Pro',
                                          fontSize: 18,
                                          letterSpacing: 0,
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
                                          fontFamily: 'Readex Pro',
                                          fontSize: 18,
                                          letterSpacing: 0,
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
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            color: Color(0xFF57636C),
                            fontSize: 14,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w500,
                          ),
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
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
                        child: TextButton(
                          onPressed: () {
                            print('Button pressed ...');
                          },
                          child: Text(
                            'Simulate session',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              color: Color(0xFF14181B),
                              fontSize: 16,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ButtonStyle(
                            /*minimumSize: Size(double.infinity, 40),
                            maximumSize: Size(double.infinity, 40),
                            backgroundColor: Colors.white,
                            borderSide: BorderSide(
                              color: Color(0xFFE0E3E7),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(40),*/
                          ),
                        ),
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
                                color: Color(0xFF107CFF),
                                size: 26,
                              ),
                            ),
                            Text(
                              '16:25 - Bike (auto)',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 24,
                                letterSpacing: 0,
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
                                      Icons.timer_sharp,
                                      color: Color(0xFFEC740A),
                                      size: 24,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        '04:52:31',
                                        style: TextStyle(
                                          fontFamily: 'Readex Pro',
                                          fontSize: 18,
                                          letterSpacing: 0,
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
                                      color: Color.fromARGB(255, 20, 24, 27),
                                      size: 24,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        '28.73 km/h',
                                        style: TextStyle(
                                          fontFamily: 'Readex Pro',
                                          fontSize: 18,
                                          letterSpacing: 0,
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
                                          fontFamily: 'Readex Pro',
                                          fontSize: 18,
                                          letterSpacing: 0,
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
                                      color: Color.fromARGB(255, 20, 24, 27),
                                      size: 24,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        '140.14 km',
                                        style: TextStyle(
                                          fontFamily: 'Readex Pro',
                                          fontSize: 18,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.settings_outlined,
                                      color: Color.fromARGB(255, 20, 24, 27),
                                      size: 24,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Text(
                                        '664 m',
                                        style: TextStyle(
                                          fontFamily: 'Readex Pro',
                                          fontSize: 18,
                                          letterSpacing: 0,
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
                                          fontFamily: 'Readex Pro',
                                          fontSize: 18,
                                          letterSpacing: 0,
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
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            color: Color(0xFF57636C),
                            fontSize: 14,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w500,
                          ),
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
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
                        child: TextButton(
                          onPressed: () {
                            print('Button pressed ...');
                          },
                          child: Text(
                            'Simulate session',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              color: Color(0xFF14181B),
                              fontSize: 16,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ButtonStyle(
                            /*minimumSize: Size(double.infinity, 40),
                            maximumSize: Size(double.infinity, 40),
                            backgroundColor: Colors.white,
                            borderSide: BorderSide(
                              color: Color(0xFFE0E3E7),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(40),*/
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}