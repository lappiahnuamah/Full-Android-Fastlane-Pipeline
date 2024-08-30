import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/api_urls/user_url.dart';
import 'package:savyminds/providers/user_details_provider.dart';

import '../constants.dart';
import '../utils/connection_check.dart';

class UserFunctions {
  static Future<String?> updateProfilePicture({
    required BuildContext context,
    required String displayImage,
  }) async {
    if (await ConnectionCheck().hasConnection()) {
      try {
        final userProvider =
            Provider.of<UserDetailsProvider>(context, listen: false);
        final accessToken = userProvider.getAccessToken();
        final userID = userProvider.getUserDetails().id ?? 0;
        Map<String, dynamic> _data = {
          'image': await MultipartFile.fromFile(displayImage)
        };

        var formData = FormData.fromMap(_data);

        var _res = await Dio().patch("${UserUrl.profileUpdate}$userID/",
            data: formData,
            options: Options(
              contentType: 'multipart/form-data',
              headers: {"Authorization": "Bearer  $accessToken"},
              responseType: ResponseType.json,
            ));
        if (_res.statusCode == 200) {
          final data = _res.data;
          lg("Data response: $data");

          userProvider.setProfileImage(data['image']);
          return data['image'];
        } else {
          lg('${_res.data}');
          return null;
        }
      } catch (e) {
        lg('e: $e');
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<bool> updateAgeGroup({
    required BuildContext context,
    required String ageGroup,
  }) async {
    if (await ConnectionCheck().hasConnection()) {
      try {
        final userProvider =
            Provider.of<UserDetailsProvider>(context, listen: false);
        final accessToken = userProvider.getAccessToken();
        final userID = userProvider.getUserDetails().id ?? 0;
        Map<String, dynamic> _data = {'age_group': ageGroup};

        var formData = FormData.fromMap(_data);

        var _res = await Dio().patch("${UserUrl.profileUpdate}$userID/",
            data: formData,
            options: Options(
              contentType: 'multipart/form-data',
              headers: {"Authorization": "Bearer  $accessToken"},
              responseType: ResponseType.json,
            ));
        if (_res.statusCode == 200) {
          userProvider.setAgeGroup(ageGroup);
          log('age set successfully');
          return true;
        } else {
          lg('${_res.data}');
          return false;
        }
      } catch (e) {
        lg('e: $e');
        return false;
      }
    } else {
      return false;
    }
  }
}
