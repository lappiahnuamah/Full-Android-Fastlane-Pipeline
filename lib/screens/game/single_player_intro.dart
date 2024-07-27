import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/providers/game_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/game/game/components/game_background.dart';
import 'package:savyminds/screens/game/game/components/game_header.dart';
import 'package:savyminds/screens/game/players.dart';
import 'package:savyminds/screens/game/question_page.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/func_new.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/load_indicator.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

class SinglePlayerIntro extends StatefulWidget {
  const SinglePlayerIntro({super.key});

  @override
  State<SinglePlayerIntro> createState() => _SinglePlayerIntroState();
}

class _SinglePlayerIntroState extends State<SinglePlayerIntro> {
  late GameProvider gameProvider;

  @override
  void initState() {
    gameProvider = context.read<GameProvider>();
    // GameFunction().fetchGame(context: context);
    // LocalDatabase.db();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      gameProvider.fetchQuestions(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bright = Theme.of(context).brightness;

    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: bright == Brightness.dark
                ? AppColors.kDarkScaffoldBackground
                : AppColors.kGameScaffoldBackground,
            body: Stack(
              children: [
                const GameBackground(),
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    width: double.infinity,
                    child: Column(children: [
                      const GameHeader(
                        hideExit: true,
                        backText: 'Back',
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Ready?',
                                style: TextStyle(
                                  color: AppColors.kGameBlue,
                                  fontSize: getFontSize(40, size),
                                  fontFamily: 'Architects_Daughter',
                                ),
                              ),
                              SizedBox(
                                height: d.pSH(40),
                              ),
                              Text(
                                'These questions have been selected at random from a pool of questions.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: bright == Brightness.dark
                                        ? AppColors.kGameDarkText2Color
                                        : AppColors.kGameText2Color,
                                    fontSize: getFontSize(24, size),
                                    fontFamily: 'Architects_Daughter',
                                    height: 1.3),
                              ),
                              Text(
                                'Once started you cannot pause the game.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: bright == Brightness.dark
                                        ? AppColors.kGameDarkRed
                                        : AppColors.kGameRed,
                                    fontSize: getFontSize(24, size),
                                    fontFamily: 'Architects_Daughter',
                                    height: 1.3),
                              ),
                              Text(
                                'Take a deep breath and let us go!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: bright == Brightness.dark
                                        ? AppColors.kGameDarkText2Color
                                        : AppColors.kGameText2Color,
                                    fontFamily: 'Architects_Daughter',
                                    fontSize: getFontSize(24, size),
                                    height: 1.3),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              TransformedButton(
                                onTap: () {
                                  if (gameProvider
                                      .badgequestionsList.isNotEmpty) {
                                    FlameAudio.bgm.stop();
                                    nextScreen(context, const QuestionPage());
                                  } else {
                                    dialog(context);
                                  }
                                },
                                buttonColor: AppColors.kGameGreen,
                                buttonText: ' START ',
                                textColor: Colors.white,
                                textWeight: FontWeight.bold,
                                height: d.pSH(65),
                                width: d.getPhoneScreenWidth() * 0.6,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            nextScreen(context, const PlayersSelect());
                          },
                          child: Text(
                            ' Return Home ',
                            style: TextStyle(
                              color: bright == Brightness.dark
                                  ? AppColors.kGameDarkTextColor
                                  : AppColors.kGameTextColor,
                              fontFamily: 'Architects_Daughter',
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),

          /////////////////////////////////////////////////////////
          /////////// CIRCULAR PROGRESS INDICATOR///////////////////
          Consumer<GameProvider>(builder: (context, game, child) {
            return game.fectchGames
                ? LoadIndicator(
                    child: appDialog(
                        context: context, loadingMessage: "Fetching games"))
                : const SizedBox();
          })
        ],
      ),
    );
  }

  void dialog(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bright = Theme.of(context).brightness;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: bright == Brightness.dark
                  ? AppColors.kDarkBorderColor
                  : AppColors.kGameScaffoldBackground,
              title: Text(
                'Failed to load questions',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: bright == Brightness.dark
                      ? AppColors.kGameDarkText2Color
                      : AppColors.kGameText2Color,
                  fontFamily: 'Architects_Daughter',
                  fontSize: getFontSize(26, size),
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: d.pSH(10), vertical: d.pSH(10)),
                  child: Column(
                    children: [
                      TransformedButton(
                          onTap: () {
                            Navigator.pop(context);
                            gameProvider.fetchQuestions(context);
                          },
                          buttonText: 'Retry'),
                      SizedBox(
                        height: d.pSH(15),
                      ),
                      TransformedButton(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          isReversed: true,
                          buttonColor: AppColors.kGameRed,
                          buttonText: 'Quit'),
                    ],
                  ),
                ),
              ],
            ));
  }
}
