import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/questions/option_model.dart';
import 'package:savyminds/models/questions/short_question_category.dart';

const String questionDB = 'question';

class NewQuestionModel extends Equatable {
  final int id;
  final String text;
  final List<ShortQuestionCategory> categories;
  final int categoryWeight;
  final String difficulty;
  final String level;
  final String image;
  final int difficultyWeight;
  final int questionTime;
  final int complexityWeight;
  final String hint;
  final bool hasHint;
  final bool isGolden;
  final bool hasMysteryBox;
  final bool hasTwoTimes;
  final List<OptionModel> options;
  final String dateCreated;

  const NewQuestionModel({
    required this.id,
    required this.categories,
    required this.text,
    required this.categoryWeight,
    required this.difficulty,
    required this.level,
    required this.image,
    required this.difficultyWeight,
    required this.questionTime,
    required this.complexityWeight,
    required this.hint,
    required this.hasHint,
    required this.isGolden,
    required this.hasMysteryBox,
    required this.hasTwoTimes,
    required this.dateCreated,
    required this.options,
  });

  factory NewQuestionModel.fromJson(Map<String, dynamic> json) {
    return NewQuestionModel(
      id: json['id'] ?? 0,
      text: json['text'] ?? "",
      categoryWeight: json['category_weight'] ?? 0,
      difficultyWeight: json['difficulty_weight'] ?? "",
      difficulty: json['difficulty'] ?? "",
      level: json['level'] ?? "",
      image: json['image'] ?? "",
      questionTime: json['question_time'] ?? 0,
      complexityWeight: json['complexity_weight'] ?? 0,
      hint: json['hint'] ?? "",
      dateCreated: json['date_created'] ?? "",
      hasHint: json['has_hint'] ?? false,
      isGolden: json['is_golden'] ?? false,
      hasMysteryBox: json['has_mystery_box'] ?? false,
      hasTwoTimes: json['has_times_two'] ?? false,
      categories: toCategories(json['categories'] ?? []),
      options: toQuestionOptions(json['options'] ?? []),
    );
  }

  factory NewQuestionModel.fromLocalDBJson(Map<String, dynamic> json) {
    return NewQuestionModel(
      id: json['id'] ?? 0,
      text: json['text'] ?? "",
      categoryWeight: int.parse(json['category_weight']),
      difficultyWeight: int.parse(json['difficulty_weight'] ?? ""),
      difficulty: json['difficulty'] ?? "",
      level: json['level'] ?? "",
      image: json['image'] ?? "",
      questionTime: json['question_time'] ?? 0,
      complexityWeight: int.parse(json['complexity_weight']),
      hint: json['hint'] ?? "",
      dateCreated: json['date_created'] ?? "",
      hasHint: json['has_hint'] == 1,
      isGolden: json['is_golden'] == 1,
      hasMysteryBox: json['has_mystery_box'] == 1,
      hasTwoTimes: json['has_times_two'] == 1,
      categories: toCategories(jsonDecode(json['categories']) ?? []),
      options: toQuestionOptions(jsonDecode(json['options']) ?? []),
    );
  }

  static List<ShortQuestionCategory> toCategories(List data) {
    try {
      List<ShortQuestionCategory> categories = [];

      for (var d in data) {
        categories.add(ShortQuestionCategory.fromJson(d));
      }

      return categories;
    } catch (e) {
      lg("Error  toCategories: $e");
      return [];
    }
  }

  static List<OptionModel> toQuestionOptions(List data) {
    try {
      List<OptionModel> options = [];

      for (var d in data) {
        options.add(OptionModel.fromJson(d));
      }

      return options;
    } catch (e) {
      lg("Error  toQuestionOptions: $e");
      return [];
    }
  }

  List<Map<String, dynamic>> toQuestionOptionsMap(List<OptionModel> data) {
    try {
      List<Map<String, dynamic>> options = [];

      for (var d in data) {
        options.add(d.toJson());
      }

      return options;
    } catch (e) {
      lg("Error  toQuestionOptionsMap: $e");
      return [];
    }
  }

  List<Map<String, dynamic>> toCategoriesMap(List<ShortQuestionCategory> data) {
    try {
      List<Map<String, dynamic>> options = [];

      for (var d in data) {
        options.add(d.toMap());
      }

      return options;
    } catch (e) {
      lg("Error  toCategoriesMap: $e");
      return [];
    }
  }

  toMap() {
    return {
      'id': id,
      'text': text,
      'category_weight': categoryWeight,
      'difficulty_weight': difficultyWeight,
      'difficulty': difficulty,
      'level': level,
      'image': image,
      'question_time': questionTime,
      'complexity_weight': complexityWeight,
      'hint': hint,
      'date_created': dateCreated,
      'has_hint': hasHint,
      'is_golden': isGolden,
      'has_mystery_box': hasMysteryBox,
      'has_two_times': hasTwoTimes,
      'categories': toCategoriesMap(categories),
      'options': toQuestionOptionsMap(options)
    };
  }

  toLocalDBMap() {
    return {
      'id': id,
      'text': text,
      'category_weight': categoryWeight.toString(),
      'difficulty_weight': difficultyWeight.toString(),
      'difficulty': difficulty,
      'level': level,
      'image': image,
      'question_time': questionTime,
      'complexity_weight': complexityWeight.toString(),
      'hint': hint,
      'date_created': dateCreated,
      'has_hint': hasHint ? 1 : 0,
      'is_golden': isGolden ? 1 : 0,
      'has_mystery_box': hasMysteryBox ? 1 : 0,
      'has_times_two': hasTwoTimes ? 1 : 0,
      'categories': jsonEncode(toCategoriesMap(categories)),
      'options': jsonEncode(toQuestionOptionsMap(options))
    };
  }

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify =>
      true; // Enable toString() method for better debugging  "🇬🇭 +233(0) "
}
