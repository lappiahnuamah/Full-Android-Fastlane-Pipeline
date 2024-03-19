import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/providers/appsocket_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/game/game/components/game_background.dart';
import 'package:savyminds/screens/game/game/components/game_header.dart';
import 'package:savyminds/screens/game/game/multi_game.dart/multi_shared_code.dart';
import 'package:savyminds/screens/game/players.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

class MultiPlayer extends StatelessWidget {
  const MultiPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bright = Theme.of(context).brightness;
    return Scaffold(
      backgroundColor: bright == Brightness.dark
          ? AppColors.kDarkScaffoldBackground
          : AppColors.kGameScaffoldBackground,
      body: Stack(
        children: [
          const GameBackground(),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  GameHeader(
                    backText: 'Back',
                    isMultiPlayer: true,
                    onTap: () {
                      nextScreen(context, const PlayersSelect());
                    },
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TransformedButton(
                          onTap: () {
                            nextScreen(context,
                                const MultiSharedCode(createGame: false));
                          },
                          buttonText: 'Join A Game',
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
                                context,
                                const MultiSharedCode(
                                  createGame: true,
                                ));
                          },
                          buttonText: 'Create Game',
                          fontSize: getFontSize(24, size),
                          height: d.pSH(72),
                          width: d.getPhoneScreenWidth() * 0.62,
                          keepBlue: true,
                        ),
                        const SizedBox(
                          height: 30,
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
    );
  }
}

class BackAndTextHeader extends StatelessWidget {
  const BackAndTextHeader({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bright = Theme.of(context).brightness;
    return Padding(
      padding: EdgeInsets.only(top: d.pSH(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Provider.of<GameWebSocket>(context, listen: false).closeSocket();
              nextScreen(context, const MultiPlayer());
            },
            child: Text(
              'Back',
              style: TextStyle(
                color: bright == Brightness.dark
                    ? AppColors.kGameDarkRed
                    : AppColors.kGameRed,
                fontFamily: 'Architects_Daughter',
                fontSize: getFontSize(28, size),
              ),
            ),
          ),
          Text(
            text,
            style: TextStyle(
              color: bright == Brightness.dark
                  ? AppColors.kGameDarkTextColor
                  : AppColors.kGameTextColor,
              fontFamily: 'Architects_Daughter',
              fontSize: getFontSize(28, size),
            ),
          ),
        ],
      ),
    );
  }
}
