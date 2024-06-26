import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:savyminds/api_urls/auth_url.dart';
import 'package:savyminds/api_urls/game_url.dart';
import 'package:savyminds/api_urls/user_url.dart';
import 'package:savyminds/models/auth/app_user.dart';
import 'package:savyminds/models/error_response.dart';
import 'package:savyminds/models/games/game_rank_model.dart';
import 'package:savyminds/models/games/game_session.dart';
import 'package:savyminds/models/games/game_streak_model.dart';
import 'package:savyminds/models/questions/option_model.dart';
import 'package:savyminds/models/games/start_game.dart';
import 'package:savyminds/models/http_response_model.dart';
import 'package:savyminds/providers/game_items_provider.dart';
import 'package:savyminds/providers/game_provider.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:savyminds/utils/connection_check.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../../resources/app_enums.dart';

class GameFunction {
  Future fetchQuestions(
      {required BuildContext context, required String nextUrl}) async {
    final hasConnection = await ConnectionCheck().hasConnection();
    if (hasConnection) {
      if (context.mounted) {
        final String accessToken =
            Provider.of<UserDetailsProvider>(context, listen: false)
                .getAccessToken();

        final response = await http.get(
          Uri.parse(nextUrl.isNotEmpty ? nextUrl : GameUrl.questions),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
            "Authorization": "Bearer $accessToken"
          },
        );
        if (response.statusCode == 200) {
          // print("Response ${response.body}");
          return HttpResponseModel.fromJson(jsonDecode(response.body));
        } else {
          //print("Error ${response.body}");

          return ErrorResponse.fromJson(jsonDecode(response.body));
        }
      }
    } else {
      //print('error');
      if (context.mounted) {
        Fluttertoast.showToast(msg: 'No internet connection');
      }
      return null;
    }
  }

  Future submitAnswers(
      {required BuildContext context,
      required Map<int, dynamic> resultList,
      required int totalPoints}) async {
    List questionsList = [];
    final hasConnection = await ConnectionCheck().hasConnection();
    if (hasConnection) {
      if (context.mounted) {
        var uuid = const Uuid();
        //get correct answers
        for (var element in resultList.entries) {
          questionsList.add(element.value);
        }
        String accessToken =
            Provider.of<UserDetailsProvider>(context, listen: false)
                .getAccessToken();
        final gameProvider = Provider.of<GameProvider>(context, listen: false);

        final response = await http.post(Uri.parse(GameUrl.submitAnswers),
            headers: {
              "content-type": "application/json",
              "accept": "application/json",
              "Authorization": "Bearer $accessToken"
            },
            body: jsonEncode({
              "game": uuid.v4(),
              "game_mode": "Single Player",
              "questions": questionsList,
              'total_points': totalPoints
            }));
        log(response.body);
        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          gameProvider.setRank(result['rank'] ?? 0);
          gameProvider.myRank?.rank = result['rank'];
          if (result["total_game_points"] != null) {
            gameProvider.setTotalPoints(result["total_game_points"]);
          }
          return result;
        } else {
          return ErrorResponse.fromJson(jsonDecode(response.body));
        }
      }
    } else {
      //print('error');

      return null;
    }
  }

  //////
  //////
  Future getGameStreaks({
    required BuildContext context,
  }) async {
    final gameItemsProvider = context.read<GameItemsProvider>();
    final hasConnection = await ConnectionCheck().hasConnection();
    try {
      if (hasConnection) {
        if (context.mounted) {
          String accessToken =
              Provider.of<UserDetailsProvider>(context, listen: false)
                  .getAccessToken();

          final gameProvider =
              Provider.of<GameProvider>(context, listen: false);

          final response = await http.get(
            Uri.parse('${AuthUrl.baseUrl}game-streaks/my-streak/'),
            headers: {
              "content-type": "application/json",
              "accept": "application/json",
              "Authorization": "Bearer $accessToken"
            },
          );
          log('streak get: ${response.body}');
          if (response.statusCode == 200) {
            final streaks = GameStreakModel.fromJson(jsonDecode(response.body));
            gameProvider.setUserStreaks(streaks);
            gameItemsProvider.setKeyItems(streaks);

            return true;
          } else {
            return ErrorResponse.fromJson(jsonDecode(response.body));
          }
        }
      } else {
        return ErrorResponse(errorMsg: 'No internet connection');
      }
    } catch (e) {
      log('streaks error: $e');
    }
  }

  Future postGameStreaks({
    required BuildContext context,
  }) async {
    final hasConnection = await ConnectionCheck().hasConnection();

    if (hasConnection) {
      if (context.mounted) {
        AppUser user = Provider.of<UserDetailsProvider>(context, listen: false)
            .getUserDetails();
        String accessToken =
            Provider.of<UserDetailsProvider>(context, listen: false)
                .getAccessToken();

        final gameItemsProvider =
            Provider.of<GameItemsProvider>(context, listen: false);

        final userKeys = gameItemsProvider.userKeys;
        Map data = {};
        data['fifty_fifty_points'] = userKeys[GameKeyType.fiftyFifty]!.amount;
        data['golden_badges'] = userKeys[GameKeyType.goldenKey]!.amount;
        data['swap_question'] = userKeys[GameKeyType.swapKey]!.amount;
        data['freeze_time'] = userKeys[GameKeyType.freezeTimeKey]!.amount;
        data['retake_question'] = userKeys[GameKeyType.retakeKey]!.amount;

        final response = await http.patch(
          Uri.parse('${UserUrl.userUser}${user.id}/update-game-streaks/'),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
            "Authorization": "Bearer $accessToken"
          },
          body: jsonEncode(
            data,
          ),
        );
        log('post streaks: ${response.body}');
        if (response.statusCode == 200) {
          return true;
        } else {
          return false;
        }
      }
    } else {
      return null;
    }
  }

  //////
  //////
  Future<List<GameRankModel>> getSingleGameRanks(
      {required BuildContext context, int? page, int? limit}) async {
    final hasConnection = await ConnectionCheck().hasConnection();

    if (hasConnection) {
      if (context.mounted) {
        String accessToken =
            Provider.of<UserDetailsProvider>(context, listen: false)
                .getAccessToken();

        final response = await http.get(
          Uri.parse('${GameUrl.singleGameRanking}?limit=$limit'),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
            "Authorization": "Bearer $accessToken"
          },
        );
        log('streak get: ${response.body}');
        if (response.statusCode == 200) {
          final responseModel =
              HttpResponseModel.fromJson(jsonDecode(response.body));
          return (responseModel.results ?? [])
              .map((e) => GameRankModel.fromJson(e))
              .toList();
        } else {
          return [];
        }
      }
    } else {
      return [];
    }
    return [];
  }

  Future<List<GameRankModel>> getMultiGameRanks(
      {required BuildContext context, int? page, int? limit}) async {
    final hasConnection = await ConnectionCheck().hasConnection();

    if (hasConnection) {
      if (context.mounted) {
        String accessToken =
            Provider.of<UserDetailsProvider>(context, listen: false)
                .getAccessToken();

        final response = await http.get(
          Uri.parse('${GameUrl.multiGameRanking}?limit=$limit'),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
            "Authorization": "Bearer $accessToken"
          },
        );
        log('streak get: ${response.body}');
        if (response.statusCode == 200) {
          final responseModel =
              HttpResponseModel.fromJson(jsonDecode(response.body));
          return (responseModel.results ?? [])
              .map((e) => GameRankModel.fromMultiRankJson(e))
              .toList();
        } else {
          return [];
        }
      }
    } else {
      return [];
    }
    return [];
  }

  Future<GameRankModel?> getSingleGameById(
      {required BuildContext context, required int id}) async {
    final hasConnection = await ConnectionCheck().hasConnection();

    if (hasConnection) {
      if (context.mounted) {
        String accessToken =
            Provider.of<UserDetailsProvider>(context, listen: false)
                .getAccessToken();

        final response = await http.get(
          Uri.parse('${GameUrl.singleGameRanking}$id/'),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
            "Authorization": "Bearer $accessToken"
          },
        );
        log('rank get: ${response.body}');
        if (response.statusCode == 200) {
          return GameRankModel.fromJson(jsonDecode(response.body));
        } else {
          return null;
        }
      }
    } else {
      return null;
    }
    return null;
  }

  Future<StartGameModel?> createGame(
      {required BuildContext context,
      required String title,
      required String gameMode}) async {
    final hasConnection = await ConnectionCheck().hasConnection();

    if (hasConnection) {
      if (context.mounted) {
        String accessToken =
            Provider.of<UserDetailsProvider>(context, listen: false)
                .getAccessToken();

        final response = await http.post(
          Uri.parse(GameUrl.games),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
            "Authorization": "Bearer $accessToken"
          },
          body: jsonEncode(
            {
              'title': title,
              'game_mode': gameMode,
            },
          ),
        );
        if (response.statusCode == 201) {
          return StartGameModel.fromJson(jsonDecode(response.body));
        } else {
          return null;
        }
      }
    } else {
      return null;
    }
    return null;
  }

  Future<StartGameModel?> joinGame({
    required BuildContext context,
    required String invitationCode,
  }) async {
    final hasConnection = await ConnectionCheck().hasConnection();
    try {
      if (hasConnection) {
        if (context.mounted) {
          String accessToken =
              Provider.of<UserDetailsProvider>(context, listen: false)
                  .getAccessToken();
          log('error: $accessToken');
          final response = await http.post(
            Uri.parse(GameUrl.joinsGame),
            headers: {
              "content-type": "application/json",
              "accept": "application/json",
              "Authorization": "Bearer $accessToken"
            },
            body: jsonEncode(
              {
                'invite_code': invitationCode,
              },
            ),
          );
          if (response.statusCode == 200) {
            return StartGameModel.fromJson(jsonDecode(response.body));
          } else {
            log(response.body);
            return null;
          }
        }
      } else {
        return null;
      }
      return null;
    } catch (e) {
      log('join error: $e');
      return null;
    }
  }

  Future submitMultiPlayerScore({
    required BuildContext context,
    required OptionModel optionModel,
    required int score,
    required int gameId,
  }) async {
    final hasConnection = await ConnectionCheck().hasConnection();

    try {
      if (hasConnection) {
        if (context.mounted) {
          String accessToken =
              Provider.of<UserDetailsProvider>(context, listen: false)
                  .getAccessToken();

          final response =
              await http.post(Uri.parse(GameUrl.submitMultiplayerAnswer),
                  headers: {
                    "content-type": "application/json",
                    "accept": "application/json",
                    "Authorization": "Bearer $accessToken"
                  },
                  body: jsonEncode({
                    "game": gameId,
                    "question": optionModel.question,
                    "option": optionModel.id,
                    "marks": score
                  }));
          debugPrint(response.body);
          if (response.statusCode == 201) {
            return true;
          } else {
            return false;
          }
        }
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('error:$e');
    }
  }

  Future<GameSession?> createGameSession({
    required BuildContext context,
    required String title,
  }) async {
    final hasConnection = await ConnectionCheck().hasConnection();
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final iosInfo = Platform.isIOS ? await deviceInfo.iosInfo : null;
    final androidInfo =
        Platform.isAndroid ? await deviceInfo.androidInfo : null;
    log('ids: {android: ${androidInfo?.id}} {IOS: ${iosInfo?.identifierForVendor}}');

    if (hasConnection) {
      if (context.mounted) {
        String accessToken =
            Provider.of<UserDetailsProvider>(context, listen: false)
                .getAccessToken();

        final response = await http.post(
          Uri.parse(GameUrl.gameSession),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
            "Authorization": "Bearer $accessToken"
          },
          body: jsonEncode(
            {
              'title': title,
              "device_token": Platform.isIOS
                  ? '${iosInfo?.identifierForVendor}'
                  : '${androidInfo?.id}'
            },
          ),
        );
        log('session respose${response.body}');

        if (response.statusCode == 201) {
          return GameSession.fromJson(jsonDecode(response.body));
        } else {
          return null;
        }
      }
    } else {
      return null;
    }
    return null;
  }

  Future<GameSession?> joinGameSession({
    required BuildContext context,
    required String invitationCode,
  }) async {
    final hasConnection = await ConnectionCheck().hasConnection();
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final iosInfo = Platform.isIOS ? await deviceInfo.iosInfo : null;
    final androidInfo =
        Platform.isAndroid ? await deviceInfo.androidInfo : null;

    log('ids: {android: ${androidInfo?.id}} {IOS: ${iosInfo?.identifierForVendor}}');
    try {
      if (hasConnection) {
        if (context.mounted) {
          String accessToken =
              Provider.of<UserDetailsProvider>(context, listen: false)
                  .getAccessToken();
          log('error: $accessToken');
          final response = await http.post(
            Uri.parse(GameUrl.joinSession),
            headers: {
              "content-type": "application/json",
              "accept": "application/json",
              "Authorization": "Bearer $accessToken"
            },
            body: jsonEncode(
              {
                'invite_code': invitationCode,
                'device_token': Platform.isIOS
                    ? '${iosInfo?.identifierForVendor}'
                    : '${androidInfo?.id}'
              },
            ),
          );

          if (response.statusCode == 200) {
            return GameSession.fromJson(jsonDecode(response.body));
          } else {
            return null;
          }
        }
      } else {
        return null;
      }
      return null;
    } catch (e) {
      log('join error: $e');
      return null;
    }
  }

  Future<GameSession?> createNewGameSession({
    required BuildContext context,
    required int? sessionId,
  }) async {
    final hasConnection = await ConnectionCheck().hasConnection();

    if (hasConnection) {
      if (context.mounted) {
        String accessToken =
            Provider.of<UserDetailsProvider>(context, listen: false)
                .getAccessToken();

        final response = await http.get(
          Uri.parse('${GameUrl.gameSession}$sessionId/new_game/'),
          headers: {
            "content-type": "application/json",
            "accept": "application/json",
            "Authorization": "Bearer $accessToken"
          },
        );
        log('${GameUrl.gameSession}$sessionId/new_game/');
        log('new session:${response.body}');

        if (response.statusCode == 200) {
          return GameSession.fromJson(jsonDecode(response.body));
        } else {
          return null;
        }
      }
    } else {
      return null;
    }
    return null;
  }
}
