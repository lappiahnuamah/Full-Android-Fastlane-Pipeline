import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/games/game_function.dart';
import 'package:savyminds/models/games/game_rank_model.dart';
import 'package:savyminds/providers/appsocket_provider.dart';
import 'package:savyminds/providers/game_provider.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
// import 'package:savyminds/screens/game/players.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/number_utils.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

import '../../../../../data/app_data.dart';

class ScoreGameState extends StatefulWidget {
  const ScoreGameState(
      {super.key,
      required this.gameRanks,
      required this.isAdmin,
      required this.overallGameRanks});
  final List gameRanks;
  final List overallGameRanks;
  final bool isAdmin;

  @override
  State<ScoreGameState> createState() => _ScoreGameStateState();
}

class _ScoreGameStateState extends State<ScoreGameState> {
  late GameProvider gameProvider;
  late UserDetailsProvider userProvider;
  late GameWebSocket gameSocket;

  bool isLoading = false;

  int selectedIndex = 0;

  @override
  void initState() {
    gameProvider = context.read<GameProvider>();
    userProvider = context.read<UserDetailsProvider>();
    gameSocket = context.read<GameWebSocket>();
    gameProvider.resetMultiGame();
    GameFunction().getGameStreaks(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final bright = Theme.of(context).brightness;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(
              top: d.pSH(20),
            ),
            child: Column(children: [
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      SizedBox(height: d.pSH(5)),
                      TabBar(
                        onTap: (index) {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: AppColors.kGameBlue,
                        tabs: [
                          Tab(
                            child: TransformedButton(
                              onTap: null,
                              buttonText: 'Game Rank',
                              width: double.infinity,
                              fontSize: getFontSize(20, size),
                              buttonColor: selectedIndex == 0
                                  ? AppColors.kGameBlue
                                  : AppColors.kDarkButtonColor,
                              isReversed: true,
                            ),
                          ),
                          Tab(
                            icon: TransformedButton(
                              onTap: null,
                              buttonText: 'Overall Rank',
                              fontSize: getFontSize(20, size),
                              buttonColor: selectedIndex == 1
                                  ? AppColors.kGameBlue
                                  : AppColors.kDarkButtonColor,
                            ),
                            iconMargin: EdgeInsets.zero,
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(children: [
                          rankList(widget.gameRanks),
                          rankList(widget.overallGameRanks),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: d.pSH(10), vertical: d.pSH(10)),
                child: isLoading
                    ? Container(
                        height: d.pSH(50),
                        width: d.pSH(50),
                        margin: EdgeInsets.only(bottom: d.pSH(15)),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.kGameRed,
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: TransformedButton(
                              onTap: () {
                                gameSocket.closeSocket();
                                gameProvider.resetMultiGameBadges();
                                // nextScreen(context, const PlayersSelect());
                              },
                              buttonText: 'RETURN HOME',
                              fontSize: getFontSize(20, size),
                              isReversed: true,
                              height: d.pSH(60),
                              width: widget.isAdmin
                                  ? d.getPhoneScreenWidth() * 0.55
                                  : null,
                              buttonColor: AppColors.kGameRed,
                            ),
                          ),
                          if (widget.isAdmin)
                            SizedBox(
                              width: d.pSH(20),
                            ),
                          if (widget.isAdmin)
                            Expanded(
                              child: TransformedButton(
                                onTap: () {
                                  startNewGame();
                                },
                                buttonText: 'PLAY AGAIN',
                                fontSize: getFontSize(20, size),
                                height: d.pSH(60),
                                buttonColor: AppColors.kGameGreen,
                                width: d.getPhoneScreenWidth() * 0.65,
                              ),
                            ),
                        ],
                      ),
              ),
              if (Platform.isIOS)
                SizedBox(
                  height: d.pSH(20),
                )
            ]),
          ),
        ),
      ),
    );
  }

  Widget rankLadder({required GameRankModel rank, required int index}) {
    final bright = Theme.of(context).brightness;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: d.pSW(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(d.pSH(28)),
            child: CircleAvatar(
              radius: d.pSH(30),
              child: Image.network(
                rank.user?.profileImage ?? AppData.defaultUserImage,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person);
                },
              ),
            ),
          ),
          SizedBox(
            height: d.pSH(20),
          ),
          Container(
            height: getHeight(rank.rank == 0 ? index : rank.rank),
            width: d.pSW(70),
            decoration: BoxDecoration(
              color: bright == Brightness.dark
                  ? AppColors.kGameDarkBlue
                  : AppColors.kGameBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(d.pSH(20)),
                topRight: Radius.circular(d.pSH(20)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double getHeight(int rank) {
    switch (rank) {
      case 1:
        return d.pSH(120);
      case 2:
        return d.pSH(90);
      default:
        return d.pSH(70);
    }
  }

  Future startNewGame() async {
    setState(() {
      isLoading = true;
    });

    final result = await GameFunction().createNewGameSession(
        context: context, sessionId: gameProvider.gameSession?.id);

    setState(() {
      isLoading = false;
    });

    if (result != null) {
      if (context.mounted) {
        Provider.of<GameProvider>(context, listen: false)
            .setGameSession(result);
      }
    } else {
      Fluttertoast.showToast(msg: 'Failed to create new game');
    }
  }

  Widget rankList(List gameRanks) {
    final size = MediaQuery.of(context).size;
    final bright = Theme.of(context).brightness;
    return Column(
      children: [
        if (gameRanks.length > 2)
          Container(
            height: d.pSH(250),
            width: double.infinity,
            color: bright == Brightness.dark
                ? AppColors.kDarkOptionBoxColor
                : AppColors.kOptionBoxColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                rankLadder(rank: gameRanks[1], index: 2),
                rankLadder(rank: gameRanks[0], index: 1),
                rankLadder(rank: gameRanks[2], index: 3),
              ],
            ),
          ),
        SizedBox(height: d.pSW(10)),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...List.generate(
                  gameRanks.length,
                  (index) {
                    final rank = gameRanks[index];
                    final bool myRank =
                        (userProvider.getUserDetails().id == rank.user?.id);

                    if (myRank) {
                      gameProvider.setMyMultiGameRank(rank);
                    }
                    return Container(
                      color:
                          myRank ? AppColors.kGameBlue.withOpacity(0.1) : null,
                      child: ListTile(
                        leading: SizedBox(
                          width: d.pSW(70),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  rank.rank != null
                                      ? rank.rank.toString()
                                      : (index + 1).toString(),
                                  style: TextStyle(
                                    color: bright == Brightness.dark
                                        ? AppColors.kGameDarkTextColor
                                        : AppColors.kGameTextColor,
                                    fontFamily: 'Architects_Daughter',
                                    fontSize: getFontSize(20, size),
                                  )),
                              SizedBox(
                                width: d.pSW(10),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(d.pSH(28)),
                                child: CircleAvatar(
                                  radius: d.pSH(22),
                                  child: Image.network(
                                    rank.user?.profileImage ?? '',
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.person);
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        title: Text((rank.user?.username ?? 'User'),
                            style: TextStyle(
                              color: bright == Brightness.dark
                                  ? AppColors.kGameDarkTextColor
                                  : AppColors.kGameTextColor,
                              fontFamily: 'Architects_Daughter',
                              fontSize: getFontSize(20, size),
                            )),
                        trailing: Text(
                            NumberUtils().formatNumberToKAndM(rank.totalScore),
                            style: TextStyle(
                              color: AppColors.kGameBlue,
                              fontFamily: 'Architects_Daughter',
                              fontSize: getFontSize(20, size),
                            )),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
