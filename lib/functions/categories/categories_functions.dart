import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/api_urls/category_url.dart';
import 'package:savyminds/api_urls/game_url.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/data/shared_preference_values.dart';
import 'package:savyminds/functions/contests/contests_functions.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:http/http.dart' as http;
import 'package:savyminds/models/categories/category_level_model.dart';
import 'package:savyminds/models/categories/category_rank_model.dart';
import 'package:savyminds/models/categories/user_category_points.dart';
import 'package:savyminds/models/games/question_model.dart';
import 'package:savyminds/models/http_response_model.dart';
import 'package:savyminds/providers/categories_provider.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:savyminds/utils/cache/shared_preferences_helper.dart';
import 'package:savyminds/utils/connection_check.dart';

class CategoryFunctions {
  //Get all categories
  Future<HttpResponseModel?> getCategories(
      {required BuildContext context, String? nextUrl}) async {
    final String accessToken =
        Provider.of<UserDetailsProvider>(context, listen: false)
            .getAccessToken();
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    List<CategoryModel> categories = [];
    try {
      final response = await http.get(
        Uri.parse(nextUrl ?? CategoryUrl.categories),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $accessToken"
        },
      );
      // log('categories:${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final responseModel = HttpResponseModel.fromJson(data);
        for (var item in responseModel.results ?? []) {
          categories.add(CategoryModel.fromJson(item));
        }
        categoryProvider.setCategories(categories);
        if (nextUrl == null) {
          //Save to shared preference
          SharedPreferencesHelper.setObjectList(
              SharedPreferenceValues.allCategories,
              responseModel.results ?? []);
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<UserCategoryPoint?> submitCategoryPoints(
      {required BuildContext context,
      required int category,
      required int gameTypeId,
      required int totalPoints}) async {
    final String accessToken =
        Provider.of<UserDetailsProvider>(context, listen: false)
            .getAccessToken();

    try {
      final response = await http.post(Uri.parse(CategoryUrl.categoryPoints),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            "Authorization": "Bearer $accessToken"
          },
          body:
              jsonEncode({'category': category, 'total_points': totalPoints}));
      lg('point submit: ${response.body} : points: $totalPoints');

      // Add type points
      await ContestFunctions().submitGameTypePoints(
          context: context, gameType: gameTypeId, totalPoints: totalPoints);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return UserCategoryPoint.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      lg(e);
      return null;
    }
  }

//Favorite Categories
  Future<List<CategoryModel>?> getFavoriteCategories(
      {required BuildContext context, String? nextUrl}) async {
    final String accessToken =
        Provider.of<UserDetailsProvider>(context, listen: false)
            .getAccessToken();
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    List<CategoryModel> categories = [];
    try {
      final response = await http.get(
        Uri.parse(nextUrl ?? CategoryUrl.favoriteCategories),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $accessToken"
        },
      );
      // log('fav categories:${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        for (var item in data) {
          categories.add(CategoryModel.fromJson(item));
        }
        categoryProvider.setFavoriteCategories(categories);
        if (nextUrl == null) {
          //Save to shared preference
          SharedPreferencesHelper.setObjectList(
              SharedPreferenceValues.favoriteCategories, data);
        }
        return categories;
      } else {
        return null;
      }
    } catch (e) {
      log('favorite error:$e');
      return null;
    }
  }

  Future<bool> favoriteCategories(context, List<int> ids) async {
    final String accessToken =
        Provider.of<UserDetailsProvider>(context, listen: false)
            .getAccessToken();
    try {
      final response =
          await http.post(Uri.parse('${CategoryUrl.categories}favorite/'),
              headers: {
                "content-type": "application/json",
                "accept": "application/json",
                "Authorization": " Bearer $accessToken"
              },
              body: jsonEncode({'ids': ids}));
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future unFavoriteCategory(context, int id) async {
    final String accessToken =
        Provider.of<UserDetailsProvider>(context, listen: false)
            .getAccessToken();
    try {
      final response = await http.get(
        Uri.parse('${CategoryUrl.categories}$id/unfavorite/'),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": " Bearer $accessToken"
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future getCategoryLevel(context, int id) async {
    final String accessToken =
        Provider.of<UserDetailsProvider>(context, listen: false)
            .getAccessToken();

    CategoryProvider categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    try {
      final response = await http.get(
        Uri.parse('${CategoryUrl.getMyLevel(id)}'),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": " Bearer $accessToken"
        },
      );
      log('level:${response.body}');
      if (response.statusCode == 200) {
        final level = CategoryLevelModel.fromJson(jsonDecode(response.body));
        categoryProvider.setCategoryLevel(id, level);
        return level;
      } else {
        return null;
      }
    } catch (e) {
      log('$e');
      return null;
    }
  }

  Future<List<QuestionModel>> fetchCategoryQuestions(
      {required BuildContext context,
      required String nextUrl,
      required List<int> categories,
      required String level}) async {
    final hasConnection = await ConnectionCheck().hasConnection();
    try {
      if (hasConnection) {
        if (context.mounted) {
          final String accessToken =
              Provider.of<UserDetailsProvider>(context, listen: false)
                  .getAccessToken();
          log('cat: ${categories.toString()}');
          final response = await http.get(
            Uri.parse(nextUrl.isNotEmpty
                ? nextUrl
                : '${GameUrl.questions}?categories=${listToString(categories)}&level=$level'),
            headers: {
              "content-type": "application/json",
              "accept": "application/json",
              "Authorization": "Bearer $accessToken"
            },
          );
          if (response.statusCode == 200) {
            final result =
                HttpResponseModel.fromJson(jsonDecode(response.body));
            return (result.results ?? [])
                .map((e) => QuestionModel.fromJson(e))
                .toList();
          } else {
            //print("Error ${response.body}");

            return [];
          }
        }
        return [];
      } else {
        //print('error');
        if (context.mounted) {
          Fluttertoast.showToast(msg: 'No internet connection');
        }
        return [];
      }
    } catch (e) {
      log('e: $e');
      return [];
    }
  }

  Future<List<CategoryRankModel>> getCategoryRanks(
      {required BuildContext context}) async {
    final hasConnection = await ConnectionCheck().hasConnection();
    try {
      if (hasConnection) {
        if (context.mounted) {
          String accessToken =
              Provider.of<UserDetailsProvider>(context, listen: false)
                  .getAccessToken();

          final response = await http.get(
            Uri.parse(CategoryUrl.categoryPointsRank),
            headers: {
              "content-type": "application/json",
              "accept": "application/json",
              "Authorization": "Bearer $accessToken"
            },
          );
          if (response.statusCode == 200) {
            return ((jsonDecode(response.body) ?? []) as List)
                .map((e) => CategoryRankModel.fromJson(e))
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

  Future<CategoryRankModel?> getRankForACategory(
      {required BuildContext context, required int categoryId}) async {
    final hasConnection = await ConnectionCheck().hasConnection();
    try {
      if (hasConnection) {
        if (context.mounted) {
          String accessToken =
              Provider.of<UserDetailsProvider>(context, listen: false)
                  .getAccessToken();

          final response = await http.post(
            Uri.parse(CategoryUrl.getCategoryRank),
            headers: {
              "content-type": "application/json",
              "accept": "application/json",
              "Authorization": "Bearer $accessToken"
            },
            body: jsonEncode({'category_id': categoryId}),
          );

          if (response.statusCode == 200) {
            return CategoryRankModel.fromJson(jsonDecode(response.body));
          } else {
            return null;
          }
        }
      } else {
        return null;
      }
      return null;
    } catch (e) {
      log("message: $e");
      return null;
    }
  }

  static String listToString(List<int> list) {
    String str = '';
    for (int i = 0; i < list.length; i++) {
      str += list[i].toString();
      if (i != list.length - 1) {
        str += ',';
      }
    }
    return str;
  }
}
