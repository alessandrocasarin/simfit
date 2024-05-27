import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:simfit/models/activity.dart';
import 'package:simfit/models/calories.dart';
import 'package:simfit/models/heart_rate.dart';
import 'package:simfit/models/sleep.dart';
import 'package:simfit/models/steps.dart';

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

    dynamic data = jsonDecode(r.body)["data"];
    List<Activity> activities = [];
    for (var currentActivity in data["data"]) {
      activities.add(Activity.fromJson(data["date"], currentActivity));
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

    List<dynamic> data = jsonDecode(r.body)["data"];
    Map<DateTime, List<Activity>> weekActivities = {};
    for (var daydata in data) {
      List<Activity> dayActivities = [];
      String day = daydata["date"];
      for (var currentActivity in daydata["data"]) {
        dayActivities.add(Activity.fromJson(day, currentActivity));
      }
      weekActivities.update(DateFormat('yyyy-MM-dd').parse(day), (value) => dayActivities);
    }
    
    return weekActivities;
  }

  Future<List<HR>> getHRFromDay(DateTime day) async {
    final sp = await SharedPreferences.getInstance();
    String? patient = sp.getString('impactPatient');
    var header = await getBearer();
    String formattedDay = DateFormat('y-M-d').format(day);
    var r = await http.get(
      Uri.parse(
          '${Impact.baseUrl}/data/v1/heart_rate/patients/$patient/day/$formattedDay/'),
      headers: header,
    );
    if (r.statusCode != 200) return [];

    dynamic data = jsonDecode(r.body)["data"];
    List<HR> hr = [];
    for (var currentHR in data["data"]) {
      hr.add(HR.fromJson(data["date"], currentHR));
    }

    var hrlist = hr.toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return hrlist;
  }

  Future<List<Calories>> getCaloriesFromDay(DateTime day) async {
    final sp = await SharedPreferences.getInstance();
    String? patient = sp.getString('impactPatient');
    var header = await getBearer();
    String formattedDay = DateFormat('y-M-d').format(day);
    var r = await http.get(
      Uri.parse(
          '${Impact.baseUrl}/data/v1/calories/patients/$patient/day/$formattedDay/'),
      headers: header,
    );
    if (r.statusCode != 200) return [];

    dynamic data = jsonDecode(r.body)["data"];
    List<Calories> calories = [];
    for (var currentCals in data["data"]) {
      calories.add(Calories.fromJson(data["date"], currentCals));
    }

    var calorieslist = calories.toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return calorieslist;
  }

  Future<List<Steps>> getStepsFromDay(DateTime day) async {
    final sp = await SharedPreferences.getInstance();
    String? patient = sp.getString('impactPatient');
    var header = await getBearer();
    String formattedDay = DateFormat('yyyy-MM-dd').format(day);
    var r = await http.get(
      Uri.parse(
          '${Impact.baseUrl}/data/v1/steps/patients/$patient/day/$formattedDay/'),
      headers: header,
    );
    if (r.statusCode != 200) return [];

    dynamic data = jsonDecode(r.body)["data"];
    List<Steps> steps = [];
    for (var currentSteps in data["data"]) {
      steps.add(Steps.fromJson(data["date"], currentSteps));
    }

    var stepslist = steps.toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return stepslist;
  }

  Future<List<Sleep>> getSleepsFromDay(DateTime day) async {
    final sp = await SharedPreferences.getInstance();
    String? patient = sp.getString('impactPatient');
    var header = await getBearer();
    String formattedDay = DateFormat('yyyy-M-d').format(day);
    var r = await http.get(
      Uri.parse(
          '${Impact.baseUrl}/data/v1/sleep/patients/$patient/day/$formattedDay/'),
      headers: header,
    );
    if (r.statusCode != 200) return [];

    dynamic data = jsonDecode(r.body)["data"];
    List<Sleep> sleeps = [];
    for (var currentSleep in data["data"]) {
      sleeps.add(Sleep.fromJson(data["date"], currentSleep));
    }
    return sleeps;
  }

} //Impact
