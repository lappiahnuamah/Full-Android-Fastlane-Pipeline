import 'dart:convert';
import 'package:savyminds/models/games/option_model.dart';

const String questionDB = 'question';

class QuestionModel {
  int id;
  String text;
  String image;
  int points;
  bool isGolden;
  List<OptionModel> option;
  int questionTime;

  QuestionModel({
    required this.id,
    required this.text,
    required this.option,
    required this.image,
    required this.points,
    required this.isGolden,
    required this.questionTime,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] ?? 0,
      text: json['text'] ?? "",
      image: json['image'] ?? '',
      points: json['points'] ?? 1,
      isGolden: json['is_golden'] ?? false,
      questionTime: json['question_time'] ?? 10,
      option: ((json['options'] ?? []) as List)
          .map((e) => OptionModel.fromJson(e))
          .toList(),
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
      option: ((jsonDecode(json['options']) ?? []) as List)
          .map((e) => OptionModel.fromJson(e))
          .toList(),
    );
  }
}
