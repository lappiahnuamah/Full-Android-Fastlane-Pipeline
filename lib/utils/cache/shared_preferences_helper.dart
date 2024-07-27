import 'dart:convert';

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
  }

  getValue({required String key}) {
    return _prefs?.get(key);
  }

  Future<bool> removeValue({required String key}) async {
    return _prefs!.remove(key);
  }

  removeAll() async {
    _prefs!.clear();
  }

  //////////////////////////////////////
/////////////////   SET  /////////////
  static Future<bool?> setInt({required String key, required int value}) async {
    return _prefs?.setInt(key, value);
  }

  static Future<bool?> setString(
      {required String key, required String? value}) async {
    return _prefs?.setString(key, value ?? '');
  }

  static Future<bool?> setStringList(String key, List<String> list) async {
    return _prefs?.setStringList(key, list);
  }

  static Future<bool?> setBool(String key, bool value) async {
    return _prefs?.setBool(key, value);
  }

  static Future<bool?> setObjectList(String key, List<dynamic> list) async {
    if (_prefs == null) return false;
    List<String>? dataList = list.map((value) {
      return json.encode(value);
    }).toList();
    return _prefs?.setStringList(key, dataList);
  }

  //////////////////////////////////////
/////////////////   Get  /////////////

  static String getString(String key) {
    return _prefs?.getString(key) ?? '';
  }

  static List<String>? getStringList(String key) {
    return _prefs?.getStringList(key);
  }

  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  static Object? getObject(String key) {
    String? data = _prefs?.getString(key);
    return json.decode(data!);
  }

  // Clear cache
  static clearCache() {
    _prefs?.clear();
  }
}
