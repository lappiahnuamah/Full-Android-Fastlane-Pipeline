// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

class OptionModel {
  int id;
  String text;
  String image;
  int question;
  bool isCorrect;

  OptionModel({
    required this.id,
    required this.text,
    required this.image,
    required this.question,
    required this.isCorrect,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id : json['id'] ?? 0,
      text : json['text'] ?? "",
      image : json['image'] ?? "",
      question : json['question'] ?? 0,
      isCorrect : json['is_correct'] ?? false,
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['text'] = text;
    data['image'] = image;
    data['question'] = question;
    data['is_correct'] = isCorrect;

    return data;
  }
}
