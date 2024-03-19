import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/games/game_function.dart';
import 'package:savyminds/models/games/option_model.dart';
import 'package:savyminds/models/games/question_model.dart';
import 'package:savyminds/providers/appsocket_provider.dart';
import 'package:savyminds/providers/game_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/game/game/multi_game.dart/game_states/loading_game_state.dart';
import 'package:savyminds/screens/game/game/multi_game.dart/game_states/pause_game_state.dart';
import 'package:savyminds/screens/game/game/multi_game.dart/multi_shared_code.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

import 'game_states/end_game_state.dart';

class MultiQuestionsPage extends StatefulWidget {
  const MultiQuestionsPage({super.key, required this.isAdmin});
  final bool isAdmin;

  @override
  State<MultiQuestionsPage> createState() => _MultiQuestionsPageState();
}

class _MultiQuestionsPageState extends State<MultiQuestionsPage>
    with SingleTickerProviderStateMixin {
  late GameProvider gameProvider;
  late GameWebSocket gameSocket;
  OptionModel? selectedAnswer;
  ValueNotifier<int> seconds = ValueNotifier<int>(10);
  Timer? timer;

  QuestionModel? oldQuestion;

  ValueNotifier<List<int>> fiftyfityList = ValueNotifier<List<int>>([]);

  starttTimer(int? time) {
    seconds.value = time ?? 10;
    if (timer != null) timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds.value = seconds.value - 1;
      if (seconds.value == 0) {
        FlameAudio.bgm.stop();
        timer.cancel();
        setState(() {
          breakTime = true;
        });
      }

      if (seconds.value == 5) {
        shakeFiftyFiftyIcon();
        FlameAudio.bgm.play('five_sec_more.mp3');
      }
      if (seconds.value == 3) {
        shakeGoldenBadge();
      }
    });
  }

  @override
  void initState() {
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameSocket = context.read<GameWebSocket>();
    gameProvider.multiQuestionNumber = 0;
    gameProvider.multiFiftyFifty += 2;
    gameProvider.multiGoldenChances += 2;
    setAnimations();
    FlameAudio.bgm.stop();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Media query to make it responsive
    final size = MediaQuery.of(context).size;
    final bright = Theme.of(context).brightness;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: bright == Brightness.dark
            ? AppColors.kDarkScaffoldBackground
            : AppColors.kGameScaffoldBackground,
        body: Consumer<GameProvider>(builder: (context, game, child) {
          final question = game.getMultiQuestion;
          if (oldQuestion != question) {
            breakTime = false;
            starttTimer(question?.questionTime ?? 10);
            oldQuestion = question;
            fiftyfityList.value = [];
            selectedAnswer = null;
          }

          if (game.getCurentState != MultiGameState.question) {
            breakTime = false;
            timer?.cancel();
          }

          return Stack(
            children: [
              SafeArea(
                child: Container(
                  margin: EdgeInsets.only(
                    top: d.pSH(20),
                  ),
                  child: Column(
                    children: [
                      ///
                      ///Return Home
                      SizedBox(
                        // height: d.pSH(100),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: d.pSW(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  FlameAudio.bgm.stop();
                                  showCofirmationDialog(context);
                                },
                                child: Text(
                                  ' Exit Game ',
                                  style: TextStyle(
                                    fontFamily: 'Architects_Daughter',
                                    color: bright == Brightness.dark
                                        ? AppColors.kGameDarkTextColor
                                        : AppColors.kGameTextColor,
                                    fontSize: getFontSize(22, size),
                                  ),
                                ),
                              ),

                              ///total points
                              Text(
                                '${game.multiCurrentGamePoints}',
                                style: TextStyle(
                                    fontFamily: 'Architects_Daughter',
                                    color: AppColors.kGameBlue,
                                    fontSize: getFontSize(24, size),
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),

                      ///
                      ////
                      ///
                      game.getCurentState == MultiGameState.waiting
                          ? LoadingGameState(
                              isAdmin: widget.isAdmin,
                            )
                          : game.getCurentState == MultiGameState.finished ||
                                  game.getCurentState == MultiGameState.results
                              ? EndGameState(
                                  isAdmin: widget.isAdmin,
                                )
                              : game.getCurentState == MultiGameState.paused
                                  ? PauseGameState(
                                      isAdmin: widget.isAdmin,
                                    )
                                  : Expanded(
                                      child: Column(
                                      children: [
                                        //Question Section
                                        Expanded(
                                          //flex: 4,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: d.pSW(5),
                                                vertical: d.pSH(5)),
                                            child: Column(
                                              children: [
                                                SizedBox(height: d.pSH(15)),
                                                Expanded(
                                                    child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    d.pSW(15),
                                                                vertical:
                                                                    d.pSH(10)),
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                  question?.text ??
                                                                      "",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Architects_Daughter',
                                                                    color: bright ==
                                                                            Brightness
                                                                                .dark
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                    fontSize:
                                                                        25,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  )),
                                                              if ((question
                                                                          ?.image ??
                                                                      "")
                                                                  .isNotEmpty)
                                                                SizedBox(
                                                                    height:
                                                                        d.pSH(
                                                                            20)),
                                                              if ((question
                                                                          ?.image ??
                                                                      '')
                                                                  .isNotEmpty)
                                                                Flexible(
                                                                  child:
                                                                      AspectRatio(
                                                                    aspectRatio:
                                                                        1,
                                                                    child:
                                                                        Transform(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      transform: Matrix4
                                                                          .identity()
                                                                        ..setEntry(
                                                                            3,
                                                                            2,
                                                                            0.002) // Adjust the perspective by changing this value
                                                                        ..rotateX(
                                                                            0.3)
                                                                        ..rotateY(
                                                                            0.05),
                                                                      child: Container(
                                                                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(d.pSH(10))),
                                                                          padding: EdgeInsets.all(d.pSH(5)),
                                                                          child: Image.network(
                                                                            question?.image ??
                                                                                '',
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          )),
                                                                    ),
                                                                  ),
                                                                ),
                                                              if ((question
                                                                          ?.image ??
                                                                      '')
                                                                  .isNotEmpty)
                                                                SizedBox(
                                                                    height:
                                                                        d.pSH(
                                                                            10)),
                                                            ],
                                                          ),
                                                        ))),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    ///
                                                    ///Question number
                                                    Text(
                                                      game.multiQuestionNumber
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Architects_Daughter',
                                                          color: AppColors
                                                              .kGameLightBlue,
                                                          fontSize: getFontSize(
                                                              28, size),
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),

                                                    //Golden
                                                    if (question?.isGolden ??
                                                        false)
                                                      SvgPicture.asset(
                                                        'assets/images/star.svg',
                                                        height: d.pSH(31),
                                                      ).animate()
                                                        ..shimmer(
                                                            duration: 1000.ms)
                                                        ..scale(
                                                            duration: 1000.ms),

                                                    ////
                                                    /// Timer
                                                    ValueListenableBuilder<int>(
                                                        valueListenable:
                                                            seconds,
                                                        builder: (context, time,
                                                            child) {
                                                          return Text(
                                                            formatTime(time),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Architects_Daughter',
                                                                fontSize:
                                                                    getFontSize(
                                                                        28,
                                                                        size),
                                                                color: time < 6
                                                                    ? AppColors
                                                                        .kGameRed
                                                                    : AppColors
                                                                        .kGameGreen,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          );
                                                        }),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        ///////
                                        /////// Options Area
                                        ///////
                                        Expanded(
                                          // flex: 5,
                                          child: Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: bright == Brightness.dark
                                                  ? AppColors
                                                      .kDarkOptionBoxColor
                                                  : AppColors.kOptionBoxColor,
                                            ),
                                            width: double.infinity,
                                            child: Stack(
                                              alignment:
                                                  AlignmentDirectional.center,
                                              children: [
                                                ///// Options --- (Text)
                                                ///
                                                if ((question?.option ?? [])
                                                        .isNotEmpty &&
                                                    question!.option[0].image
                                                        .isEmpty &&
                                                    question.option[0].text !=
                                                        '.')
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: d.pSW(15),
                                                        right: d.pSW(15),
                                                        top: d.pSH(10),
                                                        bottom: d.pSH(10)),
                                                    child:
                                                        ValueListenableBuilder<
                                                            List<int>>(
                                                      valueListenable:
                                                          fiftyfityList,
                                                      builder: (context, list,
                                                          child) {
                                                        return SingleChildScrollView(
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                ...List.generate(
                                                                    question
                                                                        .option
                                                                        .length,
                                                                    (subIndex) {
                                                                  final option =
                                                                      question.option[
                                                                          subIndex];

                                                                  return list.contains(
                                                                          option
                                                                              .id)
                                                                      ? const SizedBox()
                                                                      : _answerButton(
                                                                          answer:
                                                                              option,
                                                                          onTap:
                                                                              () {
                                                                            answerButtonPressed(
                                                                                option,
                                                                                question,
                                                                                context);
                                                                          },
                                                                          isSelected: selectedAnswer?.id ==
                                                                              option
                                                                                  .id,
                                                                          isReversed:
                                                                              subIndex % 2 == 0);
                                                                }),
                                                                const SizedBox(
                                                                    height: 20)
                                                              ]),
                                                        );
                                                      },
                                                    ),
                                                  ),

                                                if ((question?.option ?? [])
                                                            .isNotEmpty &&
                                                        question!.option[0]
                                                            .image.isNotEmpty ||
                                                    question!.option[0].text ==
                                                        '.')
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: d.pSW(28),
                                                        right: d.pSW(28),
                                                        top: d.pSH(20),
                                                        bottom: d.pSH(47)),
                                                    child:
                                                        ValueListenableBuilder<
                                                                List<int>>(
                                                            valueListenable:
                                                                fiftyfityList,
                                                            builder: (context,
                                                                list, child) {
                                                              return imageOptionsDesign(
                                                                  question,
                                                                  context,
                                                                  list);
                                                            }),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                    ],
                  ),
                ),
              ),
              //////////////
              //////50/50
              if (game.getCurentState == MultiGameState.question)
                Positioned(
                  bottom: d.pSH(10),
                  left: d.pSH(10),
                  child: SizedBox(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                                radius: d.pSH(3),
                                backgroundColor: game.multiAnswerStreaks > 4
                                    ? AppColors.kGameGreen
                                    : AppColors.kUnselectedCircleColor),
                            SizedBox(height: d.pSH(5)),
                            CircleAvatar(
                                radius: d.pSH(3),
                                backgroundColor: game.multiAnswerStreaks > 3
                                    ? AppColors.kGameGreen
                                    : AppColors.kUnselectedCircleColor),
                            SizedBox(height: d.pSH(5)),
                            CircleAvatar(
                                radius: d.pSH(3),
                                backgroundColor: game.multiAnswerStreaks > 2
                                    ? AppColors.kGameGreen
                                    : AppColors.kUnselectedCircleColor),
                            SizedBox(height: d.pSH(5)),
                            CircleAvatar(
                                radius: d.pSH(3),
                                backgroundColor: game.multiAnswerStreaks > 1
                                    ? AppColors.kGameGreen
                                    : AppColors.kUnselectedCircleColor),
                            SizedBox(height: d.pSH(5)),
                            CircleAvatar(
                                radius: d.pSH(3),
                                backgroundColor: game.multiAnswerStreaks > 0
                                    ? AppColors.kGameGreen
                                    : AppColors.kUnselectedCircleColor),
                            SizedBox(height: d.pSH(5)),
                            InkWell(
                              onTap: game.multiFiftyFifty < 1
                                  ? null
                                  : () {
                                      shakeFiftyFiftyIcon();
                                      _useFiftyFiifty(question?.option ?? []);
                                    },
                              splashColor: AppColors.kGameGreen,
                              child: SvgPicture.asset(
                                'assets/images/blur_50505.svg',
                                colorFilter: game.multiFiftyFifty < 1
                                    ? null
                                    : const ColorFilter.mode(
                                        AppColors.kGameGreen, BlendMode.srcIn),
                                height: d.pSH(37),
                              ).animate().shakeX(
                                  duration: Duration(
                                      seconds: (game.multiFiftyFifty > 0 &&
                                              shakeFiftyFifty)
                                          ? 2
                                          : 0)),
                            ),
                          ],
                        ),
                        SizedBox(width: d.pSW(5)),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            "${game.multiFiftyFifty}",
                            style: TextStyle(
                                fontFamily: 'Architects_Daughter',
                                color: AppColors.kGameLightBlue,
                                fontSize: getFontSize(28, size),
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              /////////////////
              //////Golden chance
              if (game.getCurentState == MultiGameState.question)
                Positioned(
                  bottom: d.pSH(10),
                  right: d.pSH(10),
                  child: SizedBox(
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      "${game.multiGoldenChances}",
                      style: TextStyle(
                          fontFamily: 'Architects_Daughter',
                          color: AppColors.kGameLightBlue,
                          fontSize: getFontSize(28, size),
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(width: d.pSW(5)),
                    InkWell(
                      onTap: game.multiGoldenChances < 1
                          ? null
                          : () {
                              shakeGoldenBadge();
                              _useGoldenChance(
                                  options: question?.option ?? [],
                                  question: question,
                                  questionTime: question?.questionTime ?? 10);
                            },
                      child: SvgPicture.asset(
                        game.multiGoldenChances < 1
                            ? 'assets/images/silver_badge.svg'
                            : 'assets/images/gold_badge.svg',
                        height: d.pSH(37),
                      ).animate().shakeY(
                          duration: Duration(
                              seconds:
                                  (shakeBadge && game.multiGoldenChances > 0)
                                      ? 2
                                      : 0)),
                    ),
                  ])),
                ),

              ////Pause cover
              if (breakTime)
                Container(
                  color: Colors.black.withOpacity(0.1),
                  margin: EdgeInsets.only(top: d.pSH(80)),
                ),

              //// Animation pointsss
              if (showAnimation)
                AnimatedBuilder(
                    animation: positionAnimation,
                    builder: (context, child) {
                      return Positioned(
                        right: positionAnimation.value.dx,
                        top: positionAnimation.value.dy,
                        child: Text(
                          '+$gamePoints',
                          style: TextStyle(
                              fontSize: _fontSizeAnimation.value,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Architects_Daughter',
                              color: AppColors.kGameLightBlue,
                              shadows: const [
                                Shadow(
                                    color: Colors.black, offset: Offset(1, 1))
                              ]),
                        ),
                      );
                    })
            ],
          );
        }),
      ),
    );
  }

  Column imageOptionsDesign(
      QuestionModel question, BuildContext context, List<int> fiftyfityList) {
    return Column(
      children: [
        Expanded(
            child: Row(
          children: [
            Expanded(
              child: fiftyfityList.contains(question.option[0].id)
                  ? const SizedBox()
                  : imageOptions(
                      answer: question.option[0],
                      onTap: () {
                        answerButtonPressed(
                            question.option[0], question, context);
                      },
                      isSelected: selectedAnswer?.id == question.option[0].id,
                      isReversed: false,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2,
                            0.002) // Adjust the perspective by changing this value
                        ..rotateX(0.25)
                        ..rotateY(-0.13)),
            ),
            SizedBox(width: d.pSH(15)),
            Expanded(
              child: question.option.length < 2
                  ? const SizedBox()
                  : fiftyfityList.contains(question.option[1].id)
                      ? const SizedBox()
                      : imageOptions(
                          answer: question.option[1],
                          onTap: () {
                            answerButtonPressed(
                                question.option[1], question, context);
                          },
                          isSelected:
                              selectedAnswer?.id == question.option[1].id,
                          isReversed: false,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2,
                                0.002) // Adjust the perspective by changing this value
                            ..rotateX(0.25)
                            ..rotateY(0.13)),
            ),
          ],
        )),
        SizedBox(height: d.pSH(10)),
        Expanded(
            child: Row(
          children: [
            Expanded(
              child: question.option.length < 3
                  ? const SizedBox()
                  : fiftyfityList.contains(question.option[2].id)
                      ? const SizedBox()
                      : imageOptions(
                          answer: question.option[2],
                          onTap: () {
                            answerButtonPressed(
                                question.option[2], question, context);
                          },
                          isSelected:
                              selectedAnswer?.id == question.option[2].id,
                          isReversed: true,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2,
                                0.002) // Adjust the perspective by changing this value
                            ..rotateX(-0.25)
                            ..rotateY(-0.13)),
            ),
            SizedBox(width: d.pSH(15)),
            Expanded(
              child: question.option.length < 4
                  ? const SizedBox()
                  : fiftyfityList.contains(question.option[3].id)
                      ? const SizedBox()
                      : imageOptions(
                          answer: question.option[3],
                          onTap: () {
                            answerButtonPressed(
                                question.option[3], question, context);
                          },
                          isSelected:
                              selectedAnswer?.id == question.option[3].id,
                          isReversed: true,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2,
                                0.002) // Adjust the perspective by changing this value
                            ..rotateX(-0.25)
                            ..rotateY(0.13)),
            ),
          ],
        ))
      ],
    );
  }

  void answerButtonPressed(
      OptionModel option, QuestionModel question, BuildContext context) {
    selectedAnswer = option;
    breakTime = true;
    timer?.cancel();
    FlameAudio.bgm.stop();
    setState(() {});
    if (option.isCorrect) {
      FlameAudio.play('correct_ans.mp3');
      _addPoints(
          questionPoints: question.points,
          isGolden: question.isGolden,
          option: option,
          time: question.questionTime);
      gameProvider.increaseMultiAnswerStreak(
          context: context, hasGolden: question.isGolden && seconds.value > 6);
    } else {
      FlameAudio.play('wong_ans.mp3');
      gameProvider.resetMultiAnswerStreak();
    }
  }

  Widget _answerButton(
      {required OptionModel answer,
      required VoidCallback onTap,
      required bool isSelected,
      required bool isReversed}) {
    return Container(
      width: d.getPhoneScreenWidth() * 0.77,
      constraints: BoxConstraints(minHeight: d.pSH(58)),
      margin: const EdgeInsets.symmetric(vertical: 5),
      //height: 60,
      child: TransformedButton(
        onTap: onTap,
        buttonColor: isSelected
            ? answer.isCorrect
                ? AppColors.kGameGreen
                : AppColors.kGameRed
            : null,
        buttonText: answer.text,
        fontSize: 20,
        isReversed: isReversed,
      ),
    );
  }

  Widget imageOptions(
      {required OptionModel answer,
      required VoidCallback onTap,
      required bool isSelected,
      required bool isReversed,
      required Matrix4 transform}) {
    final bright = Theme.of(context).brightness;

    return InkWell(
      onTap: onTap,
      child: Transform(
          alignment: Alignment.center,
          transform: transform, // Adjust the rotation angle if needed
          child: Container(
              width: double.infinity,
              height: double.maxFinite,
              padding: EdgeInsets.all(d.pSH(7)),
              decoration: BoxDecoration(
                  color: isSelected
                      ? answer.isCorrect
                          ? AppColors.kGameGreen
                          : AppColors.kGameRed
                      : bright == Brightness.dark
                          ? AppColors.kGameDarkBlue
                          : AppColors.kGameBlue,
                  borderRadius: BorderRadius.circular(d.pSH(5))),
              child: Container(
                height: double.maxFinite,
                color: AppColors.kWhite,
                child: Image.network(
                  answer.image,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.image_not_supported_rounded,
                        color: AppColors.kGameBlue,
                        size: 40,
                      ),
                    );
                  },
                ),
              ))),
    );
  }

  moveToNextScreen({required int index, required int questionId}) {
    timer?.cancel();

    gameProvider.addSelectedAnswer(option: selectedAnswer, questioinId: 0);
  }

  _addPoints(
      {required int questionPoints,
      required bool isGolden,
      required OptionModel option,
      required int time}) {
    if (seconds.value <= time * 0.4) {
      gamePoints = questionPoints;
    } else if (seconds.value <= time * 0.7) {
      gamePoints = questionPoints * 2;
    } else {
      gamePoints = questionPoints * 3;
      if (isGolden) {
        gameProvider.addMultiGoldenChances(context);
      }
    }
    GameFunction().submitMultiPlayerScore(
      context: context,
      optionModel: option,
      gameId: gameProvider.mutligame?.id ?? 0,
      score: gamePoints,
    );
    startScoreAnimation();
    Future.delayed(const Duration(seconds: 2), () {
      gameProvider.addMultiGamePoints(gamePoints);
    });
  }

  void showCofirmationDialog(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bright = Theme.of(context).brightness;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: bright == Brightness.dark
                  ? AppColors.kDarkBorderColor
                  : AppColors.kGameScaffoldBackground,
              title: Text(
                'Do you want to quit game ?',
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TransformedButton(
                        onTap: () {
                          gameSocket.closeSocket();
                          gameProvider.resetMultiGameBadges();
                          FlameAudio.bgm.stop();
                          nextScreen(
                              context,
                              MultiSharedCode(
                                createGame: widget.isAdmin,
                              ));
                        },
                        buttonColor: AppColors.kGameRed,
                        isReversed: true,
                        buttonText: 'Yes',
                      ),
                      SizedBox(
                        height: d.pSH(15),
                      ),
                      TransformedButton(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        buttonText: 'No',
                        keepBlue: true,
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }

  String formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;

    if (minutes < 1) {
      minutes = 0;
    }
    String minuteStr = minutes.toString().padLeft(2, '0');
    String secondStr = seconds.toString().padLeft(2, '0');
    return '$minuteStr:$secondStr';
  }

  ///////////////////////////////
  ///////////////////////////////
  //////Animations
  late AnimationController controller;
  late AnimationController totalController;
  late Animation<double> sizeAnimation;

  ///late Animation<double> animation;
  late Animation<Offset> positionAnimation;
  late Animation<double> _fontSizeAnimation;

  late Animation<double> totalAnimation;

  String currentNumber = '+1';
  String targetNumber = '';
  double fontSize = 45.0;

  bool showAnimation = false;
  bool shakeBadge = false;
  bool shakeFiftyFifty = false;

  int gamePoints = 1;
  int totalPoints = 0;

  bool breakTime = false;

  void setAnimations() {
    positionAnimation = Tween<Offset>(
      begin: Offset((d.getPhoneScreenWidth() / 2) - 40,
          (d.getPhoneScreenHeight() / 2) - 70),
      end: const Offset(-5.0, 10.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    _fontSizeAnimation = Tween<double>(begin: 100.0, end: -15.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void setTotalAnimation() {
    totalAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(totalController)
      ..addListener(() {
        setState(() {
          totalPoints = (lerpDouble(totalPoints, totalPoints + gamePoints,
                      totalAnimation.value) ??
                  0)
              .toInt();
        });
      });
  }

  void startScoreAnimation() {
    setState(() {
      showAnimation = true;
    });
    if (!controller.isAnimating) {
      controller.reset(); // Reset the animation
      controller.forward(); // Start the animation when the button is pressed
    }

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          currentNumber = targetNumber;
          showAnimation = false;
        });
      }
    });
  }

  void shakeGoldenBadge() {
    setState(() {
      shakeBadge = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        shakeBadge = false;
      });
    });
  }

  void shakeFiftyFiftyIcon() {
    setState(() {
      shakeFiftyFifty = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        shakeFiftyFifty = false;
      });
    });
  }

  _useFiftyFiifty(List<OptionModel> options) {
    if (options.length > 2) {
      List<int> removeList = [];
      while ((options.length - removeList.length) > 2) {
        final rand = Random().nextInt(options.length);
        if (!(options[rand].isCorrect) &&
            !(removeList.contains(options[rand].id))) {
          removeList.add(options[rand].id);
        }
      }
      fiftyfityList.value = removeList;
      FlameAudio.play('when_50_50_clicked.mp3');

      setState(() {});
      gameProvider.reduceMultiFiftyfifty();
    }
  }

  _useGoldenChance(
      {required List<OptionModel> options,
      required QuestionModel? question,
      required int questionTime}) {
    for (var element in options) {
      if (element.isCorrect) {
        FlameAudio.play('correct_ans.mp3');
        selectedAnswer = element;
        break;
      }
    }
    breakTime = true;
    timer?.cancel();
    setState(() {});
    gameProvider.reduceMultiGoldenChances();
    _addPoints(
        questionPoints: question?.points ?? 1,
        isGolden: false,
        option: selectedAnswer!,
        time: questionTime);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();

    if (timer != null) {
      timer!.cancel();
      super.dispose();
    }
    seconds.dispose();
  }
}
