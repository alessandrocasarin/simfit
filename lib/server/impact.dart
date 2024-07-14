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

  static String patientUsername = 'Jpefaq6m58';

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
      if (!await checkSavedToken(refresh: true)) {
        final sp = await SharedPreferences.getInstance();
        String username = await sp.getString('username') ?? '';
        String password = await sp.getString('password') ?? '';
        await getAndStoreTokens(username, password);
      } else {
        await refreshTokens();
      }
    }
    final sp = await SharedPreferences.getInstance();
    final token = sp.getString('access');

    return {'Authorization': 'Bearer $token'};
  }

  Future<List<Activity>> getActivitiesFromDay(DateTime day) async {
    var header = await getBearer();
    String formattedDay = DateFormat('yyyy-MM-dd').format(day);
    var r = await http.get(
      Uri.parse(
          '${Impact.baseUrl}/data/v1/exercise/patients/$patientUsername/day/$formattedDay/'),
      headers: header,
    );
    if (r.statusCode != 200) return [];

    dynamic data = jsonDecode(r.body)["data"];
    if (data.isNotEmpty) {
      List<Activity> activities = [];
      for (var currentActivity in data["data"]) {
        activities.add(Activity.fromJson(data["date"], currentActivity));
      }
      return activities;
    }
    return [];
  }

  Future<Map<DateTime, List<Activity>>> getActivitiesFromDateRange(
      DateTime start, DateTime end) async {
    Map<DateTime, List<Activity>> activities = {};

    if (start.isAtSameMomentAs(end)) {
      activities[start] = await getActivitiesFromDay(start);
      return activities;
    }

    List<Map<String, String>> formattedStartEnd =
        _formatFromRangeToWeeks(start, end);
    for (var element in formattedStartEnd) {
      var header = await getBearer();
      var r = await http.get(
        Uri.parse(
            '${Impact.baseUrl}/data/v1/exercise/patients/$patientUsername/daterange/start_date/${element['start']}/end_date/${element['end']}/'),
        headers: header,
      );
      if (r.statusCode == 200) {
        List<dynamic> data = jsonDecode(r.body)["data"];
        if (data.isNotEmpty) {
          for (var daydata in data) {
            List<Activity> dayActivities = [];
            String day = daydata["date"];
            for (var currentActivity in daydata["data"]) {
              dayActivities.add(Activity.fromJson(day, currentActivity));
            }
            activities[DateFormat('yyyy-MM-dd').parse(day)] = dayActivities;
          }
        }
      }
    }
    return activities;
  }

  Future<List<HR>> getHRFromDay(DateTime day) async {
    var header = await getBearer();
    String formattedDay = DateFormat('yyyy-MM-dd').format(day);
    var r = await http.get(
      Uri.parse(
          '${Impact.baseUrl}/data/v1/heart_rate/patients/$patientUsername/day/$formattedDay/'),
      headers: header,
    );
    if (r.statusCode != 200) return [];

    dynamic data = jsonDecode(r.body)["data"];
    if (data.isNotEmpty) {
      List<HR> hr = [];
      for (var currentHR in data["data"]) {
        hr.add(HR.fromJson(data["date"], currentHR));
      }

      var hrlist = hr.toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return hrlist;
    }
    return [];
  }

  Future<List<Calories>> getCaloriesFromDay(DateTime day) async {
    var header = await getBearer();
    String formattedDay = DateFormat('yyyy-MM-dd').format(day);
    var r = await http.get(
      Uri.parse(
          '${Impact.baseUrl}/data/v1/calories/patients/$patientUsername/day/$formattedDay/'),
      headers: header,
    );
    if (r.statusCode != 200) return [];

    dynamic data = jsonDecode(r.body)["data"];
    if (data.isNotEmpty) {
      List<Calories> calories = [];
      for (var currentCals in data["data"]) {
        calories.add(Calories.fromJson(data["date"], currentCals));
      }

      var calorieslist = calories.toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return calorieslist;
    }
    return [];
  }

  Future<List<Steps>> getStepsFromDay(DateTime day) async {
    var header = await getBearer();
    String formattedDay = DateFormat('yyyy-MM-dd').format(day);
    var r = await http.get(
      Uri.parse(
          '${Impact.baseUrl}/data/v1/steps/patients/$patientUsername/day/$formattedDay/'),
      headers: header,
    );
    if (r.statusCode != 200) return [];

    dynamic data = jsonDecode(r.body)["data"];
    if (data.isNotEmpty) {
      List<Steps> steps = [];
      for (var currentSteps in data["data"]) {
        steps.add(Steps.fromJson(data["date"], currentSteps));
      }

      var stepslist = steps.toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return stepslist;
    }
    return [];
  }

  Future<List<Sleep>> getSleepsFromDay(DateTime day) async {
    var header = await getBearer();
    String formattedDay = DateFormat('yyyy-MM-dd').format(day);
    var r = await http.get(
      Uri.parse(
          '${Impact.baseUrl}/data/v1/sleep/patients/$patientUsername/day/$formattedDay/'),
      headers: header,
    );
    if (r.statusCode != 200) return [];

    dynamic data = jsonDecode(r.body)["data"];
    if (data.isNotEmpty) {
      List<Sleep> sleeps = [];
      if (data["data"] is List) {
        for (var currentSleep in data["data"]) {
          sleeps.add(Sleep.fromJson(data["date"], currentSleep));
        }
      } else if (data["data"] is Map) {
        sleeps.add(Sleep.fromJson(data["date"], data["data"]));
      }
      return sleeps;
    }
    return [];
  }

  Future<double> getRestHRFromDay(DateTime day) async {
    var header = await getBearer();
    String formattedDay = DateFormat('yyyy-MM-dd').format(day);
    var r = await http.get(
      Uri.parse(
          '${Impact.baseUrl}/data/v1/resting_heart_rate/patients/$patientUsername/day/$formattedDay/'),
      headers: header,
    );
    if (r.statusCode != 200) return 0.0;

    dynamic data = jsonDecode(r.body)["data"];
    if (data.isNotEmpty) {
      return data["data"]["value"] ?? 0.0;
    }
    return 0.0;
  }

  Future<Map<DateTime, double>> getRestHRsFromDateRange(
      DateTime start, DateTime end) async {
    Map<DateTime, double> restHRs = {};

    List<Map<String, String>> formattedStartEnd =
        _formatFromRangeToWeeks(start, end);

    for (Map<String, String> element in formattedStartEnd) {
      var header = await getBearer();
      var r = await http.get(
        Uri.parse(
            '${Impact.baseUrl}/data/v1/resting_heart_rate/patients/$patientUsername/daterange/start_date/${element['start']}/end_date/${element['end']}/'),
        headers: header,
      );
      if (r.statusCode == 200) {
        List<dynamic> data = jsonDecode(r.body)["data"];
        for (var daydata in data) {
          String day = daydata["date"];
          double dayRestHR = daydata["data"]["value"];
          restHRs[DateFormat('yyyy-MM-dd').parse(day)] = dayRestHR;
        }
      }
    }

    return restHRs;
  }

  List<Map<String, String>> _formatFromRangeToWeeks(
      DateTime start, DateTime end) {
    List<Map<String, String>> weeks = [];

    // Add one day to include the end date in the range
    int daysRange = end.difference(start).inDays + 1;
    int completeWeeks = daysRange ~/ 7;
    int remainingDays = daysRange % 7;

    // complete weeks
    for (int week = 0; week < completeWeeks; week++) {
      DateTime weekStart = start.add(Duration(days: week * 7));
      DateTime weekEnd = weekStart.add(Duration(days: 6));

      String formattedStart = DateFormat('yyyy-MM-dd').format(weekStart);
      String formattedEnd = DateFormat('yyyy-MM-dd').format(weekEnd);

      weeks.add({
        'start': formattedStart,
        'end': formattedEnd,
      });
    }

    // remaining days
    if (remainingDays > 0) {
      DateTime remainingStart = start.add(Duration(days: completeWeeks * 7));
      DateTime remainingEnd = end;

      String formattedStart = DateFormat('yyyy-MM-dd').format(remainingStart);
      String formattedEnd = DateFormat('yyyy-MM-dd').format(remainingEnd);

      weeks.add({
        'start': formattedStart,
        'end': formattedEnd,
      });
    }

    return weeks;
  }
} //Impact
