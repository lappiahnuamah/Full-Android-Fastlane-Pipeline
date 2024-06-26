import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:savyminds/data/fcm_data.dart';
import 'package:savyminds/functions/auth/fcm_functions.dart';
import 'package:savyminds/models/auth/app_user.dart';

class UserDetailsProvider extends ChangeNotifier {
  // ignore: prefer_final_fields
  AppUser? _user;
  String? _accessToken;

  AppUser getUserDetails() {
    return _user ?? AppUser();
  }

  void setUserDetails(AppUser user) {
    _user = user;
    notifyListeners();
  }

  ///////////////////////////////////////////////////////////
  /////////////////// Access Token Functions  ///////////////
  String getAccessToken() {
    return _accessToken ?? '';
  }

  void setAccessToken(String token) {
    _accessToken = token;
    notifyListeners();
  }

  Future sendUserToken(AppUser user) async {
    FirebaseMessaging.instance
        .getToken(vapidKey: FcmData.webTOken)
        .then((value) async {
      value != null ? await FCMFunctions().setFCMToken(value) : null;
    });
  }
}
