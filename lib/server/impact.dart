import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:simfit/models/activity.dart';

class Impact {
  static String baseUrl = 'https://impact.dei.unipd.it/bwthw/';
  static String pingEndpoint = 'gate/v1/ping/';
  static String tokenEndpoint = 'gate/v1/token/';
  static String refreshEndpoint = 'gate/v1/refresh/';

  //This method allows to check if the IMPACT backend is up
  Future<bool> isImpactUp() async {
    //Create the request
    final url = Impact.baseUrl + Impact.pingEndpoint;

    //Get the response
    print('Calling: $url');
    final response = await http.get(Uri.parse(url));

    //Just return if the status code is OK
    return response.statusCode == 200;
  } //_isImpactUp

  //This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences
  Future<int> getAndStoreTokens(String username, String password) async {
    //Create the request
    final url = Impact.baseUrl + Impact.tokenEndpoint;
    final body = {'username': username, 'password': password};

    //Get the response
    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    //If response is OK, decode it and store the tokens. Otherwise do nothing.
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      await sp.setString('access', decodedResponse['access']);
      await sp.setString('refresh', decodedResponse['refresh']);
    } //if

    //Just return the status code
    return response.statusCode;
  } //_getAndStoreTokens

  //This method allows to refrsh the stored JWT in SharedPreferences
  Future<int> refreshTokens() async {
    //Create the request
    final url = Impact.baseUrl + Impact.refreshEndpoint;
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString('refresh');
    if (refresh != null) {
      final body = {'refresh': refresh};

      //Get the response
      print('Calling: $url');
      final response = await http.post(Uri.parse(url), body: body);

      //If the response is OK, set the tokens in SharedPreferences to the new values
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        final sp = await SharedPreferences.getInstance();
        await sp.setString('access', decodedResponse['access']);
        await sp.setString('refresh', decodedResponse['refresh']);
      } //if

      //Just return the status code
      return response.statusCode;
    }
    return 401;
  } //_refreshTokens

  //This method checks if the saved token is still valid
  Future<bool> checkSavedToken({bool refresh = false}) async {
    final sp = await SharedPreferences.getInstance();
    final token = sp.getString(refresh ? 'refresh' : 'access');

    //Check if there is a token
    if (token == null) {
      return false;
    }
    try {
      return Impact.checkToken(token);
    } catch (_) {
      return false;
    }
  }

  static bool checkToken(String token) {
    //Check if the token is expired
    if (JwtDecoder.isExpired(token)) {
      return false;
    }
    return true;
  } //checkToken

  //This method prepares the Bearer header for the calls
  Future<Map<String, String>> getBearer() async {
    if (!await checkSavedToken()) {
      await refreshTokens();
    }
    final sp = await SharedPreferences.getInstance();
    final token = sp.getString('access');

    return {'Authorization': 'Bearer $token'};
  }

  Future<void> getPatient() async {
    var header = await getBearer();
    final r = await http.get(
        Uri.parse('${Impact.baseUrl}study/v1/patients/active'),
        headers: header);

    final decodedResponse = jsonDecode(r.body);
    final sp = await SharedPreferences.getInstance();

    sp.setString('impactPatient', decodedResponse['data'][0]['username']);
  }

  Future<List<Activity>> getActivitiesFromDay(DateTime day) async {
    final sp = await SharedPreferences.getInstance();
    String? patient = sp.getString('impactPatient');
    var header = await getBearer();
    String formattedDay = DateFormat('y-M-d').format(day);
    var r = await http.get(
      Uri.parse(
          '${Impact.baseUrl}/data/v1/exercise/patients/$patient/day/$formattedDay/'),
      headers: header,
    );
    if (r.statusCode != 200) return [];

    List<dynamic> data = jsonDecode(r.body)['data'];
    List<Activity> activities = [];
    for (var daydata in data) {
      for (var dataday in daydata[0]['data']) {
        Activity act = Activity(
            activityName: dataday['activityName'],
            avgHR: dataday['averageHeartRate'] ?? 0,
            calories: dataday['calories'] ?? 0,
            distance: dataday['distance'] ?? 0.0,
            duration: dataday['duration'] ?? 0.0,
            activeDuration: dataday['activeDuration'] ?? 0.0,
            zonesHR: List<HRZone>.from(dataday['heartRateZones'].map((zone) => HRZone.fromJson(zone))),
            avgSpeed: dataday['speed'] ?? 0.0,
            elevationGain: dataday['elevationGain'] ?? 0.0,
            startingTime: DateFormat('y-M-d').parse(dataday['time']),
            steps: dataday['steps'] ?? 0,
            vo2Max: dataday['vo2Max']['vo2Max'] ?? 0.0,
          );
        activities.add(act);
      }
    }
    return activities;
  }

  Future<Map<DateTime, List<Activity>>> getActivitiesFromDateRange(DateTime start, DateTime end) async {
    final sp = await SharedPreferences.getInstance();
    String? patient = sp.getString('impactPatient');
    var header = await getBearer();
    String formattedStart = DateFormat('y-M-d').format(start);
    String formattedEnd = DateFormat('y-M-d').format(end);
    var r = await http.get(
      Uri.parse(
          '${Impact.baseUrl}/data/v1/exercise/patients/$patient/daterange/start_date/$formattedStart/end_date/$formattedEnd/'),
      headers: header,
    );
    if (r.statusCode != 200) return <DateTime, List<Activity>>{};

    List<dynamic> data = jsonDecode(r.body)['data'];
    Map<DateTime, List<Activity>> weekActivities = {};
    for (var daydata in data) {
      List<Activity> dayActivities = [];
      for (var dataday in daydata['data']) {
        Activity act = Activity(
            activityName: dataday['activityName'],
            avgHR: dataday['averageHeartRate'] ?? 0,
            calories: dataday['calories'] ?? 0,
            distance: dataday['distance'] ?? 0.0,
            duration: dataday['duration'] ?? 0.0,
            activeDuration: dataday['activeDuration'] ?? 0.0,
            zonesHR: List<HRZone>.from(dataday['heartRateZones'].map((zone) => HRZone.fromJson(zone))),
            avgSpeed: dataday['speed'] ?? 0.0,
            elevationGain: dataday['elevationGain'] ?? 0.0,
            startingTime: DateFormat('y-M-d').parse(dataday['time']),
            steps: dataday['steps'] ?? 0,
            vo2Max: dataday['vo2Max']['vo2Max'] ?? 0.0,
          );
        dayActivities.add(act);
      }
      weekActivities.update(DateFormat('y-M-d').parse(daydata['date']), (value) => dayActivities);
    }
    return weekActivities;
  }

/*

  Future<void> getPatient() async {
    var header = await getBearer();
    final r = await http.get(
        Uri.parse('${Impact.baseUrl}study/v1/patients/active'),
        headers: header);

    final decodedResponse = jsonDecode(r.body);
    final sp = await SharedPreferences.getInstance();

    sp.setString('impactPatient', decodedResponse['data'][0]['username']);
  }

  Future<List<HR>> getDataFromDay(DateTime startTime) async {
    final sp = await SharedPreferences.getInstance();
    String? user = sp.getString('impactPatient');
    var header = await getBearer();
    var end = DateFormat('y-M-d').format(startTime);
    var start =
        DateFormat('y-M-d').format(startTime.subtract(const Duration(days: 1)));
    var r = await http.get(
      Uri.parse(
          '${Impact.baseUrl}data/v1/heart_rate/patients/$user/daterange/start_date/$start/end_date/$end/'),
      headers: header,
    );
    if (r.statusCode != 200) return [];

    List<dynamic> data = jsonDecode(r.body)['data'];
    List<HR> hr = [];
    for (var daydata in data) {
      String day = daydata['date'];
      for (var dataday in daydata['data']) {
        String hour = dataday['time'];
        String datetime = '${day}T$hour';
        DateTime timestamp = _truncateSeconds(DateTime.parse(datetime));
        HR hrnew = HR(timestamp: timestamp, value: dataday['value']);
        if (!hr.any((e) => e.timestamp.isAtSameMomentAs(hrnew.timestamp))) {
          hr.add(hrnew);
        }
      }
    }
    var hrlist = hr.toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return hrlist;
  }

  DateTime _truncateSeconds(DateTime input) {
    return DateTime(
        input.year, input.month, input.day, input.hour, input.minute);
  }

*/
} //Impact
