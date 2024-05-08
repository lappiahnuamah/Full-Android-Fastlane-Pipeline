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

  static int getQuestionsTime(
      {required double complexityWeight,
      required double difficultyWeight,
      required double levelWeight,
      required int questionTime}) {
// [x * d * (1/l) * 10sec]
// x= complexity weight
// d= difficulty weight
// l =level weight

    return (complexityWeight *
            difficultyWeight *
            (1 / levelWeight) *
            questionTime)
        .round();
  }

  static int getQuestionPoint(
      {required double remainingTime,
      required double questionTime,
      required double categoryWeight,
      required double difficultWeight,
      required double levelWeight,
      double min = 10,
      double max = 60}) {
    // round(⌈r/t×g ×d ×l ×10⌉,min⁡=10, max=⁡60 )

    return ((remainingTime / questionTime) *
            categoryWeight *
            difficultWeight *
            levelWeight *
            10)
        .round();
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
