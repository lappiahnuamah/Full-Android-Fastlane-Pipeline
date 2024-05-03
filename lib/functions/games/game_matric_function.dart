import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/api_urls/category_url.dart';
import 'package:savyminds/models/games/game_type_matrice_model.dart';
import 'package:savyminds/models/http_response_model.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:http/http.dart' as http;

class GameMatricFunction{
  //Get all game matrics
  Future<HttpResponseModel?> getGameMatrics(
      {required BuildContext context, String? nextUrl}) async {
    final String accessToken =
        Provider.of<UserDetailsProvider>(context, listen: false)
            .getAccessToken();
   
    try {
      final response = await http.get(
        Uri.parse(nextUrl ?? CategoryUrl.gameMatrics),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $accessToken"
        },
      );
      // log('categories:${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return HttpResponseModel.fromJson(data);
        
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
  
  //Get a game matric
  Future<GameTypeMatric?> getGameMatric(
      {required BuildContext context, String? nextUrl, required int id }) async {
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