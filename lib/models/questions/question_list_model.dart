import 'package:savyminds/constants.dart';
import 'package:savyminds/models/games/question_model.dart';

class QuestionListResponseModel {
  List? easyQuestions;
  List? mediumQuestions;
  List? hardQuestions;

  QuestionListResponseModel(
      {required this.easyQuestions,
      required this.hardQuestions,
      required this.mediumQuestions});

  QuestionListResponseModel.fromJson(Map<String, dynamic> json) {
    easyQuestions = json['easy_questions'] ?? [];
    mediumQuestions = json['medium_questions'] ?? [];
    hardQuestions = json['hard_questions'] ?? [];
  }

  checkNextPreviousDataType(dynamic data) {
    if (data.runtimeType == String) {
      return data;
    } else {
      data[0];
    }
  }

  List<QuestionModel> toQuestionModel(List data) {
    try {
      List<QuestionModel> questions = [];
      for (var d in data) {
        questions.add(QuestionModel.fromJson(d));
      }

      return questions;
    } catch (e) {
      lg("Error toQuestionModel: $e");
      return [];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'easy_questions': easyQuestions ?? [],
      'medium_questions': mediumQuestions ?? [],
      'hard_questions': hardQuestions ?? [],
    };
  }
}
