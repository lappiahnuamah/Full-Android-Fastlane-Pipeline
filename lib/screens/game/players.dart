import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/games/game_function.dart';
import 'package:savyminds/providers/game_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/screens/game/game/components/game_header.dart';
import 'package:savyminds/screens/game/game/multi_game.dart/multi_player.dart';
import 'package:savyminds/screens/game/single_player_intro.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/trasformed_button.dart';
import 'game/components/game_background.dart';

class PlayersSelect extends StatefulWidget {
  const PlayersSelect({super.key});

  @override
  State<PlayersSelect> createState() => _PlayersSelectState();
}

class _PlayersSelectState extends State<PlayersSelect> {
  late GameProvider gameProvider;

  @override
  void initState() {
    gameProvider = context.read<GameProvider>();
    GameFunction().getGameStreaks(context: context);
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
            body: SafeArea(
              child: Stack(
                children: [
                  const GameBackground(),
                  SafeArea(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      width: double.infinity,
                      child: Column(
                        children: [
                          GameHeader(
                            //hideExit: true,
                            isTotal: true,
                            onTap: () {
                              FlameAudio.bgm.stop();
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             const BottomNavigation()));
                            },
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    SvgPicture.asset(AppImages.gameLogoSvg),
                                    SvgPicture.asset(
                                      AppImages.quizWhizSvg,
                                      height: d.pSH(50),
                                    ),
                                    const Text(
                                      'Think you are smart?',
                                      style: TextStyle(
                                          fontFamily: 'Architects_Daughter',
                                          fontWeight: FontWeight.w300,
                                          letterSpacing: 1.8,
                                          height: 1.5),
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TransformedButton(
                                      onTap: () {
                                        nextScreen(
                                            context, const SinglePlayerIntro());
                                      },
                                      buttonText: 'Single Player',
                                      fontSize: getFontSize(24, size),
                                      isReversed: true,
                                      height: d.pSH(82),
                                      width: d.getPhoneScreenWidth() * 0.7,
                                      buttonColor: bright == Brightness.dark
                                          ? AppColors.kGameDarkRed
                                          : AppColors.kGameRed,
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    TransformedButton(
                                      onTap: () {
                                        nextScreen(
                                            context, const MultiPlayer());
                                      },
                                      buttonText: 'MultiPlayer',
                                      fontSize: getFontSize(24, size),
                                      height: d.pSH(72),
                                      width: d.getPhoneScreenWidth() * 0.62,
                                      keepBlue: true,
                                    ),
                                  ],
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
          ),
        ],
      ),
    );
  }
}
