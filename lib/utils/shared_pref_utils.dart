import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtils {
  static SharedPreferences? prefs;

  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> putStringList(String key, List<String> list) async {
    return prefs!.setStringList(key, list);
  }

  static List<String>? getStringList(String key) {
    return prefs!.getStringList(key);
  }

  static Future<bool>? putObjectList(String key, List<Object> list) async {
    if (prefs == null) return false;
    List<String>? dataList = list.map((value) {
      return json.encode(value);
    }).toList();
    return prefs!.setStringList(key, dataList);
  }

  int? getInt(String key) {
    return prefs?.getInt(key);
  }

  String? getString(String key) {
    return prefs?.getString(key);
  }

  //////////////////////////////////////
/////////////////   SET  /////////////
  Future<bool> setInt({required String key, required int value}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(key, value);
  }

  Future<bool> setString({required String key, required String value}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }
}
