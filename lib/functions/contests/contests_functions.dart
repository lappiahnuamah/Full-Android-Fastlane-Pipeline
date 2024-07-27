import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:savyminds/api_urls/game_url.dart';
import 'package:savyminds/api_urls/quest_url.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/data/shared_preference_values.dart';
import 'package:savyminds/models/http_response_model.dart';
import 'package:savyminds/models/solo_quest/game_type_rank_model.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/providers/contest_provider.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:savyminds/utils/cache/shared_preferences_helper.dart';
import 'package:savyminds/utils/connection_check.dart';

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

  Future<List<GameTypeRankModel>> getGameTypeRank(
      {required BuildContext context, required String gameType}) async {
    final hasConnection = await ConnectionCheck().hasConnection();
    try {
      if (hasConnection) {
        if (context.mounted) {
          String accessToken =
              Provider.of<UserDetailsProvider>(context, listen: false)
                  .getAccessToken();

          final response = await http.get(
            Uri.parse(
                GameUrl.gameTypePointsMyRank + "?game_type__mode=$gameType"),
            headers: {
              "content-type": "application/json",
              "accept": "application/json",
              "Authorization": "Bearer $accessToken"
            },
          );
          log('game type: ${response.body}');
          if (response.statusCode == 200) {
            return ((jsonDecode(response.body)['results'] ?? []) as List)
                .map((e) => GameTypeRankModel.fromJson(e))
                .toList();
          } else {
            return [];
          }
        }
      } else {
        return [];
      }
      return [];
    } catch (e) {
      log("message: $e");
      return [];
    }
  }

  Future<dynamic> submitGameTypePoints(
      {required BuildContext context,
      required int gameType,
      required int totalPoints}) async {
    final String accessToken =
        Provider.of<UserDetailsProvider>(context, listen: false)
            .getAccessToken();

    try {
      final response = await http.post(Uri.parse(GameUrl.gameTypePoints),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            "Authorization": "Bearer $accessToken"
          },
          body:
              jsonEncode({'game_type': gameType, 'total_points': totalPoints}));
      lg('point submit: ${response.body} : points: $totalPoints');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      lg(e);
      return null;
    }
  }
}
