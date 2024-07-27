import 'dart:convert';
import 'package:savyminds/models/questions/option_model.dart';

const String questionDB = 'question';

class QuestionModel {
  int id;
  String text;
  String image;
  int points;
  bool isGolden;
  List<OptionModel> option;
  int questionTime;
  String hint;
  bool hasMysteryBox;
  bool hasTimesTwoPoints;
  bool hasHint;

  QuestionModel(
      {required this.id,
      required this.text,
      required this.option,
      required this.image,
      required this.points,
      required this.isGolden,
      required this.questionTime,
      required this.hasMysteryBox,
      required this.hasTimesTwoPoints,
      required this.hint,
      required this.hasHint});

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] ?? 0,
      text: json['text'] ?? "",
      image: json['image'] ?? '',
      points: json['points'] ?? 1,
      isGolden: json['is_golden'] ?? false,
      questionTime: json['question_time'] ?? 10,
      hasHint: json['has_hint'] ?? false,
      hasMysteryBox: json['has_mystery_box'] ?? false,
      hasTimesTwoPoints: json['has_times_two'] ?? false,
      option: ((json['options'] ?? []) as List)
          .map((e) => OptionModel.fromJson(e))
          .toList(),
      hint: json['hint'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['text'] = text;
    data['options'] = option;
    data['points'] = points;
    data['image'] = image;
    return data;
  }

  Map<String, dynamic> toLocalDBJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['text'] = text;
    data['options'] = jsonEncode(option);
    data['points'] = points;
    data['isGolden'] = isGolden ? 1 : 0;
    data['questionTime'] = questionTime;
    data['image'] = image;
    return data;
  }

  factory QuestionModel.fromLocalDBJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] ?? 0,
      text: json['text'] ?? "",
      image: json['image'] ?? '',
      points: json['points'] ?? 1,
      isGolden: json['isGolden'] == 1,
      questionTime: json['questionTime'] ?? 10,
      hasMysteryBox: json['has_mystery_box'] == 1,
      hasTimesTwoPoints: json['has_times_two'] == 1,
      hasHint: json['has_hint'] == 1,
      hint: json['hint'] ?? '',
      option: ((jsonDecode(json['options']) ?? []) as List)
          .map((e) => OptionModel.fromJson(e))
          .toList(),
    );
  }
}
