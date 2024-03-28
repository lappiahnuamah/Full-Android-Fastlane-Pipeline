import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:savyminds/api_urls/quest_url.dart';
import 'package:savyminds/data/shared_preference_values.dart';
import 'package:savyminds/models/http_response_model.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/providers/contest_provider.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:savyminds/utils/cache/shared_preferences_helper.dart';

class ContestFunctions {
  //Favorite Categories
  Future getQuests({required BuildContext context, String? nextUrl}) async {
    final String accessToken =
        Provider.of<UserDetailsProvider>(context, listen: false)
            .getAccessToken();
    final contestProvider =
        Provider.of<ContestProvider>(context, listen: false);
    List<QuestModel> contests = [];
    try {
      final response = await http.get(
        Uri.parse(nextUrl ?? '${QuestUrl.quests}?mode=Multiplayer'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $accessToken"
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final responseModel = HttpResponseModel.fromJson(data);
        for (var item in responseModel.results ?? []) {
          contests.add(QuestModel.fromJson(item));
        }
        contestProvider.setContests(contests);
        if (nextUrl == null) {
          //Save to shared preference
          SharedPreferencesHelper.setObjectList(
              SharedPreferenceValues.contests, responseModel.results ?? []);
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
