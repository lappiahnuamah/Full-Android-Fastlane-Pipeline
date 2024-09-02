import 'dart:math';

import 'package:flutter/material.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/models/categories/category_level_model.dart';

class CategoryProvider extends ChangeNotifier {
  List<CategoryModel> _categories = [];
  List<CategoryModel> _searchedCategories = [];
  List<CategoryModel> _favoriteCategories = [];

  List<CategoryModel> get categories => _categories;
  List<CategoryModel> get searchedCategories => _searchedCategories;
  List<CategoryModel> get favoriteCategories => _favoriteCategories;

  Map<int, CategoryLevelModel> _categoryLevels = {};

//
  void setCategories(List<CategoryModel> categories) {
    _categories = categories;
    _searchedCategories = categories;
    notifyListeners();
  }

  void searchCategories(String c) {
    if (c.isNotEmpty) {
      String pattern = c.toLowerCase();
      RegExp regExp = RegExp(pattern, caseSensitive: false);
      final l = _categories
          .where((category) => regExp.hasMatch(category.name.toLowerCase()))
          .toList();

      _searchedCategories = l;
    } else {
      _searchedCategories = _categories;
    }

    notifyListeners();
  }

  void setFavoriteCategories(List<CategoryModel> categories) {
    _favoriteCategories = categories;
    notifyListeners();
  }

//
  void addCategories(List<CategoryModel> categories) {
    _categories.addAll(categories);
    _searchedCategories = _categories;
    notifyListeners();
  }

  void addFavoriteCategories(List<CategoryModel> categories) {
    _favoriteCategories.addAll(categories);
    notifyListeners();
  }

//
  void addCategory(CategoryModel category) {
    _categories.add(category);
    notifyListeners();
  }

  void addFavoriteCategory(CategoryModel category) {
    _favoriteCategories.add(category);
    notifyListeners();
  }

//
  void removeCategory(CategoryModel category) {
    _categories.remove(category);
    notifyListeners();
  }

  void removeFavoriteCategory(CategoryModel category) {
    _favoriteCategories.remove(category);
    notifyListeners();
  }

//
  void updateCategory(CategoryModel category) {
    final index =
        _categories.indexWhere((element) => element.id == category.id);
    _categories[index] = category;
    notifyListeners();
  }

  void clearCategories() {
    _categories.clear();
    notifyListeners();
  }

  void clearCategoryById(int id) {
    _categories.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  CategoryModel getCategoryById(int id) {
    return _categories.firstWhere((element) => element.id == id);
  }

  void clearCategory(CategoryModel category) {
    _categories.remove(category);
    notifyListeners();
  }

  //Category Levels
  void setCategoryLevel(int categoryId, CategoryLevelModel level) {
    _categoryLevels[categoryId] = level;
    notifyListeners();
  }

  CategoryLevelModel? getCategoryLevel(int categoryId) {
    // dev.log('id:$categoryId, categoryLevels: ${_categoryLevels[categoryId]}');
    return _categoryLevels[categoryId];
  }

  void clearCategoryLevels() {
    _categoryLevels.clear();
    notifyListeners();
  }

  void clearCategoryLevel(int categoryId) {
    _categoryLevels.remove(categoryId);
    notifyListeners();
  }

//
// /
  CategoryModel getRandomCategory() {
    final int randomIndex = Random().nextInt(_categories.length);
    if (_categories[randomIndex].isLocked) {
      return getRandomCategory();
    } else {
      return _categories[randomIndex];
    }
  }

  List<CategoryModel> getThreeRandomCategories() {
    List<CategoryModel> randomCategories = [];

    while (randomCategories.length < 3) {
      final randomCategory = getRandomCategory();
      if (!(randomCategories.contains(randomCategory))) {
        randomCategories.add(randomCategory);
      }
    }

    return randomCategories;
  }

  List<CategoryModel> getTwoRandomCategories() {
    List<CategoryModel> randomCategories = [];

    while (randomCategories.length < 2) {
      final randomCategory = getRandomCategory();
      if (!(randomCategories.contains(randomCategory))) {
        randomCategories.add(randomCategory);
      }
    }

    return randomCategories;
  }

  /////////// ///// Category Game play /////////
  int totalPoints = 0;

  setTotalPoints(int points) {
    totalPoints = points;
    notifyListeners();
  }
}
