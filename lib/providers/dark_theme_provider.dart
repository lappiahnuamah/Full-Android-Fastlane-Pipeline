import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemeProvider with ChangeNotifier {
  int? _darkTheme;

////
//////////////////////////////////////////
  ///0 is system default ///////////
  ///1 is light theme //////////////
  /// 2 is dark theme //////////////
  DarkThemeProvider();

  setTheme(int type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _darkTheme = type;
    prefs.setInt('DarkMode', type);

    notifyListeners();
  }

  Future getThemeFromPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final deTheme = prefs.getInt('DarkMode');
    log('theme:$deTheme');
    _darkTheme = deTheme ?? 0;
    notifyListeners();
  }

  int get theme {
    return _darkTheme ?? 0;
  }
}
