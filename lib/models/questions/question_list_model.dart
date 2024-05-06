import 'package:savyminds/constants.dart';
import 'package:savyminds/models/questions/question_model.dart';

class QuestionListResponseModel {
  List<NewQuestionModel> easyQuestions;
  List<NewQuestionModel> mediumQuestions;
  List<NewQuestionModel> hardQuestions;

  QuestionListResponseModel(
      {required this.easyQuestions,
      required this.hardQuestions,
      required this.mediumQuestions});

  factory QuestionListResponseModel.fromJson(Map<String, dynamic> json) {
    return QuestionListResponseModel(
        easyQuestions: ((json['easy_questions'] ?? []) as List)
            .map((e) => NewQuestionModel.fromJson(e))
            .toList(),
        mediumQuestions: ((json['medium_questions'] ?? []) as List)
            .map((e) => NewQuestionModel.fromJson(e))
            .toList(),
        hardQuestions: ((json['hard_questions'] ?? []) as List)
            .map((e) => NewQuestionModel.fromJson(e))
            .toList());
  }

  checkNextPreviousDataType(dynamic data) {
    if (data.runtimeType == String) {
      return data;
    } else {
      data[0];
    }
  }

  List<NewQuestionModel> toQuestionModel(List data) {
    try {
      List<NewQuestionModel> questions = [];
      for (var d in data) {
        questions.add(NewQuestionModel.fromJson(d));
      }

      return questions;
    } catch (e) {
      lg("Error toQuestionModel: $e");
      return [];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'easy_questions': easyQuestions ,
      'medium_questions': mediumQuestions ,
      'hard_questions': hardQuestions ,
    };
  }
}
