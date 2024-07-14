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

// Class `Impact` providing methods to interact with IMPACT API
class Impact {
  // Base URL and endpoints for IMPACT API
  static String baseUrl = 'https://impact.dei.unipd.it/bwthw/';
  static String pingEndpoint = 'gate/v1/ping/';
  static String tokenEndpoint = 'gate/v1/token/';
  static String refreshEndpoint = 'gate/v1/refresh/';

  // Static patient username for API calls
  static String patientUsername = 'Jpefaq6m58';

  // Method to check if the IMPACT backend is operational
  Future<bool> isImpactUp() async {
    final url = Impact.baseUrl + Impact.pingEndpoint; // Constructing the endpoint URL
    print('Calling: $url'); // Logging the API call
    final response = await http.get(Uri.parse(url)); // Performing the HTTP GET request
    return response.statusCode == 200; // Returning true if response status code is 200
  } //_isImpactUp

  // Method to obtain and store JWT tokens in SharedPreferences
  Future<int> getAndStoreTokens(String username, String password) async {
    final url = Impact.baseUrl + Impact.tokenEndpoint; // Constructing the endpoint URL
    final body = {'username': username, 'password': password}; // Request body
    print('Calling: $url'); // Logging the API call
    final response = await http.post(Uri.parse(url), body: body); // Performing HTTP POST request

    // If response is successful (status code 200), store tokens in SharedPreferences
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      await sp.setString('access', decodedResponse['access']); // Storing access token
      await sp.setString('refresh', decodedResponse['refresh']); // Storing refresh token
    } //if

    return response.statusCode; // Returning the HTTP status code
  } //_getAndStoreTokens

  // Method to refresh the stored JWT token in SharedPreferences
  Future<int> refreshTokens() async {
    final url = Impact.baseUrl + Impact.refreshEndpoint; // Constructing the endpoint URL
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString('refresh'); // Retrieving refresh token from SharedPreferences
    if (refresh != null) {
      final body = {'refresh': refresh}; // Request body with refresh token
      print('Calling: $url'); // Logging the API call
      final response = await http.post(Uri.parse(url), body: body); // Performing HTTP POST request

      // If response is successful (status code 200), update tokens in SharedPreferences
      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        final sp = await SharedPreferences.getInstance();
        await sp.setString('access', decodedResponse['access']); // Updating access token
        await sp.setString('refresh', decodedResponse['refresh']); // Updating refresh token
      } //if

      return response.statusCode; // Returning the HTTP status code
    }
    return 401; // Returning 401 if refresh token is null
  } //_refreshTokens

  // Method to check if the saved token (access or refresh) is valid
  Future<bool> checkSavedToken({bool refresh = false}) async {
    final sp = await SharedPreferences.getInstance();
    final token = sp.getString(refresh ? 'refresh' : 'access'); // Retrieving token from SharedPreferences

    // Checking if token exists and is valid
    if (token == null) {
      return false;
    }
    try {
      return Impact.checkToken(token); // Calling static method to validate token
    } catch (_) {
      return false;
    }
  }

  // Static method to check if a given JWT token is valid (not expired)
  static bool checkToken(String token) {
    if (JwtDecoder.isExpired(token)) { // Using JwtDecoder library to check token expiry
      return false;
    }
    return true;
  } //checkToken

  // Method to prepare Bearer header for API calls
  Future<Map<String, String>> getBearer() async {
    if (!await checkSavedToken()) { // Checking if access token is valid
      if (!await checkSavedToken(refresh: true)) { // Checking if refresh token is valid
        final sp = await SharedPreferences.getInstance();
        String username = await sp.getString('username') ?? '';
        String password = await sp.getString('password') ?? '';
        await getAndStoreTokens(username, password); // Obtaining new tokens if both are invalid
      } else {
        await refreshTokens(); // Refreshing tokens if access token is invalid but refresh token is valid
      }
    }
    final sp = await SharedPreferences.getInstance();
    final token = sp.getString('access'); // Retrieving access token from SharedPreferences

    return {'Authorization': 'Bearer $token'}; // Returning Bearer token header
  }

  // Method to fetch daily activities from IMPACT API for a given date
  Future<List<Activity>> getActivitiesFromDay(DateTime day) async {
    var header = await getBearer(); // Retrieving Bearer header
    String formattedDay = DateFormat('yyyy-MM-dd').format(day); // Formatting date
    var r = await http.get(
      Uri.parse(
          '${Impact.baseUrl}/data/v1/exercise/patients/$patientUsername/day/$formattedDay/'),
      headers: header, // Including Bearer header in HTTP GET request
    );
    if (r.statusCode != 200) return []; // Returning empty list if request fails

    dynamic data = jsonDecode(r.body)["data"]; // Decoding JSON response
    if (data.isNotEmpty) {
      List<Activity> activities = [];
      for (var currentActivity in data["data"]) {
        activities.add(Activity.fromJson(data["date"], currentActivity)); // Parsing activity data
      }
      return activities;
    }
    return []; // Returning empty list if data is empty
  }

  // Method to fetch activities from IMPACT API within a specified date range
  Future<Map<DateTime, List<Activity>>> getActivitiesFromDateRange(
      DateTime start, DateTime end) async {
    Map<DateTime, List<Activity>> activities = {}; // Initializing activities map

    if (start.isAtSameMomentAs(end)) { // Checking if start and end dates are the same
      activities[start] = await getActivitiesFromDay(start); // Fetching activities for single day
      return activities;
    }

    List<Map<String, String>> formattedStartEnd =
        _formatFromRangeToWeeks(start, end); // Formatting date range
    for (var element in formattedStartEnd) {
      var header = await getBearer(); // Retrieving Bearer header
      var r = await http.get(
        Uri.parse(
            '${Impact.baseUrl}/data/v1/exercise/patients/$patientUsername/daterange/start_date/${element['start']}/end_date/${element['end']}/'),
        headers: header, // Including Bearer header in HTTP GET request
      );
      if (r.statusCode == 200) {
        List<dynamic> data = jsonDecode(r.body)["data"];
        if (data.isNotEmpty) {
          for (var daydata in data) {
            List<Activity> dayActivities = [];
            String day = daydata["date"];
            for (var currentActivity in daydata["data"]) {
              dayActivities.add(Activity.fromJson(day, currentActivity)); // Parsing activity data
            }
            activities[DateFormat('yyyy-MM-dd').parse(day)] = dayActivities; // Adding activities to map
          }
        }
      }
    }
    return activities; // Returning activities map
  }

  // Method to fetch heart rate data from IMPACT API for a given day
  Future<List<HR>> getHRFromDay(DateTime day) async {
    var header = await getBearer(); // Retrieving Bearer header
    String formattedDay = DateFormat('yyyy-MM-dd').format(day); // Formatting date
    var r = await http.get(
      Uri.parse(
          '${Impact.baseUrl}/data/v1/heart_rate/patients/$patientUsername/day/$formattedDay/'),
      headers: header, // Including Bearer header in HTTP GET request
    );
    if (r.statusCode != 200) return []; // Returning empty list if request fails

    dynamic data = jsonDecode(r.body)["data"]; // Decoding JSON response
    if (data.isNotEmpty) {
      List<HR> hr = [];
      for (var currentHR in data["data"]) {
        hr.add(HR.fromJson(data["date"], currentHR)); // Parsing heart rate data
      }

      var hrlist = hr.toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp)); // Sorting heart rate data
      return hrlist; // Returning sorted heart rate list
    }
    return []; // Returning empty list if data is empty
  }

  // Method to fetch calories data from IMPACT API for a given day
  Future<List<Calories>> getCaloriesFromDay(DateTime day) async {
    var header = await getBearer(); // Retrieving Bearer header
    String formattedDay = DateFormat('yyyy-MM-dd').format(day); // Formatting date
    var r = await http.get(
      Uri.parse(
          '${Impact.baseUrl}/data/v1/calories/patients/$patientUsername/day/$formattedDay/'),
      headers: header, // Including Bearer header in HTTP GET request
    );
    if (r.statusCode != 200) return []; // Returning empty list if request fails

    dynamic data = jsonDecode(r.body)["data"]; // Decoding JSON response
    if (data.isNotEmpty) {
      List<Calories> calories = [];
      for (var currentCals in data["data"]) {
        calories.add(Calories.fromJson(data["date"], currentCals)); // Parsing calories data
      }

      var calorieslist = calories.toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp)); // Sorting calories data
      return calorieslist; // Returning sorted calories list
    }
    return []; // Returning empty list if data is empty
  }

  // Method to fetch steps data from IMPACT API for a given day
  Future<List<Steps>> getStepsFromDay(DateTime day) async {
    var header = await getBearer(); // Retrieving Bearer header
    String formattedDay = DateFormat('yyyy-MM-dd').format(day); // Formatting date
    var r = await http.get(
      Uri.parse(
          '${Impact.baseUrl}/data/v1/steps/patients/$patientUsername/day/$formattedDay/'),
      headers: header, // Including Bearer header in HTTP GET request
    );
    if (r.statusCode != 200) return []; // Returning empty list if request fails

    dynamic data = jsonDecode(r.body)["data"]; // Decoding JSON response
    if (data.isNotEmpty) {
      List<Steps> steps = [];
      for (var currentSteps in data["data"]) {
        steps.add(Steps.fromJson(data["date"], currentSteps)); // Parsing steps data
      }

      var stepslist = steps.toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp)); // Sorting steps data
      return stepslist; // Returning sorted steps list
    }
    return []; // Returning empty list if data is empty
  }

  // Method to fetch sleep data from IMPACT API for a given day
  Future<List<Sleep>> getSleepsFromDay(DateTime day) async {
    var header = await getBearer(); // Retrieving Bearer header
    String formattedDay = DateFormat('yyyy-MM-dd').format(day); // Formatting date
    var r = await http.get(
      Uri.parse(
          '${Impact.baseUrl}/data/v1/sleep/patients/$patientUsername/day/$formattedDay/'),
      headers: header, // Including Bearer header in HTTP GET request
    );
    if (r.statusCode != 200) return []; // Returning empty list if request fails

    dynamic data = jsonDecode(r.body)["data"]; // Decoding JSON response
    if (data.isNotEmpty) {
      List<Sleep> sleeps = [];
      if (data["data"] is List) {
        for (var currentSleep in data["data"]) {
          sleeps.add(Sleep.fromJson(data["date"], currentSleep)); // Parsing sleep data
        }
      } else if (data["data"] is Map) {
        sleeps.add(Sleep.fromJson(data["date"], data["data"])); // Parsing sleep data
      }
      return sleeps; // Returning sleep list
    }
    return []; // Returning empty list if data is empty
  }

  // Method to fetch resting heart rate data from IMPACT API for a given day
  Future<double> getRestHRFromDay(DateTime day) async {
    var header = await getBearer(); // Retrieving Bearer header
    String formattedDay = DateFormat('yyyy-MM-dd').format(day); // Formatting date
    var r = await http.get(
      Uri.parse(
          '${Impact.baseUrl}/data/v1/resting_heart_rate/patients/$patientUsername/day/$formattedDay/'),
      headers: header, // Including Bearer header in HTTP GET request
    );
    if (r.statusCode != 200) return 0.0; // Returning 0.0 if request fails

    dynamic data = jsonDecode(r.body)["data"]; // Decoding JSON response
    if (data.isNotEmpty) {
      return data["data"]["value"] ?? 0.0; // Returning resting heart rate value
    }
    return 0.0; // Returning 0.0 if data is empty
  }

  // Method to fetch resting heart rate data from IMPACT API within a specified date range
  Future<Map<DateTime, double>> getRestHRsFromDateRange(
      DateTime start, DateTime end) async {
    Map<DateTime, double> restHRs = {}; // Initializing resting heart rates map

    List<Map<String, String>> formattedStartEnd =
        _formatFromRangeToWeeks(start, end); // Formatting date range

    for (Map<String, String> element in formattedStartEnd) {
      var header = await getBearer(); // Retrieving Bearer header
      var r = await http.get(
        Uri.parse(
            '${Impact.baseUrl}/data/v1/resting_heart_rate/patients/$patientUsername/daterange/start_date/${element['start']}/end_date/${element['end']}/'),
        headers: header, // Including Bearer header in HTTP GET request
      );
      if (r.statusCode == 200) {
        List<dynamic> data = jsonDecode(r.body)["data"];
        for (var daydata in data) {
          String day = daydata["date"];
          double dayRestHR = daydata["data"]["value"];
          restHRs[DateFormat('yyyy-MM-dd').parse(day)] = dayRestHR; // Adding resting heart rate to map
        }
      }
    }

    return restHRs; // Returning resting heart rates map
  }

  // Method to convert date range to list of weeks with start and end dates
  List<Map<String, String>> _formatFromRangeToWeeks(
      DateTime start, DateTime end) {
    List<Map<String, String>> weeks = []; // Initializing list of weeks

    // Calculating complete weeks and remaining days
    int daysRange = end.difference(start).inDays + 1;
    int completeWeeks = daysRange ~/ 7;
    int remainingDays = daysRange % 7;

    // Adding complete weeks to list
    for (int week = 0; week < completeWeeks; week++) {
      DateTime weekStart = start.add(Duration(days: week * 7));
      DateTime weekEnd = weekStart.add(Duration(days: 6));

      String formattedStart = DateFormat('yyyy-MM-dd').format(weekStart); // Formatting start date
      String formattedEnd = DateFormat('yyyy-MM-dd').format(weekEnd); // Formatting end date

      weeks.add({
        'start': formattedStart,
        'end': formattedEnd,
      });
    }

    // Adding remaining days to list if any
    if (remainingDays > 0) {
      DateTime remainingStart = start.add(Duration(days: completeWeeks * 7));
      DateTime remainingEnd = end;

      String formattedStart = DateFormat('yyyy-MM-dd').format(remainingStart); // Formatting start date
      String formattedEnd = DateFormat('yyyy-MM-dd').format(remainingEnd); // Formatting end date

      weeks.add({
        'start': formattedStart,
        'end': formattedEnd,
      });
    }

    return weeks; // Returning list of weeks
  }
} //Impact
