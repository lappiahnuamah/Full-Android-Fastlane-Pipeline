import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/games/game_rank_model.dart';
import 'package:savyminds/providers/game_provider.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/utils/enums/game_enums.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/number_utils.dart';
import 'package:savyminds/widgets/page_template.dart';

import '../../../data/app_data.dart';

class GameRanking extends StatefulWidget {
  const GameRanking({super.key, required this.rankType});
  final RankType rankType;

  @override
  State<GameRanking> createState() => _GameRankingState();
}

class _GameRankingState extends State<GameRanking> {
  late GameProvider gameProvider;
  late UserDetailsProvider userProvider;

  @override
  void initState() {
    gameProvider = context.read<GameProvider>();
    userProvider = context.read<UserDetailsProvider>();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      gameProvider.fetchGameRanks(context, rankType: widget.rankType);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bright = Theme.of(context).brightness;
    return Consumer<GameProvider>(builder: (context, game, child) {
      return PageTemplate(
        pageTitle: widget.rankType == RankType.overall
            ? 'Game Leaderboard'
            : widget.rankType == RankType.singlePlayer
                ? 'Single Player Leaderboard'
                : 'MultiPlayer Leaderoard',
        lightBackgroundColor: AppColors.kGameScaffoldBackground,
        darkBackgroundColor: AppColors.kDarkScaffoldBackground,
        child: game.loadingRanks
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.kPrimaryColor,
                ),
              )
            : game.gameRankings.isEmpty
                ? const Center(
                    child: Text('No data found'),
                  )
                : Column(
                    children: [
                      if (game.gameRankings.length > 3)
                        Container(
                          height: d.pSH(250),
                          width: double.infinity,
                          color: bright == Brightness.dark
                              ? AppColors.kDarkOptionBoxColor
                              : AppColors.kOptionBoxColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              rankLadder(rank: game.gameRankings[1]),
                              rankLadder(rank: game.gameRankings[0]),
                              rankLadder(
                                rank: game.gameRankings[2],
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: d.pSW(5)),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ...List.generate(
                                game.gameRankings.length,
                                (index) {
                                  final rank = game.gameRankings[index];
                                  final bool myRank =
                                      (userProvider.getUserDetails().id ==
                                          rank.user?.id);

                                  if (myRank) {
                                    gameProvider.setMyGameRank(rank,
                                        dontNotify: true);
                                  }
                                  return Container(
                                    color: myRank
                                        ? AppColors.kGameBlue.withOpacity(0.1)
                                        : null,
                                    child: ListTile(
                                      leading: SizedBox(
                                        width: d.pSW(70),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text((rank.rank.toString()),
                                                style: TextStyle(
                                                  color: bright ==
                                                          Brightness.dark
                                                      ? AppColors
                                                          .kGameDarkTextColor
                                                      : AppColors
                                                          .kGameTextColor,
                                                  fontFamily:
                                                      'Architects_Daughter',
                                                  fontSize:
                                                      getFontSize(20, size),
                                                )),
                                            SizedBox(
                                              width: d.pSW(10),
                                            ),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      d.pSH(28)),
                                              child: CircleAvatar(
                                                radius: d.pSH(22),
                                                child: Image.network(
                                                  rank.user?.profileImage ?? '',
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return const Icon(
                                                        Icons.person);
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      title: Text(
                                          (rank.user?.username ?? 'User'),
                                          style: TextStyle(
                                            color: bright == Brightness.dark
                                                ? AppColors.kGameDarkTextColor
                                                : AppColors.kGameTextColor,
                                            fontFamily: 'Architects_Daughter',
                                            fontSize: getFontSize(20, size),
                                          )),
                                      trailing: Text(
                                          NumberUtils().formatNumberToKAndM(
                                              rank.totalScore),
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
                      if (game.myRank != null &&
                          widget.rankType == RankType.singlePlayer)
                        Container(
                          color: bright == Brightness.dark
                              ? AppColors.kDarkOptionBoxColor
                              : AppColors.kOptionBoxColor,
                          child: ListTile(
                            leading: SizedBox(
                              width: d.pSW(70),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      game.myRank != null
                                          ? '${game.myRank?.rank ?? 0}'
                                          : '0',
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
                                    borderRadius:
                                        BorderRadius.circular(d.pSH(28)),
                                    child: CircleAvatar(
                                      radius: d.pSH(22),
                                      child: Image.network(
                                        game.myRank?.user?.profileImage ?? '',
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(Icons.person);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            title: Text((game.myRank?.user?.username ?? 'User'),
                                style: TextStyle(
                                  color: bright == Brightness.dark
                                      ? AppColors.kGameDarkTextColor
                                      : AppColors.kGameTextColor,
                                  fontFamily: 'Architects_Daughter',
                                  fontSize: getFontSize(20, size),
                                )),
                            subtitle:
                                Text('Total points: ${game.myRank?.totalScore}',
                                    style: TextStyle(
                                      color: bright == Brightness.dark
                                          ? AppColors.kGameDarkTextColor
                                          : AppColors.kGameTextColor,
                                      fontFamily: 'Architects_Daughter',
                                      fontSize: getFontSize(16, size),
                                    )),
                          ),
                        ),

                      ///////
                      ///
                      ///////
                      if (game.myMultiRank != null &&
                          widget.rankType == RankType.multiPlayer)
                        Container(
                          color: bright == Brightness.dark
                              ? AppColors.kDarkOptionBoxColor
                              : AppColors.kOptionBoxColor,
                          child: ListTile(
                            leading: SizedBox(
                              width: d.pSW(70),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      game.myMultiRank != null
                                          ? '${game.myMultiRank?.rank ?? 0}'
                                          : '0',
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
                                    borderRadius:
                                        BorderRadius.circular(d.pSH(28)),
                                    child: CircleAvatar(
                                      radius: d.pSH(22),
                                      child: Image.network(
                                        game.myMultiRank?.user?.profileImage ??
                                            '',
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(Icons.person);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            title: Text(
                                (game.myMultiRank?.user?.username ?? 'User'),
                                style: TextStyle(
                                  color: bright == Brightness.dark
                                      ? AppColors.kGameDarkTextColor
                                      : AppColors.kGameTextColor,
                                  fontFamily: 'Architects_Daughter',
                                  fontSize: getFontSize(20, size),
                                )),
                            subtitle: Text(
                                'Total points: ${NumberUtils().formatNumberToKAndM(game.myMultiRank?.totalScore ?? 0)}',
                                style: TextStyle(
                                  color: bright == Brightness.dark
                                      ? AppColors.kGameDarkTextColor
                                      : AppColors.kGameTextColor,
                                  fontFamily: 'Architects_Daughter',
                                  fontSize: getFontSize(16, size),
                                )),
                          ),
                        )
                    ],
                  ),
      );
    });
  }

  Widget rankLadder({required GameRankModel rank}) {
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
            height: rank.rank == 1
                ? d.pSH(120)
                : rank.rank == 2
                    ? d.pSH(90)
                    : d.pSH(70),
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
}
