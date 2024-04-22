import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/games/game_function.dart';
import 'package:savyminds/models/games/question_model.dart';
import 'package:savyminds/providers/game_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/game/game/components/game_header.dart';
import 'package:savyminds/screens/game/ranking/game_ranking.dart';
import 'package:savyminds/utils/enums/game_enums.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/game_utils.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

class CategorySubmitPage extends StatefulWidget {
  const CategorySubmitPage({super.key, required this.questionList,required this.totalPoints,required this.resultList});
  final List<QuestionModel> questionList;
  final int totalPoints;
 final Map<int, dynamic> resultList;

  @override
  State<CategorySubmitPage> createState() => _CategorySubmitPageState();
}

class _CategorySubmitPageState extends State<CategorySubmitPage> {
  late GameProvider gameProvider;
  List<QuestionModel> questionList = [];

  @override
  void initState() {
    gameProvider = context.read<GameProvider>();
    questionList = widget.questionList;
    gameProvider.addCurrentPointsToTotal();
    gameProvider.clearPreviousList();
    GameFunction().submitAnswers(
        context: context,
        resultList: gameProvider.resultList,
        totalPoints: gameProvider.currentGamePoints);
    GameFunction().postGameStreaks(
        context: context,
        fiftyFifty: gameProvider.fiftyFifty,
        goldenBadges: gameProvider.goldenChances);
    GameFunction().getGameStreaks(context: context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bright = Theme.of(context).brightness;

    return Consumer<GameProvider>(builder: (context, game, child) {
      return Scaffold(
        backgroundColor: bright == Brightness.dark
            ? AppColors.kDarkScaffoldBackground
            : AppColors.kGameScaffoldBackground,
        body: SafeArea(
          child: PopScope(
            canPop: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const GameHeader(
                    hideExit: true,
                  ),
                  SizedBox(
                    height: d.pSH(30),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Align(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Game Score",
                                  style: TextStyle(
                                    fontSize: getFontSize(32, size),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: d.pSH(38),
                                ),
                                twinee(
                                    title: "Correct Answers",
                                    subTitle: "${game.getTotalResults()}/${widget.questionList.length}"),
                                SizedBox(
                                  height: d.pSH(18),
                                ),
                                twinee(
                                    title: "Points Scored",
                                    subTitle: "${widget.totalPoints}"),
                                SizedBox(
                                  height: d.pSH(18),
                                ),
                                twinee(
                                    title: "Overall Scores",
                                    subTitle:
                                        "${game.gameStreaks.totalPoints}"),
                                if (game.rank != 0)
                                  SizedBox(
                                    height: d.pSH(20),
                                  ),
                                if (game.rank != 0)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: d.pSW(10)),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        nextScreen(
                                            context,
                                            const GameRanking(
                                              rankType: RankType.singlePlayer,
                                            ));
                                      },
                                      style: TextButton.styleFrom(
                                          backgroundColor:
                                              bright == Brightness.dark
                                                  ? AppColors.kDarkBorderColor
                                                  : const Color(0xFFD3D3EB),
                                          elevation: 1),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: d.pSH(10)),
                                        child: Center(
                                          child: Text(
                                            'You are ranked ${GameUtils.numberToRank(game.rank)}',
                                            style: TextStyle(
                                                fontSize: getFontSize(22, size),
                                                fontWeight: FontWeight.w400,
                                                fontFamily:
                                                    'Architects_Daughter',
                                                color: bright == Brightness.dark
                                                    ? AppColors
                                                        .kGameDarkText2Color
                                                    : AppColors
                                                        .kGameText2Color),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: d.pSH(30),
                  ),
                  Column(
                    children: [
                      TransformedButton(
                        onTap: () {
                          // gameProvider.resetGames();
                          // nextScreen(context, const SinglePlayerIntro());
                        },
                        buttonText: 'PLAY AGAIN',
                        fontSize: getFontSize(22, size),
                        isReversed: true,
                        height: d.pSH(70),
                        width: d.getPhoneScreenWidth() * 0.55,
                        buttonColor: AppColors.kGameGreen,
                      ),
                      SizedBox(
                        height: d.pSH(30),
                      ),
                      TransformedButton(
                        onTap: () {
                          // gameProvider.resetGames();
                          // nextScreen(context, const PlayersSelect());
                        },
                        buttonText: 'Return Home',
                        fontSize: getFontSize(22, size),
                        height: d.pSH(80),
                        buttonColor: AppColors.kGameRed,
                        width: d.getPhoneScreenWidth() * 0.65,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
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
              fontSize: getFontSize(22, size),
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
              fontSize: getFontSize(28, size),
              fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class TwoImages extends StatelessWidget {
  const TwoImages({super.key, required this.back, required this.front});
  final String front;
  final String back;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      width: 32,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -d.pSH(5),
            child: SvgPicture.asset(
              back,
              width: 32,
              height: 32,
            ),
          ),
          Positioned(
            bottom: -d.pSH(5),
            child: SvgPicture.asset(
              front,
              width: 32,
              height: 32,
            ),
          )
        ],
      ),
    );
  }
}
