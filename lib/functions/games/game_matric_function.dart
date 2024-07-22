import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/api_urls/category_url.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/data/shared_preference_values.dart';
import 'package:savyminds/models/games/game_type_matrice_model.dart';
import 'package:savyminds/models/http_response_model.dart';
import 'package:savyminds/providers/game_metric_provider.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:http/http.dart' as http;
import 'package:savyminds/utils/cache/shared_preferences_helper.dart';

class GameMatricFunction {
  //Get all game matrics
  Future<HttpResponseModel?> getGameMatrics(
      {required BuildContext context, String? nextUrl}) async {
    final String accessToken =
        Provider.of<UserDetailsProvider>(context, listen: false)
            .getAccessToken();
    final gameMetricsProvider =
        Provider.of<GameMetricsProvider>(context, listen: false);

    try {
      final response = await http.get(
        Uri.parse(nextUrl ?? CategoryUrl.gameMatrics),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $accessToken"
        },
      );
      if (response.statusCode == 200) {
        SharedPreferencesHelper.setString(
            key: SharedPreferenceValues.allMetrics, value: response.body);

        final data = jsonDecode(response.body);
        final result = HttpResponseModel.fromJson(data).toGameTypeMatricList();
        for (var element in result) {
          gameMetricsProvider.addGameTypeMetric(element);
        }
        return HttpResponseModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      lg('Game MatricsError : $e');

      return null;
    }
  }

  //Get a game matric
  Future<GameTypeMatric?> getGameMatric(
      {required BuildContext context, String? nextUrl, required int id}) async {
    final String accessToken =
        Provider.of<UserDetailsProvider>(context, listen: false)
            .getAccessToken();

    try {
      final response = await http.get(
        Uri.parse(nextUrl ?? "${CategoryUrl.gameMatrics}$id"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $accessToken"
        },
      );
      // log('categories:${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return GameTypeMatric.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
