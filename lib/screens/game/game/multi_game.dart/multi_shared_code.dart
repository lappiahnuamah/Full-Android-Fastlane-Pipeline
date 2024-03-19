import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/functions/games/game_function.dart';
import 'package:savyminds/providers/game_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/game/game/components/game_background.dart';
import 'package:savyminds/screens/game/game/components/game_header.dart';
import 'package:savyminds/screens/game/game/components/game_text_feild.dart';
import 'package:savyminds/screens/game/game/multi_game.dart/game_creator_init.dart';
import 'package:savyminds/screens/game/game/multi_game.dart/multi_player.dart';
import 'package:savyminds/screens/game/game/multi_game.dart/participant_init.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/func_new.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/utils/validator.dart';
import 'package:savyminds/widgets/load_indicator.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

import '../../../../constants.dart';

class MultiSharedCode extends StatefulWidget {
  const MultiSharedCode({super.key, required this.createGame});
  final bool createGame;

  @override
  State<MultiSharedCode> createState() => _MultiSharedCodeState();
}

class _MultiSharedCodeState extends State<MultiSharedCode> {
  TextEditingController gameCode = TextEditingController();
  TextEditingController gameName = TextEditingController();

  final GlobalKey<FormState> _newGameForm = GlobalKey();
  final GlobalKey<FormState> _codeForm = GlobalKey();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bright = Theme.of(context).brightness;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: bright == Brightness.dark
            ? AppColors.kDarkScaffoldBackground
            : AppColors.kGameScaffoldBackground,
        body: SafeArea(
          child: Stack(
            children: [
              const GameBackground(),

              Container(
                padding: EdgeInsets.all(
                  d.pSH(20),
                ),
                child: Column(
                  children: [
                    GameHeader(
                      onTap: () {
                        nextScreen(context, const MultiPlayer());
                      },
                      isMultiPlayer: true,
                      backText: 'Back',
                    ),
                    SizedBox(
                      height: d.pSH(20),
                    ),
                    Flexible(
                      child: Stack(
                        children: [
                          Align(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ////////////////////////////////////////////
                                  ///////////////////////////////// ///////////
                                  ///////// Having a game code ///////////////
                                  if (!widget.createGame)
                                    Form(
                                      key: _codeForm,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Enter Game Code",
                                            style: TextStyle(
                                              fontSize: getFontSize(32, size),
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Architects_Daughter',
                                            ),
                                          ).animate().slideY(
                                              duration: const Duration(
                                                  milliseconds: 500)),
                                          SizedBox(
                                            height: d.pSH(20),
                                          ),
                                          Text(
                                            'These questions have been selected at random from a pool of questions.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: bright == Brightness.dark
                                                    ? AppColors
                                                        .kGameDarkText2Color
                                                    : AppColors.kGameText2Color,
                                                fontSize: getFontSize(24, size),
                                                fontFamily:
                                                    'Architects_Daughter',
                                                height: 1.3),
                                          ),
                                          SizedBox(height: d.pSH(30)),
                                          GameTextFeild(
                                            controller: gameCode,
                                            labelText: '',
                                            hintText: "Eg. X3IFN2",
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            prefixIcon:
                                                Icons.person_outline_rounded,
                                            onChanged: (value) {
                                              return;
                                            },
                                            //(Validation)//
                                            validator: (value) => AuthValidate()
                                                .validateNotEmpty(value),
                                            onSaved: (value) {
                                              gameCode.text = value ?? '';
                                            },
                                          ),
                                          SizedBox(height: d.pSH(40)),
                                          TransformedButton(
                                            onTap: () {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();

                                              if (_codeForm.currentState
                                                      ?.validate() ??
                                                  true) {
                                                _codeForm.currentState?.save();
                                                joinGame();
                                              }
                                            },
                                            buttonColor: AppColors.kGameGreen,
                                            buttonText: ' SUBMIT CODE',
                                            textColor: Colors.white,
                                            textWeight: FontWeight.bold,
                                            height: d.pSH(75),
                                            width:
                                                d.getPhoneScreenWidth() * 0.8,
                                          ),
                                        ],
                                      ),
                                    ),

                                  ////////////////////////////////////////////
                                  ////////////////////////////////////////////
                                  ///////// Create new game ///////////////
                                  if (widget.createGame)
                                    Form(
                                      key: _newGameForm,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Create New Game",
                                            style: TextStyle(
                                              fontSize: getFontSize(32, size),
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Architects_Daughter',
                                            ),
                                          ).animate().slideY(
                                              duration: const Duration(
                                                  milliseconds: 500)),
                                          SizedBox(
                                            height: d.pSH(20),
                                          ),
                                          Text(
                                            'These questions have been selected at random from a pool of questions.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: bright == Brightness.dark
                                                    ? AppColors
                                                        .kGameDarkText2Color
                                                    : AppColors.kGameText2Color,
                                                fontSize: getFontSize(24, size),
                                                fontFamily:
                                                    'Architects_Daughter',
                                                height: 1.3),
                                          ),
                                          SizedBox(height: d.pSH(30)),
                                          GameTextFeild(
                                            controller: gameName,
                                            labelText: '',
                                            hintText: "Enter game name",
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            prefixIcon:
                                                Icons.person_outline_rounded,
                                            onChanged: (value) {
                                              return;
                                            },
                                            //(Validation)//
                                            validator: (value) => AuthValidate()
                                                .validateGameName(value),
                                            onSaved: (value) {
                                              gameName.text = value ?? '';
                                            },
                                          ),
                                          SizedBox(height: d.pSH(40)),
                                          TransformedButton(
                                            onTap: () {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();

                                              if (_newGameForm.currentState
                                                      ?.validate() ??
                                                  true) {
                                                _newGameForm.currentState
                                                    ?.save();
                                                createGame();

                                                // nextScreen(
                                                //     context,
                                                //     GameCreatorInit(
                                                //         game: StartGameModel(
                                                //       gameMode: 'Multi-Player',
                                                //       players: [3],
                                                //       title: 'The best Game',
                                                //       questions: [],
                                                //       code: '2k7N_ALL',
                                                //       numberOfQuestion: 20,
                                                //       id: 23,
                                                //     )));
                                              }
                                            },
                                            buttonColor: AppColors.kGameRed,
                                            buttonText: ' CREATE GAME',
                                            textColor: Colors.white,
                                            textWeight: FontWeight.bold,
                                            isReversed: true,
                                            height: d.pSH(75),
                                            width:
                                                d.getPhoneScreenWidth() * 0.8,
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /////////////////////////////////////////////////////////
              /////////// CIRCULAR PROGRESS INDICATOR///////////////////
              Consumer<GameProvider>(builder: (context, game, child) {
                return isLoading
                    ? LoadIndicator(
                        child: appDialog(
                            context: context,
                            loadingMessage: widget.createGame
                                ? "Creating games"
                                : "Searching for game"))
                    : const SizedBox();
              })
            ],
          ),
        ),
      ),
    );
  }

  Future createGame() async {
    setState(() {
      isLoading = true;
    });

    final result = await GameFunction()
        .createGameSession(context: context, title: gameName.text);

    setState(() {
      isLoading = false;
    });
    if (result != null) {
      if (mounted) {
        Provider.of<GameProvider>(context, listen: false)
            .setGameSession(result);
        nextScreen(context, GameCreatorInit(gameSession: result));
      }
    } else {
      Fluttertoast.showToast(msg: 'Failed to create game');
    }
  }

  Future joinGame() async {
    setState(() {
      isLoading = true;
    });

    final result = await GameFunction()
        .joinGameSession(context: context, invitationCode: gameCode.text);

    //comment
    setState(() {
      isLoading = false;
    });

    if (result != null) {
      if (mounted) {
        Provider.of<GameProvider>(context, listen: false)
            .setGameSession(result);
        if (result.isCreator) {
          nextScreen(context, GameCreatorInit(gameSession: result));
        } else {
          nextScreen(context, ParticipantInit(gameSession: result));
        }
      }
    } else {
      Fluttertoast.showToast(msg: 'Failed to join game');
    }
  }
}
