import 'dart:convert';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/models/games/game_rank_model.dart';
import 'package:savyminds/models/games/game_session.dart';
import 'package:savyminds/models/games/question_model.dart';
import 'package:savyminds/providers/game_provider.dart';
import 'package:savyminds/screens/game/game/multi_game.dart/game_creator_init.dart';
import 'package:savyminds/screens/game/game/multi_game.dart/game_states/score_game_state.dart';
import 'package:savyminds/screens/game/game/multi_game.dart/multi_question_page.dart';
import 'package:savyminds/screens/game/game/multi_game.dart/participant_init.dart';
import 'package:savyminds/utils/next_screen.dart';


class AppSocketFunctions {

  ///////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////  Games  //////////////////////////////////////////////////////
  allGameFunctions({required BuildContext context, required dynamic message}) {
    GameProvider gameProvider =
        Provider.of<GameProvider>(context, listen: false);
    if (message != null) {
      final event = jsonDecode(message);
      // debugPrint('event:$event');
      String eventType = event['type'];
      switch (eventType) {
        case "question":
          final question = QuestionModel.fromJson(event['data']);
          gameProvider.setCurrentState(MultiGameState.question);
          gameProvider.setMultiQuestiion(question);
          gameProvider.setMultiQUestionNumber(event['counter']);
          FlameAudio.bgm.stop();
          if (question.isGolden) {
            FlameAudio.play('when_question_is_star.mp3');
          } else {
            FlameAudio.play('new_question.mp3');
          }
          break;
        case 'game_paused':
          FlameAudio.bgm.stop();

          gameProvider.setCurrentState(MultiGameState.paused);
          break;
        case "game_started":
          gameProvider.setCurrentState(MultiGameState.waiting);
          nextScreen(
              context, MultiQuestionsPage(isAdmin: gameProvider.isAdmin));
          break;
        case "game_ended":
          gameProvider.setCurrentState(MultiGameState.finished);
          FlameAudio.bgm.stop();
          FlameAudio.play('outro_game_over.mp3');
          break;
        case "session_rank":
          gameProvider.setCurrentState(MultiGameState.results);
          final List gameRanks = (event['data']?['current_game_rank'] ?? [])
              .map((e) => GameRankModel.fromMultiJson(e))
              .toList();
          final List overallRanks = (event['data']?['session_rank'] ?? [])
              .map((e) => GameRankModel.fromOverallMultiJson(e))
              .toList();
          nextScreen(
              context,
              ScoreGameState(
                gameRanks: gameRanks,
                overallGameRanks: overallRanks,
                isAdmin: gameProvider.isAdmin,
              ));
          break;
        case "new_player_joined_session":
          final game = event['data'] != null
              ? GameSession.fromJson(event['data'])
              : null;
          if (game != null) {
            gameProvider.setGameSession(game);
          }
          break;
        case "new_game_created":
          final result = GameSession.fromJson(event['data']['session']);
          gameProvider.setGameSession(result);
          if (gameProvider.isAdmin) {
            nextScreen(context, GameCreatorInit(gameSession: result));
          } else {
            nextScreen(context, ParticipantInit(gameSession: result));
          }
          break;
        default:
          break;
      }
    }
  }
}
