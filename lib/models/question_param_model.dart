import 'package:savyminds/models/questions/question_model.dart';

class QuestionsParamModel {
  final List<NewQuestionModel> questions;
  final Map<String, List<NewQuestionModel>> swapQuestions;

  QuestionsParamModel({
    required this.questions,
    required this.swapQuestions,
  });
}
