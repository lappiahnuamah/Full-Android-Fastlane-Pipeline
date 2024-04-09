import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/api_urls/category_url.dart';
import 'package:savyminds/data/shared_preference_values.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:http/http.dart' as http;
import 'package:savyminds/models/http_response_model.dart';
import 'package:savyminds/models/level_model.dart';
import 'package:savyminds/providers/categories_provider.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:savyminds/utils/cache/shared_preferences_helper.dart';

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
      log('categories:${response.body}');
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
      log('fav categories:${response.body}');
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
        final level = LevelModel.fromJson(jsonDecode(response.body));
        categoryProvider.setCategoryLevel(id, level);
        return level;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
