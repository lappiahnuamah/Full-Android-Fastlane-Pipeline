import 'dart:convert';
import 'dart:developer';

import 'package:provider/provider.dart';
import 'package:savyminds/api_urls/game_url.dart';
import 'package:savyminds/models/game_type_level_model.dart';
import 'package:savyminds/providers/game_type_provider.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:http/http.dart' as http;

class GeneralFuntions {
  Future getGameTypeLevel(context, int id) async {
    final String accessToken =
        Provider.of<UserDetailsProvider>(context, listen: false)
            .getAccessToken();

    GameTypeProvider gameTypeProvider =
        Provider.of<GameTypeProvider>(context, listen: false);
    try {
      final response = await http.get(
        Uri.parse('${GameUrl.getGameTypeLevel(id)}'),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": " Bearer $accessToken"
        },
      );
      if (response.statusCode == 200) {
        final level = GameTypelevelModel.fromJson(jsonDecode(response.body));
        gameTypeProvider.setGameTypeLevel(id, level);
        return level;
      } else {
        return null;
      }
    } catch (e) {
      log('$e');
      return null;
    }
  }
}
