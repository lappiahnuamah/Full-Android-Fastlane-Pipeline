import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:savyminds/api_urls/user_url.dart';
import 'package:savyminds/utils/cache/save_secure.dart';

class FCMFunctions {
  Future setFCMToken(String ?token, int id) async {
    Map<String, String> allValues = await allSecureStorage();
    String accessToken = allValues['accessToken'] ?? '';

    try {
      final response = await http.patch(
        Uri.parse('${UserUrl.userDetails}$id/set-fcm-token/'),
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
