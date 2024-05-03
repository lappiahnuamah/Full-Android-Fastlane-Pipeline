import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/api_urls/category_url.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/questions/question_list_model.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:http/http.dart' as http;

class QuestionFunction {
  //Get all questions
  Future<QuestionListResponseModel?> getQuestions(
      {required BuildContext context,
      String? nextUrl,
      required int gameType,
      required String gameLevel}) async {
    final String accessToken =
        Provider.of<UserDetailsProvider>(context, listen: false)
            .getAccessToken();

    try {
      final response = await http.get(
        Uri.parse(nextUrl ??
            "${CategoryUrl.listQuestions}?game_type=$gameType&game_level=$gameLevel"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $accessToken"
        },
      );
      lg('questions:${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return QuestionListResponseModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //Get specific questions
  Future<QuestionListResponseModel?> getSpecificQuestions(
      {required BuildContext context,
      String? nextUrl,
      required int gameType,
      required String gameLevel,
      required String search}) async {
    final String accessToken =
        Provider.of<UserDetailsProvider>(context, listen: false)
            .getAccessToken();

    try {
      final response = await http.get(
        Uri.parse(nextUrl ??
            "${CategoryUrl.listQuestions}?game_type=$gameType&game_level=$gameLevel&search=$search"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $accessToken"
        },
      );
      lg('specific questions:${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return QuestionListResponseModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
