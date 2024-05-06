import 'package:flutter/material.dart';
import 'package:savyminds/database/new_game_db_functions.dart';
import 'package:savyminds/functions/questions_functions.dart';
import 'package:savyminds/models/questions/question_model.dart';

class QuestionsManager {
  static Future<List<NewQuestionModel>> getTrainingModeQuestions(
      {required BuildContext context,
      required int questId,
      required String level}) async {
    // First get metric for the level
    int noOfEasyQuestions = 0;
    int noOfHardQuestions = 0;
    int noOfMediumQuestions = 0;

    ///Level
    if (level == 'easy') {
      noOfEasyQuestions = 10;
      noOfMediumQuestions = 5;
      noOfHardQuestions = 5;

      final easyQuestionsList = await NewGameLocalDatabase.getLevelQuestions(
          limit: noOfEasyQuestions, difficulty: level);

      final mediumQuestionsList = await NewGameLocalDatabase.getLevelQuestions(
          limit: noOfMediumQuestions, difficulty: level);

      final hardQuestionsList = await NewGameLocalDatabase.getLevelQuestions(
          limit: noOfHardQuestions, difficulty: level);

      if (easyQuestionsList.length >= noOfEasyQuestions &&
          mediumQuestionsList.length >= noOfMediumQuestions &&
          hardQuestionsList.length >= noOfHardQuestions) {
        final questions = easyQuestionsList.sublist(0, noOfEasyQuestions) +
            mediumQuestionsList.sublist(0, noOfMediumQuestions) +
            hardQuestionsList.sublist(0, noOfHardQuestions);
        return questions;
      } else {
        /// fectch from server
        if (context.mounted) {
          final questionListResponse = await QuestionFunction().getQuestions(
              context: context,
              nextUrl: null,
              gameLevel: level,
              gameType: questId);

          if (questionListResponse != null) {
            if (context.mounted) {
              final questions = questionListResponse.easyQuestions
                      .sublist(0, noOfEasyQuestions) +
                  questionListResponse.mediumQuestions
                      .sublist(0, noOfMediumQuestions) +
                  questionListResponse.hardQuestions
                      .sublist(0, noOfHardQuestions);
              return questions;
            }
            return [];
          }
          return [];
        }
        return [];
      }
    }
    return [];
  }
}
