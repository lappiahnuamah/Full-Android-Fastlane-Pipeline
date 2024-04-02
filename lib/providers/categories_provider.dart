import 'dart:math';

import 'package:flutter/material.dart';
import 'package:savyminds/models/categories/categories_model.dart';

class CategoryProvider extends ChangeNotifier {
  List<CategoryModel> _categories = [];
  List<CategoryModel> _favoriteCategories = [];

  List<CategoryModel> get categories => _categories;
  List<CategoryModel> get favoriteCategories => _favoriteCategories;

//
  void setCategories(List<CategoryModel> categories) {
    _categories = categories;
    notifyListeners();
  }

  void setFavoriteCategories(List<CategoryModel> categories) {
    _favoriteCategories = categories;
    notifyListeners();
  }

//
  void addCategories(List<CategoryModel> categories) {
    _categories.addAll(categories);
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

  CategoryModel getRandomCategory() {
    final int randomIndex = Random().nextInt(_categories.length);
    if (_categories[randomIndex].isLocked) {
      return getRandomCategory();
    } else {
      return _categories[randomIndex];
    }
  }
}
