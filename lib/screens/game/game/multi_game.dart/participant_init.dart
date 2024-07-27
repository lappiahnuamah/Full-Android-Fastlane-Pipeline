import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/games/game_session.dart';
import 'package:savyminds/providers/appsocket_provider.dart';
import 'package:savyminds/providers/game_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/game/game/components/game_background.dart';
import 'package:savyminds/screens/game/game/components/user_profile_list.dart';
import 'package:savyminds/screens/game/game/multi_game.dart/multi_player.dart';
import 'package:savyminds/screens/game/game/multi_game.dart/multi_question_page.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/next_screen.dart';

class ParticipantInit extends StatefulWidget {
  const ParticipantInit({super.key, required this.gameSession});
  final GameSession gameSession;

  @override
  State<ParticipantInit> createState() => _ParticipantInitState();
}

class _ParticipantInitState extends State<ParticipantInit> {
  late GameWebSocket gameSocket;

  @override
  void initState() {
    gameSocket = context.read<GameWebSocket>();
    gameSocket.closeSocket();
    gameSocket.connectWebSocket(context,
        gameId: widget.gameSession.games.isNotEmpty
            ? widget.gameSession.games[0].id
            : null,
        sessionId: widget.gameSession.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bright = Theme.of(context).brightness;
    return PopScope(
        canPop: false,
        child: Consumer<GameProvider>(builder: (context, game, child) {
          return Scaffold(
            backgroundColor: bright == Brightness.dark
                ? AppColors.kDarkScaffoldBackground
                : AppColors.kGameScaffoldBackground,
            body: Stack(
              children: [
                const GameBackground(),
                SafeArea(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: d.pSH(20),
                    ),
                    width: double.infinity,
                    child: Column(
                      children: [
                        const BackAndTextHeader(
                          text: 'Multi-Player',
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.gameSession.title,
                                style: TextStyle(
                                  fontSize: getFontSize(32, size),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Architects_Daughter',
                                ),
                              ).animate()
                                ..slideY(
                                    duration:
                                        const Duration(milliseconds: 500)),
                              SizedBox(height: d.pSH(10)),
                              Text(
                                'Please wait while other participants join the game.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: bright == Brightness.dark
                                        ? AppColors.kGameDarkText2Color
                                        : AppColors.kGameText2Color,
                                    fontSize: getFontSize(22, size),
                                    fontFamily: 'Architects_Daughter',
                                    height: 1.3),
                              ),
                              SizedBox(height: d.pSH(10)),
                              Text(
                                widget.gameSession.code,
                                style: TextStyle(
                                  color: bright == Brightness.dark
                                      ? AppColors.kGameDarkTextColor
                                      : AppColors.kGameTextColor,
                                  fontFamily: 'Architects_Daughter',
                                  fontSize: getFontSize(40, size),
                                ),
                              ).animate().shakeY(
                                    duration: const Duration(seconds: (1)),
                                  ),
                              SizedBox(
                                height: d.pSH(40),
                              ),
                              twinee(
                                  title: 'Members Joined',
                                  subTitle:
                                      '${(game.gameSession?.players ?? []).length}'),
                              SizedBox(
                                height: d.pSH(20),
                              ),
                              UserProfileList(
                                users: (game.gameSession?.players ?? []),
                              ),
                              SizedBox(
                                height: d.pSH(70),
                              ),
                              const CircularProgressIndicator(
                                color: AppColors.kGameRed,
                              )
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
        }));
  }

  Widget twinee({required String title, required String subTitle}) {
    final size = MediaQuery.of(context).size;
    final bright = Theme.of(context).brightness;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: getFontSize(25, size),
              fontWeight: FontWeight.w400,
              fontFamily: 'Architects_Daughter',
              color: bright == Brightness.dark
                  ? AppColors.kGameDarkText2Color
                  : AppColors.kGameText2Color),
        ),
        SizedBox(height: d.pSH(3)),
        Text(
          subTitle,
          style: TextStyle(
              color: AppColors.kGameLightBlue,
              fontFamily: 'Architects_Daughter',
              fontSize: getFontSize(30, size),
              fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  goToQuestionsPage() {
    Future.delayed(const Duration(seconds: 10), () {
      nextScreen(context, const MultiQuestionsPage(isAdmin: false));
    });
  }
}
