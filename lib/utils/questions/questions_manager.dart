import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/database/new_game_db_functions.dart';
import 'package:savyminds/functions/questions_functions.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/models/level_model.dart';
import 'package:savyminds/models/question_param_model.dart';
import 'package:savyminds/models/questions/question_model.dart';

import '../../models/games/game_type_level_matric.dart';
import '../../models/games/game_type_matrice_model.dart';
import '../../providers/game_metric_provider.dart';

class QuestionsManager {
  static Future<QuestionsParamModel> getTrainingModeQuestions({
    required BuildContext context,
    required int questId,
    required LevelName level,
    required CategoryModel? categoryModel,
  }) async {
    final gameMetricsProvider =
        Provider.of<GameMetricsProvider>(context, listen: false);

    GameTypeMatric? trainModeMetric = gameMetricsProvider.allMetric[1];

    // First get metric for the level
    int noOfEasyQuestions = 0;
    int noOfMediumQuestions = 0;
    int noOfHardQuestions = 0;

    ///Beginner
    if (level == LevelName.beginner) {
      if (trainModeMetric != null) {
        final levelMetric = getLevelMetrics(
            levelName: "Beginner", levelMetrics: trainModeMetric.levelMatrix);

        noOfEasyQuestions =
            levelMetric != null ? levelMetric.numberOfEasyQeustions : 7;
        noOfMediumQuestions = levelMetric != null
            ? levelMetric.numberOfMediumQeustions
            : 3; //?TODO: Change
        noOfHardQuestions =
            levelMetric != null ? levelMetric.numberOfHardQeustions : 0;
      } else {
        noOfEasyQuestions = 7;
        noOfMediumQuestions = 3;
        noOfHardQuestions = 0;
      }
    }

    //Intermediate
    else if (level == LevelName.intermediate) {
      if (trainModeMetric != null) {
        final levelMetric = getLevelMetrics(
            levelName: "Intermediate",
            levelMetrics: trainModeMetric.levelMatrix);

        noOfEasyQuestions =
            levelMetric != null ? levelMetric.numberOfEasyQeustions : 5;
        noOfMediumQuestions = levelMetric != null
            ? levelMetric.numberOfMediumQeustions
            : 6; //?TODO: Change
        noOfHardQuestions =
            levelMetric != null ? levelMetric.numberOfHardQeustions : 1;
      } else {
        noOfEasyQuestions = 5;
        noOfMediumQuestions = 6;
        noOfHardQuestions = 1;
      }
    }

    //Advanced
    else if (level == LevelName.advanced) {
      if (trainModeMetric != null) {
        final levelMetric = getLevelMetrics(
            levelName: "Advanced", levelMetrics: trainModeMetric.levelMatrix);

        noOfEasyQuestions =
            levelMetric != null ? levelMetric.numberOfEasyQeustions : 3;
        noOfMediumQuestions = levelMetric != null
            ? levelMetric.numberOfMediumQeustions
            : 6; //?TODO: Change
        noOfHardQuestions =
            levelMetric != null ? levelMetric.numberOfHardQeustions : 3;
      } else {
        noOfEasyQuestions = 3;
        noOfMediumQuestions = 6;
        noOfHardQuestions = 3;
      }
    }

    //Expert
    else if (level == LevelName.expert) {
      if (trainModeMetric != null) {
        final levelMetric = getLevelMetrics(
            levelName: "Expert", levelMetrics: trainModeMetric.levelMatrix);

        noOfEasyQuestions =
            levelMetric != null ? levelMetric.numberOfEasyQeustions : 2;
        noOfMediumQuestions = levelMetric != null
            ? levelMetric.numberOfMediumQeustions
            : 5; //?TODO: Change
        noOfHardQuestions =
            levelMetric != null ? levelMetric.numberOfHardQeustions : 5;
      } else {
        noOfEasyQuestions = 2;
        noOfMediumQuestions = 5;
        noOfHardQuestions = 5;
      }
    }

    //Elite
    else if (level == LevelName.elite) {
      if (trainModeMetric != null) {
        final levelMetric = getLevelMetrics(
            levelName: "Elite", levelMetrics: trainModeMetric.levelMatrix);

        noOfEasyQuestions =
            levelMetric != null ? levelMetric.numberOfEasyQeustions : 1;
        noOfMediumQuestions = levelMetric != null
            ? levelMetric.numberOfMediumQeustions
            : 7; //?TODO: Change
        noOfHardQuestions =
            levelMetric != null ? levelMetric.numberOfHardQeustions : 7;
      } else {
        noOfEasyQuestions = 1;
        noOfMediumQuestions = 7;
        noOfHardQuestions = 7;
      }
    }

    final result = await getQuestionBasedOnFactors(
        context: context,
        questId: questId,
        level: level,
        categoryModel: categoryModel,
        noOfEasyQuestions: noOfEasyQuestions,
        noOfMediumQuestions: noOfMediumQuestions,
        noOfHardQuestions: noOfHardQuestions);

    return result;
  }
}

GameTypeLevelMatric? getLevelMetrics(
    {required String levelName,
    required List<GameTypeLevelMatric> levelMetrics}) {
  try {
    final l =
        levelMetrics.where((element) => element.gameLevelName == levelName);
    if (l.isNotEmpty) {
      return l.first;
    } else {
      return null;
    }
  } catch (e) {
    lg(e);
    return null;
  }
}

Future<QuestionsParamModel> getQuestionBasedOnFactors({
  required BuildContext context,
  required int questId,
  required LevelName level,
  required CategoryModel? categoryModel,
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
        limit: noOfEasyQuestions * 2,
        difficulty: 'Easy',
        categoryName: categoryModel?.name);
  }

  if (noOfMediumQuestions > 0) {
    mediumQuestionsList = await NewGameLocalDatabase.getLevelQuestions(
        limit: noOfMediumQuestions * 2,
        difficulty: 'Medium',
        categoryName: categoryModel?.name);
  }

  if (noOfHardQuestions > 0) {
    hardQuestionsList = await NewGameLocalDatabase.getLevelQuestions(
        limit: noOfHardQuestions * 2,
        difficulty: 'Hard',
        categoryName: categoryModel?.name);
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
        categories: [categoryModel?.id ?? 0],
        gameType: questId);

    if (questionListResponse != null) {
      //IF success fetch from database
      if (noOfEasyQuestions > 0) {
        easyQuestionsList = await NewGameLocalDatabase.getLevelQuestions(
            limit: noOfEasyQuestions * 2,
            difficulty: 'Easy',
            categoryName: categoryModel?.name);
      }

      if (noOfMediumQuestions > 0) {
        mediumQuestionsList = await NewGameLocalDatabase.getLevelQuestions(
            limit: noOfMediumQuestions * 2,
            difficulty: 'Medium',
            categoryName: categoryModel?.name);
      }

      if (noOfHardQuestions > 0) {
        hardQuestionsList = await NewGameLocalDatabase.getLevelQuestions(
            limit: noOfHardQuestions * 2,
            difficulty: 'Hard',
            categoryName: categoryModel?.name);
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
