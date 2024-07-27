import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:savyminds/api_urls/auth_url.dart';
import 'package:savyminds/providers/user_details_provider.dart';

class ProfileFunctions {
  Future<bool> updateDisplayName(
      {required BuildContext context, required String displayName}) async {
    final String accessToken =
        Provider.of<UserDetailsProvider>(context, listen: false)
            .getAccessToken();
    final user = Provider.of<UserDetailsProvider>(context, listen: false)
        .getUserDetails();
    try {
      http.Response response =
          await http.patch(Uri.parse(AuthUrl.profile + '${user.id}/'),
              headers: {
                "content-type": "application/json",
                "accept": "application/json",
                "Authorization": " Bearer $accessToken"
              },
              body: json.encode({"display_name": displayName}));

      log('update: ${response.body}');
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
