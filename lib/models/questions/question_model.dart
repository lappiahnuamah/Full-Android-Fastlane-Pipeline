import 'package:equatable/equatable.dart';
import 'package:savyminds/constants.dart';

class QuestionModel extends Equatable {
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
  final List<QuestionOption> options;
  final String dateCreated;

  const QuestionModel({
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

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
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

  static List<QuestionOption> toQuestionOptions(List data) {
    try {
      List<QuestionOption> options = [];

      for (var d in data) {
        options.add(QuestionOption.fromJson(d));
      }

      return options;
    } catch (e) {
      lg("Error  toQuestionOptions: $e");
      return [];
    }
  }

   List<Map<String,dynamic>> toQuestionOptionsMap(List<QuestionOption> data ) {
    try {
      List <Map<String,dynamic>> options = [];

      for (var d in data) {
        options.add(d.toMap());
      }

      return options;
    } catch (e) {
      lg("Error  toQuestionOptionsMap: $e");
      return [];
    }
  }
  
   List<Map<String,dynamic>> toCategoriesMap(List<ShortQuestionCategory> data ) {
    try {
      List <Map<String,dynamic>> options = [];

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
  

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify =>
      true; // Enable toString() method for better debugging  "🇬🇭 +233(0) "
}

class ShortQuestionCategory extends Equatable {
  final int id;
  final String name;

  const ShortQuestionCategory({required this.id, required this.name});

  factory ShortQuestionCategory.fromJson(Map<String, dynamic> json) {
    return ShortQuestionCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
    );
  }

  toMap() {
    return {'id': id, 'name': name};
  }

  @override
  List<Object?> get props => [id, name];

  @override
  bool get stringify => true;
}

class QuestionOption extends Equatable {
  final int id;
  final String image;
  final String text;
  final int question;
  final bool isCorrect;

  const QuestionOption(
      {required this.id,
      required this.image,
      required this.isCorrect,
      required this.question,
      required this.text});

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      id: json['id'] ?? 0,
      question: json['question'] ?? 0,
      image: json['image'] ?? "",
      text: json['text'] ?? "",
      isCorrect: json['is_correct'] ?? false,
    );
  }

  toMap() {
    return {
      'id': id,
      'text': text,
      'image': image,
      'is_correct': isCorrect,
      'question': question
    };
  }

  @override
  List<Object?> get props => [id, text, image, question, isCorrect];

  @override
  bool get stringify => true;
}
