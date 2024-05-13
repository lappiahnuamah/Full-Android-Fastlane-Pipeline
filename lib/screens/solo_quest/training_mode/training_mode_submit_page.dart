import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/categories/categories_functions.dart';
import 'package:savyminds/functions/games/game_function.dart';
import 'package:savyminds/models/questions/question_model.dart';
import 'package:savyminds/providers/game_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/bottom_nav/custom_bottom_nav.dart';
import 'package:savyminds/screens/game/game/components/game_header.dart';
import 'package:savyminds/screens/game/ranking/game_ranking.dart';
import 'package:savyminds/utils/enums/game_enums.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/game_utils.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

import '../../../models/categories/categories_model.dart';

class CategorySubmitPage extends StatefulWidget {
  const CategorySubmitPage(
      {super.key,
      required this.questionList,
      required this.categoryModel,
      required this.totalPoints,
      required this.correctAnswers
      });
  final List<NewQuestionModel> questionList;
  final CategoryModel? categoryModel;
  final int totalPoints;
  final int correctAnswers;

  @override
  State<CategorySubmitPage> createState() => _CategorySubmitPageState();
}

class _CategorySubmitPageState extends State<CategorySubmitPage> {
  late GameProvider gameProvider;
  List<NewQuestionModel> questionList = [];

  @override
  void initState() {
    gameProvider = context.read<GameProvider>();
    questionList = widget.questionList;
    gameProvider.addCurrentPointsToTotal();
    gameProvider.clearPreviousList();

    if (widget.categoryModel != null) {
      CategoryFunctions().submitCategoryPoints(
          context: context,
          category: widget.categoryModel!.id,
          totalPoints: widget.totalPoints);
    }

    GameFunction().postGameStreaks(
        context: context,
     );
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
                                    subTitle:
                                        "${widget.correctAnswers}/${widget.questionList.length}"),
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
                          nextScreen(context, const CustomBottomNav());
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

  // getQuestions() async {
  //   if (!context.mounted) return;

  //   if (questionsLoading) return;

  //   setState(() {
  //     questionsLoading = true;
  //   });

  //   final result = await QuestionsManager.getTrainingModeQuestions(
  //     context: context,
  //     questId: widget.quest.id,
  //     level: level,
  //     categoryId: selectedCategory?.id ?? 0,
  //   );

  //   setState(() {
  //     questionsLoading = false;
  //   });

  //   if (result.isNotEmpty) {
  //     if (mounted) {
  //       nextScreen(
  //           context,
  //           TrainingModeGamePage(
  //               category: selectedCategory!,
  //               questionList: result,
  //               swapQuestionList: const [],
  //               quest: widget.quest,
  //               level: level));
  //     }
  //   } else {
  //     Fluttertoast.showToast(
  //         msg:
  //             'No questions available for this category. Please select another category.');
  //   }
  // }
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
