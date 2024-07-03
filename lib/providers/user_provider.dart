import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String? name;
  String? gender;
  DateTime? birthDate;
  int? age;
  int? mesocycleLength;
  DateTime? mesocycleStartDate;

  UserProvider() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ?? name;
    gender = prefs.getString('gender') ?? gender;

    String? bd = prefs.getString('birthDate');
    if (bd != null) {
      birthDate = DateUtils.dateOnly(DateFormat('yyyy-MM-dd').parse(bd));
    }

    age = _computeAge();

    mesocycleLength = prefs.getInt('mesocycleLength') ?? mesocycleLength;

    String? startDate = prefs.getString('mesocycleStart');
    if (startDate != null) {
      mesocycleStartDate = DateUtils.dateOnly(DateFormat('yyyy-MM-dd').parse(startDate));
    }
    
    notifyListeners();
  }

  Future<void> setUserData({
    required String newName,
    required String newGender,
    required String newBirthDate,
    required int newMesoLength,
    required String newMesoStart,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', newName);
    await prefs.setString('gender', newGender);
    await prefs.setString('birthDate', newBirthDate);
    await prefs.setInt('mesocycleLength', newMesoLength);
    await prefs.setString('mesocycleStart', newMesoStart);

    name = newName;
    gender = newGender;
    birthDate = DateUtils.dateOnly(DateFormat('yyyy-MM-dd').parse(newBirthDate));
    age = _computeAge();
    mesocycleLength = newMesoLength;
    mesocycleStartDate = DateUtils.dateOnly(DateFormat('yyyy-MM-dd').parse(newMesoStart));

    notifyListeners();
  }

  int _computeAge() {
    if (birthDate == null) return 0;
    DateTime today = DateTime.now();
    int years = today.year - birthDate!.year;
    int months = today.month - birthDate!.month;
    int days = today.day - birthDate!.day;

    if (months < 0 || (months == 0 && days < 0)) {
      years--;
    }

    return years;
  }
}