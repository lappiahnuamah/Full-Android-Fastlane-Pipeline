import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/database/game_db_function.dart';
import 'package:savyminds/functions/games/game_function.dart';
import 'package:savyminds/models/auth/app_user.dart';
import 'package:savyminds/models/games/game_rank_model.dart';
import 'package:savyminds/models/questions/option_model.dart';
import 'package:savyminds/models/games/overlay_model.dart';
import 'package:savyminds/models/games/question_model.dart';
import 'package:savyminds/models/games/start_game.dart';
import 'package:savyminds/models/questions/question_model.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/game/game/multi_game.dart/multi_question_page.dart';
import 'package:savyminds/utils/cache/shared_preferences_helper.dart';
import 'package:savyminds/utils/enums/game_enums.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/default_snackbar.dart';
import 'package:savyminds/widgets/two_images.dart';
import '../models/games/game_session.dart';
import '../models/http_response_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameProvider extends ChangeNotifier {
  List<QuestionModel> badgequestionsList = [];
  List<NewQuestionModel> badgequestionsListNew = [];

  ///Gamerecords
  int currentGamePoints = 0;

  int goldenChances = 0;
  int fiftyFifty = 0;

  int answerStreaks = 0;
  int longestStreaks = 0;

  int rank = 0;

  ///show loading
  bool fectchGames = false;
  int score = 0;
  Map<int, dynamic> resultList = {};
  String nextUrl = '';

  /// game ranks
  List<GameRankModel> gameRankings = [];
  GameRankModel? myRank;

  bool loadingRanks = false;

  bool isAdmin = false;

  //// Game Stuffs ///
  //fifty
  addFiftyfifty() {
    fiftyFifty++;
    notifyListeners();
    cacheFiftyfifty();
  }

  reduceFiftyfifty() {
    fiftyFifty--;
    notifyListeners();
    cacheFiftyfifty();
  }

  setFiftyfifty(int number) {
    fiftyFifty = number;
    notifyListeners();
    cacheFiftyfifty();
  }

//golden chance
  addGoldenChances(BuildContext context) {
    goldenChances++;
    showGameNotification(
        context,
        OverlayModel(
            title: 'Congratulations',
            subtitle: 'You have earned 1 golden badge ',
            trailing: SvgPicture.asset(
              'assets/images/gold_badge.svg',
              width: 32,
              height: 32,
            )));
    notifyListeners();
    cacheGoldenBadges();
  }

  reduceGoldenChances() {
    goldenChances--;
    notifyListeners();
    cacheGoldenBadges();
  }

  setGoldenChances(int number) {
    goldenChances = number;
    notifyListeners();
    cacheGoldenBadges();
  }

  setRank(int number) {
    rank = number;
    notifyListeners();
  }

//
  resetAnswerStreak() {
    answerStreaks = 0;
    longestStreaks = 0;
    notifyListeners();
  }

  increaseAnswerStreak(
      {required BuildContext context, required bool hasGolden}) {
    answerStreaks++;
    longestStreaks++;
    if (answerStreaks > 1 && answerStreaks % 5 != 0 && !hasGolden) {
      showGameNotification(
          context,
          OverlayModel(
              title: 'Answer Streak',
              subtitle: '${5 - (answerStreaks % 5)} more to earn a 50/50 bonus',
              leadingImage: 'assets/images/game_logo 1.svg',
              trailing: Text(
                '${longestStreaks}X',
                style: TextStyle(
                    fontSize: d.pSH(35),
                    fontFamily: 'Architects_Daughter',
                    color: AppColors.kGameRed, //const Color(0xFFFFD700),
                    fontWeight: FontWeight.bold),
              )));
    }
    if (answerStreaks % 5 == 0) {
      fiftyFifty++;
      answerStreaks = 0;
      showGameNotification(
          context,
          OverlayModel(
              title: 'Congratulations',
              subtitle: 'You have earned 1 golden & 50/50 bonus',
              trailing: hasGolden
                  ? const TwoImages(
                      front: 'assets/images/gold_badge.svg',
                      back: 'assets/images/5050.svg')
                  : SvgPicture.asset(
                      'assets/images/5050.svg',
                      width: 32,
                      height: 32,
                    )));
    }
    notifyListeners();
    cacheFiftyfifty();
    cacheLongestAnswerStreaks();
  }

  //gamePoints
  addGamePoints(int points) {
    currentGamePoints += points;
    notifyListeners();
  }

  ///reset
  resetGames() {
    currentGamePoints = 0;
    fiftyFifty = 5;
    resultList = {};
    answerStreaks = 0;
    badgequestionsList = [];
  }

  clearPreviousList() {
    for (var element in badgequestionsList) {
      GameLocalDatabase.deleteQuestion(element.id);
    }
  }

  //
  void fetchQuestions(BuildContext context) async {
    fectchGames = true;
    notifyListeners();

    /// Fiirst check local database
    final localResult = await GameLocalDatabase.getBatchQuestion();
    if (localResult.isNotEmpty && localResult.length >= 20) {
      fectchGames = false;
      badgequestionsList = localResult;
      notifyListeners();
    } else {
      ///Nothing found in database , fetch from server
      if (context.mounted) {
        final result = await GameFunction()
            .fetchQuestions(context: context, nextUrl: nextUrl);

        if (result is HttpResponseModel) {
          for (var i = 0; i < (result.results ?? []).length; i++) {
            final question = QuestionModel.fromJson((result.results![i]));

            // add first 20 to batch list
            if (i < 20) {
              badgequestionsList.add(question);
            }

            // add the rest to database
            else {
              GameLocalDatabase.addQuestion(question);
            }

            //move on without waiting for the rest
            if (i == 19) {
              fectchGames = false;
              notifyListeners();
            }
          }
          nextUrl = result.next ?? '';
          cacheNextUrl();
        } else {
          fectchGames = false;
          notifyListeners();
        }
      }
      notifyListeners();
    }
  }

  void addSelectedAnswer(
      {required int questioinId, required OptionModel? option}) {
    if (option == null) {
      resultList.addAll({
        questioinId: {
          'question': questioinId,
          'option': null,
          'marks': 0,
        }
      });
    } else {
      resultList.addAll({
        option.question: {
          'question': option.question,
          'option': option.id,
          'marks': option.isCorrect ? 1 : 0,
        }
      });
    }
  }

  String getTotalResults() {
    num total = 0;
    resultList.map((key, value) {
      total += value['marks'] ?? 0;
      return MapEntry(key, value);
    });
    return '$total';
  }

//////////////////
/////Game Rank
  void fetchGameRanks(BuildContext context,
      {required RankType rankType}) async {
    loadingRanks = true;
    gameRankings = [];
    notifyListeners();
    if (context.mounted) {
      List<GameRankModel> result = [];
      if (rankType == RankType.singlePlayer) {
        result = await GameFunction()
            .getSingleGameRanks(context: context, limit: 20);
      } else if (rankType == RankType.multiPlayer) {
        result =
            await GameFunction().getMultiGameRanks(context: context, limit: 20);
      }
      if (result.isNotEmpty) {
        gameRankings = result;
        loadingRanks = false;
        notifyListeners();
      }
      loadingRanks = false;
      notifyListeners();
    }
  }

  setMyGameRank(GameRankModel gameRank, {bool? dontNotify}) {
    myRank = gameRank;
    if (!(dontNotify ?? false)) {
      notifyListeners();
    }
  }

/////////////////
///// Cache data

  cacheGoldenBadges() {
    SharedPreferencesHelper.setInt(key: 'goldenChances', value: goldenChances);
  }

  cacheFiftyfifty() async {
    SharedPreferencesHelper.setInt(key: 'fiftyFifty', value: fiftyFifty);
  }

  cacheNextUrl() async {
    SharedPreferencesHelper.setString(key: 'nextUrl', value: nextUrl);
  }

  cacheLongestAnswerStreaks() {
    final int oldStreak = SharedPreferencesHelper.getInt('longestStreaks') ?? 0;
    if (longestStreaks > oldStreak) {
      SharedPreferencesHelper.setInt(
          key: 'longestStreaks', value: longestStreaks);
    }
  }

  /////////////////// /////////////////// /////////////////// /////////////////// ///////////////////
  /// /////////////////// /////////////////// /////////////////// /////////////////// ///////////////////
  ///  /////////////////// Multi Player /////////////////// ///////////////////

  /// Multi Player ///
  GameSession? gameSession;
  StartGameModel? mutligame;
  QuestionModel? _multiQuestion;
  MultiGameState _currentGameState = MultiGameState.waiting;

  int multiQuestionNumber = 0;

  MultiGameState get getCurentState => _currentGameState;
  QuestionModel? get getMultiQuestion => _multiQuestion;

  int multiGoldenChances = 0;
  int multiFiftyFifty = 0;

  int multiAnswerStreaks = 0;
  int multiLongestStreaks = 0;

  ///Gamerecords
  int multiCurrentGamePoints = 0;
  int multiTotalPoints = 0;

  GameRankModel? myMultiRank;

  GroupGameRankModel? multiGroupPlayRank;

  setMultiQUestionNumber(int number) {
    multiQuestionNumber = number;
    notifyListeners();
  }

  //gamePoints
  addMultiGamePoints(int points) {
    multiCurrentGamePoints += points;
    notifyListeners();
  }

  addMultiCurrentPointsToTotal() {
    multiTotalPoints += multiCurrentGamePoints;
  }

  setMultiTotalPoints(int number) {
    multiTotalPoints = number;
    notifyListeners();
  }

  //// Game Stuffs ///
  //fifty
  addMultiFiftyfifty() {
    multiFiftyFifty++;
    notifyListeners();
  }

  reduceMultiFiftyfifty() {
    multiFiftyFifty--;
    notifyListeners();
  }

  setMultiFiftyfifty(int number) {
    multiFiftyFifty = number;
    notifyListeners();
  }

//golden chance
  addMultiGoldenChances(BuildContext context) {
    multiGoldenChances++;
    showGameNotification(
        context,
        OverlayModel(
            title: 'Congratulations',
            subtitle: 'You have earned 1 golden badge ',
            trailing: SvgPicture.asset(
              'assets/images/gold_badge.svg',
              width: 32,
              height: 32,
            )));
    notifyListeners();
  }

  reduceMultiGoldenChances() {
    multiGoldenChances--;
    notifyListeners();
  }

  setMultiGoldenChances(int number) {
    multiGoldenChances = number;
    notifyListeners();
  }

//
  resetMultiAnswerStreak() {
    multiAnswerStreaks = 0;
    multiLongestStreaks = 0;
    notifyListeners();
  }

  increaseMultiAnswerStreak(
      {required BuildContext context, required bool hasGolden}) {
    multiAnswerStreaks++;
    multiLongestStreaks++;
    if (multiAnswerStreaks > 1 && multiAnswerStreaks % 5 != 0 && !hasGolden) {
      showGameNotification(
          context,
          OverlayModel(
              title: 'Answer Streak',
              subtitle:
                  '${5 - (multiAnswerStreaks % 5)} more to earn a 50/50 bonus',
              leadingImage: 'assets/images/game_logo 1.svg',
              trailing: Text(
                '${multiLongestStreaks}X',
                style: TextStyle(
                    fontSize: d.pSH(35),
                    fontFamily: 'Architects_Daughter',
                    color: AppColors.kGameRed, //const Color(0xFFFFD700),
                    fontWeight: FontWeight.bold),
              )));
    }
    if (multiAnswerStreaks % 5 == 0) {
      multiFiftyFifty++;
      multiAnswerStreaks = 0;
      showGameNotification(
          context,
          OverlayModel(
              title: 'Congratulations',
              subtitle: 'You have earned 1 golden & 50/50 bonus',
              trailing: hasGolden
                  ? const TwoImages(
                      front: 'assets/images/gold_badge.svg',
                      back: 'assets/images/5050.svg')
                  : SvgPicture.asset(
                      'assets/images/5050.svg',
                      width: 32,
                      height: 32,
                    )));
    }
    notifyListeners();
  }

  setMyMultiGameRank(GameRankModel gameRank) {
    myMultiRank = gameRank;
    //notifyListeners();
  }

  setGroupMultiRank(GroupGameRankModel groupRank) {
    multiGroupPlayRank = groupRank;
    //notifyListeners();
  }

  setMultiGame(StartGameModel? multi) {
    mutligame = multi;
    notifyListeners();
  }

/////
////// Game Session
  setGameSession(GameSession gameSess) {
    gameSession = gameSess;
    if ((gameSession?.games ?? []).isNotEmpty) {
      mutligame = gameSession?.games[0];
    }
    notifyListeners();
  }

  addGameToSession(StartGameModel game) {
    gameSession?.games = (gameSession?.games ?? []) + [game];
  }

  addMultiGamePlayer(AppUser user) {
    gameSession?.players += [user];
    notifyListeners();
  }

  setCurrentState(MultiGameState gameState) {
    _currentGameState = gameState;
    notifyListeners();
  }

  setMultiQuestiion(QuestionModel ques) {
    _multiQuestion = ques;
    notifyListeners();
  }

  startMultiPlayerGame(
      {required BuildContext context, required String gameName}) {
    showGameNotification(
        context,
        OverlayModel(
            title: gameName,
            subtitle: 'Game has started please be alert',
            trailing: SvgPicture.asset(
              'assets/images/5050.svg',
              width: 32,
              height: 32,
            )));

    Future.delayed(const Duration(seconds: 2), () {
      nextScreen(context, const MultiQuestionsPage(isAdmin: true));
    });
  }

  resetMultiGame() {
    mutligame = null;
    multiQuestionNumber = 0;
    multiCurrentGamePoints = 0;
    _multiQuestion = null;
    multiAnswerStreaks = 0;
    myMultiRank = null;
  }

  resetMultiGameBadges() {
    multiFiftyFifty = 0;
    multiGoldenChances = 0;
  }
}

enum MultiGameState { waiting, question, paused, finished, started, results }
