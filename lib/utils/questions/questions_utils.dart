import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/providers/game_metric_provider.dart';

class QuestionsUtils {
  static const double categoryWeightDefault = 1.0;
  static const double categoryWeightLanguages = 1.0;
  static const double categoryWeightScienceFiction = 1.0;
  static const double categoryWeightEntertainment = 1.0;
  static const double categoryWeightSports = 1.0;
  static const double categoryWeightMusic = 1.0;
  static const double categoryWeightTechnology = 1.0;
  static const double categoryWeightEducation = 1.0;
  static const double categoryWeightMathematics = 1.0;

  static const double difficultyWeightDefault = 1.0;
  static const double difficultyWeightEasy = 0.8;
  static const double difficultyWeightMedium = 1.0;
  static const double difficultyWeightHard = 1.2;

  static const double complexityWeightDefault = 1.0;
  static const double complexityWeightShortText = 1.0;
  static const double complexityWeightLongText = 1.2;
  static const double complexityWeightShortTextImage = 1.2;
  static const double complexityWeightLongTextImage = 1.5;
  static const double complexityWeightShortTextCalculations = 1.5;
  static const double complexityWeightLongTextCalculations = 1.8;

  static const double levelWeightBeginner = 1.0;
  static const double levelWeightIntermediate = 1.2;
  static const double levelWeightAdvance = 1.4;
  static const double levelWeightExpert = 1.5;
  static const double levelWeightElite = 1.6;

  static int getQuestionsTime({
    required double complexityWeight,
    required double difficultyWeight,
    required String level,
    required int gameType,
    required BuildContext context,
  }) {
    try {
      // [x * d * (1/l) * 10sec]
// x= complexity weight
// d= difficulty weight
// l =level weight

      final gameMetricsProvider =
          Provider.of<GameMetricsProvider>(context, listen: false);
      final levelMatrices =
          gameMetricsProvider.allMetric[gameType]!.levelMatrix;

      final levelMatrix = levelMatrices
          .where((element) => element.gameLevelName == level)
          .first;

      final levelWeight = double.parse(levelMatrix.levelWeight);

      lg("Level Weight: $levelWeight");
      lg("Complexity Weight: $complexityWeight");
      lg("Difficulty Weight: $difficultyWeight");

      lg("Question Time: ${(complexityWeight * difficultyWeight * (1 / levelWeight) * 10).round()}");
      return (complexityWeight * difficultyWeight * (1 / levelWeight) * 10)
          .round();
    } catch (e) {
      lg("getQuestionsTime Error: $e");
      return 0;
    }
  }

  static int getQuestionPoint(
      {required double remainingTime,
      required double questionTime,
      required String level,
      required int gameType,
      required double difficultWeight,
      required num categoryWeight,
      required BuildContext context,
      int min = 10,
      int max = 60}) {
        
    // round(⌈r/t×g ×d ×l ×10⌉,min⁡=10, max=⁡60 )

    final gameMetricsProvider =
        Provider.of<GameMetricsProvider>(context, listen: false);
    final levelMatrices = gameMetricsProvider.allMetric[gameType]!.levelMatrix;

    final levelMatrix =
        levelMatrices.where((element) => element.gameLevelName == level).first;

    final levelWeight = double.parse(levelMatrix.levelWeight);

    lg("Level Weight: $levelWeight");
    lg("Question Time: $questionTime");
    lg("Remaining Time: $remainingTime");
    lg("Complexity Weight: $categoryWeight");
    lg("Difficulty Weight: $difficultWeight");

    // Round the calculated value using ceiling function
    int roundedValue = ((remainingTime / questionTime) *
            categoryWeight *
            difficultWeight *
            levelWeight *
            10)
        .ceil();

    // Ensure the rounded value falls within the specified range
    if (roundedValue < min) {
      return min;
    } else if (roundedValue > max) {
      return max;
    } else {
      return roundedValue;
    }

  
  }

  static double getLevelWeight({required String level}) {
    switch (level) {
      case "Beginner":
        return levelWeightBeginner;
      case "Intermediate":
        return levelWeightIntermediate;
      case "Adavnce":
        return levelWeightAdvance;
      case "Expert":
        return levelWeightExpert;
      case "Elite":
        return levelWeightElite;

      default:
        return levelWeightBeginner;
    }
  }
}
