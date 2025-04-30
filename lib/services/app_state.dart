import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  String? _userEmail;
  double _heatingTemp = 22.0;

  String? get userEmail => _userEmail;
  double get heatingTemp => _heatingTemp;

  Future<void> loadUserSettings(String email) async {
    _userEmail = email;
    final prefs = await SharedPreferences.getInstance();

    _heatingTemp = prefs.getDouble('heating_temp_$email') ?? 22.0;

    notifyListeners();
  }

  Future<void> setHeatingTemp(double value) async {
    _heatingTemp = value;
    notifyListeners();

    if (_userEmail != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('heating_temp_${_userEmail!}', value);
    }
  }
}
