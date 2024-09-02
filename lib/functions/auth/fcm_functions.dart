import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:savyminds/api_urls/auth_url.dart';
import 'package:savyminds/data/shared_preference_values.dart';
import 'package:savyminds/utils/cache/shared_preferences_helper.dart';

class FCMFunctions {
  Future setFCMToken(String? token) async {
    String accessToken =
        SharedPreferencesHelper.getString(SharedPreferenceValues.accessToken);

    try {
      final response = await http.post(
        Uri.parse('${AuthUrl.baseUrl}set-fcm-token/'),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": " Bearer $accessToken"
        },
        body: json.encode({"fcm_app_token": token}),
      );
      log('token update: ${response.body}');
      if (response.statusCode == 200) {
        debugPrint(response.body);
        return true;
      } else {
        debugPrint('Update failed');
        return false;
      }
    } catch (e) {
      debugPrint('Update failed');
      return false;
    }
  }
}
