import 'package:flutter/material.dart';
import 'package:savyminds/database/new_game_db_functions.dart';
import 'package:savyminds/functions/questions_functions.dart';
import 'package:savyminds/models/level_model.dart';
import 'package:savyminds/models/question_param_model.dart';
import 'package:savyminds/models/questions/question_model.dart';

class QuestionsManager {
  static Future<QuestionsParamModel> getTrainingModeQuestions({
    required BuildContext context,
    required int questId,
    required LevelName level,
    required int categoryId,
  }) async {
    // First get metric for the level
    int noOfEasyQuestions = 0;
    int noOfMediumQuestions = 0;
    int noOfHardQuestions = 0;

    ///Beginner
    if (level == LevelName.beginner) {
      noOfEasyQuestions = 7;
      noOfMediumQuestions = 3; //?TODO: Change
      noOfHardQuestions = 0;
    }

    //Intermediate
    else if (level == LevelName.intermediate) {
      noOfEasyQuestions = 5;
      noOfMediumQuestions = 6;
      noOfHardQuestions = 1;
    }

    //Advanced
    else if (level == LevelName.advanced) {
      noOfEasyQuestions = 3;
      noOfMediumQuestions = 6;
      noOfHardQuestions = 3;
    }

    //Expert
    else if (level == LevelName.expert) {
      noOfEasyQuestions = 2;
      noOfMediumQuestions = 5;
      noOfHardQuestions = 5;
    }

    //Elite
    else if (level == LevelName.elite) {
      noOfEasyQuestions = 1;
      noOfMediumQuestions = 7;
      noOfHardQuestions = 7;
    }

    final result = await getQuestionBasedOnFactors(
        context: context,
        questId: questId,
        level: level,
        categoryId: categoryId,
        noOfEasyQuestions: noOfEasyQuestions,
        noOfMediumQuestions: noOfMediumQuestions,
        noOfHardQuestions: noOfHardQuestions);

    return result;
  }
}

Future<QuestionsParamModel> getQuestionBasedOnFactors({
  required BuildContext context,
  required int questId,
  required LevelName level,
  required int categoryId,
  required int noOfEasyQuestions,
  required int noOfMediumQuestions,
  required int noOfHardQuestions,
}) async {
  List<NewQuestionModel> easyQuestionsList = [];
  List<NewQuestionModel> mediumQuestionsList = [];
  List<NewQuestionModel> hardQuestionsList = [];

//////////////////////////////////////////////////
/////   First fetch from the local database   ////
  if (noOfEasyQuestions > 0) {
    easyQuestionsList = await NewGameLocalDatabase.getLevelQuestions(
        limit: noOfEasyQuestions * 2, difficulty: 'Easy', categoryId: 1);
  }

  if (noOfMediumQuestions > 0) {
    mediumQuestionsList = await NewGameLocalDatabase.getLevelQuestions(
        limit: noOfMediumQuestions * 2, difficulty: 'Medium', categoryId: 1);
  }

  if (noOfHardQuestions > 0) {
    hardQuestionsList = await NewGameLocalDatabase.getLevelQuestions(
        limit: noOfHardQuestions * 2, difficulty: 'Hard', categoryId: 1);
  }

  if (easyQuestionsList.length >= noOfEasyQuestions * 2 &&
      mediumQuestionsList.length >= noOfMediumQuestions * 2 &&
      hardQuestionsList.length >= noOfHardQuestions * 2) {
    final questions = easyQuestionsList.sublist(0, noOfEasyQuestions) +
        mediumQuestionsList.sublist(0, noOfMediumQuestions) +
        hardQuestionsList.sublist(0, noOfHardQuestions);
    questions.shuffle();

    final swapQuestions = {
      if (noOfEasyQuestions > 0)
        "Easy": easyQuestionsList.sublist(
            noOfEasyQuestions, easyQuestionsList.length),
      if (noOfMediumQuestions > 0)
        "Medium": mediumQuestionsList.sublist(
            noOfMediumQuestions, mediumQuestionsList.length),
      if (noOfHardQuestions > 0)
        "Hard": hardQuestionsList.sublist(
            noOfHardQuestions, hardQuestionsList.length),
    };
    return QuestionsParamModel(
        questions: questions, swapQuestions: swapQuestions);
  } else {
    //TRY FETCHING FROM SERVER
    if (!context.mounted) {
      return QuestionsParamModel(questions: [], swapQuestions: {});
    }

    final questionListResponse = await QuestionFunction().getQuestions(
        context: context,
        nextUrl: null,
        gameLevel: level.name,
        categories: [categoryId],
        gameType: questId);

    if (questionListResponse != null) {
      //IF success fetch from database
      if (noOfEasyQuestions > 0) {
        easyQuestionsList = await NewGameLocalDatabase.getLevelQuestions(
            limit: noOfEasyQuestions * 2, difficulty: 'Easy', categoryId: 1);
      }

      if (noOfMediumQuestions > 0) {
        mediumQuestionsList = await NewGameLocalDatabase.getLevelQuestions(
            limit: noOfMediumQuestions * 2,
            difficulty: 'Medium',
            categoryId: 1);
      }

      if (noOfHardQuestions > 0) {
        hardQuestionsList = await NewGameLocalDatabase.getLevelQuestions(
            limit: noOfHardQuestions * 2, difficulty: 'Hard', categoryId: 1);
      }

      if (easyQuestionsList.length >= noOfEasyQuestions * 2 &&
          mediumQuestionsList.length >= noOfMediumQuestions * 2 &&
          hardQuestionsList.length >= noOfHardQuestions * 2) {
        final questions = easyQuestionsList.sublist(0, noOfEasyQuestions) +
            mediumQuestionsList.sublist(0, noOfMediumQuestions) +
            hardQuestionsList.sublist(0, noOfHardQuestions);
        questions.shuffle();

        final swapQuestions = {
          if (noOfEasyQuestions > 0)
            "Easy": easyQuestionsList.sublist(
                noOfEasyQuestions, easyQuestionsList.length),
          if (noOfMediumQuestions > 0)
            "Medium": mediumQuestionsList.sublist(
                noOfMediumQuestions, mediumQuestionsList.length),
          if (noOfHardQuestions > 0)
            "Hard": hardQuestionsList.sublist(
                noOfHardQuestions, hardQuestionsList.length),
        };
        return QuestionsParamModel(
            questions: questions, swapQuestions: swapQuestions);
      } else {
        return QuestionsParamModel(questions: [], swapQuestions: {});
      }
    }
    return QuestionsParamModel(questions: [], swapQuestions: {});
  }
}
