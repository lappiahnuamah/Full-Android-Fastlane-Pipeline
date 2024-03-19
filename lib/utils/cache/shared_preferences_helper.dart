import 'dart:convert';

import 'package:savyminds/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final SharedPreferencesHelper _instance =
      SharedPreferencesHelper._internal();

  SharedPreferencesHelper._internal();

  factory SharedPreferencesHelper() {
    return _instance;
  }

  static SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    _instance.getValue(key: kIsLoggedInKey) ??
        _instance.saveValue(key: kIsLoggedInKey, value: false);

    _instance.getValue(key: kAppUser) ??
        _instance.saveValue(key: kAppUser, value: json.encode("{}"));

    _instance.getValue(key: kFileDownloads) ??
        _instance.saveValue(key: kFileDownloads, value: json.encode([]));

    _instance.getValue(key: kDatabasePermission) ??
        _instance.saveValue(key: kDatabasePermission, value: false);

    _instance.getValue(key: kLastMessageIndex) ??
        _instance.saveValue(key: kLastMessageIndex, value: 1);
    _instance.getValue(key: kJobs) ??
        _instance.saveValue(key: kJobs, value: json.encode([]));
  }

  saveValue({required String key, required dynamic value}) {
    if (value is String) {
      return _prefs!.setString(key, value);
    } else if (value is int) {
      return _prefs!.setInt(key, value);
    } else if (value is double) {
      return _prefs!.setDouble(key, value);
    } else if (value is bool) {
      return _prefs!.setBool(key, value);
    } else if (value is List<String>) {
      return _prefs!.setStringList(key, value);
    } else {
      return false;
    }
  }

  getValue({required String key}) {
    return _prefs!.get(key);
  }

  Future<bool> removeValue({required String key}) async {
    return _prefs!.remove(key);
  }

  removeAll() async {
    _prefs!.clear();
  }
}
