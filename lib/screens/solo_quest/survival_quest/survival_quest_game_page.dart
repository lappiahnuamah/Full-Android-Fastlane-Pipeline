import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/games/option_model.dart';
import 'package:savyminds/models/games/question_model.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/providers/game_items_provider.dart';
import 'package:savyminds/providers/game_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_enums.dart';
import 'package:savyminds/resources/app_fonts.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/screens/categories/categories_submit_page.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/answer_button.dart';
import 'package:savyminds/widgets/custom_text.dart';
import 'package:savyminds/widgets/dialogs/game_hint_dialog.dart';
import 'package:savyminds/widgets/game_image_options.dart';
import 'package:savyminds/widgets/game_page_background.dart';
import 'package:savyminds/widgets/game_page_keys_list.dart';
import 'package:savyminds/widgets/game_top_keys_list.dart';
import 'package:savyminds/widgets/mystery_box_open.dart';

class SurvivalQuestGamePlay extends StatefulWidget {
  const SurvivalQuestGamePlay(
      {super.key, required this.quest, required this.questionList});
  final QuestModel quest;
  final List<QuestionModel> questionList;

  @override
  State<SurvivalQuestGamePlay> createState() => _SurvivalQuestGamePlayState();
}

class _SurvivalQuestGamePlayState extends State<SurvivalQuestGamePlay>
    with TickerProviderStateMixin {
  PageController pageController = PageController(initialPage: 0);
  ValueNotifier<int> seconds = ValueNotifier<int>(10);
  ValueNotifier<List<int>> fiftyfityList = ValueNotifier<List<int>>([]);
  OptionModel? selectedAnswer;
  Map<int, dynamic> resultList = {};

  int selectedIndex = 0;
  Timer? timer;

  bool timesTwoActivated = false;
  bool breakTime = false;
  bool showRetake = false;

  ///////////////////////////////
  //////Animations
  late AnimationController controller;
  late AnimationController totalController;
  late Animation<double> sizeAnimation;

  ///late Animation<double> animation;
  late Animation<Offset> positionAnimation;
  late Animation<double> _fontSizeAnimation;

  late Animation<double> totalAnimation;
  bool showAnimation = false;
  String currentNumber = '+1';
  String targetNumber = '';
  double fontSize = 45.0;
  int gamePoints = 1;

  int currentGamePoints = 0;
  int totalPoints = 0;

  int answerStreak = 0;
  int loseStreaks = 0;

  int survivalHearts = 4;

  //hide keys
  bool hideDoublePointsKey = false;
  bool hideMysteryBoxKey = false;

  //swap
  PageController swapController = PageController(initialPage: 0);

  startTimer(int? time) {
    seconds.value = time ?? 10;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds.value = seconds.value - 1;
      if (seconds.value == 0) {
        if (selectedIndex < widget.questionList.length - 1) {
          pageController.nextPage(
              duration: const Duration(
                milliseconds: 400,
              ),
              curve: Curves.easeIn);
          // gameProvider.addSelectedAnswer(
          //     option: selectedAnswer,
          //     questioinId: questionList[selectedIndex].id);
          if (selectedAnswer == null) {
            answerStreak = 0;
          }
          timer.cancel();
          FlameAudio.bgm.stop();
        } else {
          // gameProvider.addSelectedAnswer(
          //     option: selectedAnswer,
          //     questioinId: questionList[selectedIndex].id);
          if (selectedAnswer == null) {
            answerStreak = 0;
          }
          timer.cancel();
          FlameAudio.bgm.stop();
          FlameAudio.play('outro_game_over.mp3');
          nextScreen(
              context,
              CategorySubmitPage(
                questionList: widget.questionList,
                totalPoints: totalPoints,
                resultList: resultList,
              ));
          // pageController.jumpToPage(0);
          selectedIndex = 0;
          startTimer(15);
          setState(() {});
        }
      }
      if (seconds.value == 5) {
        // shakeFiftyFiftyIcon();
        FlameAudio.bgm.play('five_sec_more.mp3');
      }
      if (seconds.value == 3) {
        // shakeGoldenBadge();
      }
    });
  }

  late GameItemsProvider gameItemsProvider;

  @override
  void initState() {
    gameItemsProvider = context.read<GameItemsProvider>();
    //  startTimer(widget.questionList[selectedIndex].questionTime);
    FlameAudio.bgm.stop();
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    setAnimations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        GamePageBackground(icon: widget.quest.icon),

        //Actual Game
        SafeArea(
          child: Consumer2<GameProvider, GameItemsProvider>(
              builder: (context, gameProvider, gameItemsProvider, child) {
            return Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.fromLTRB(d.pSH(16), d.pSH(10), d.pSH(16), 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Card(
                          elevation: .1,
                          child: Padding(
                            padding: EdgeInsets.all(d.pSH(6)),
                            child: SvgPicture.network(
                              widget.quest.icon,
                              height: d.pSH(22),
                              colorFilter: const ColorFilter.mode(
                                  AppColors.kPrimaryColor, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ),

                      //Survival Hearts
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...List.generate(
                            survivalHearts,
                            (index) => Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: d.pSW(5)),
                              child: SvgPicture.asset(
                                AppImages.lifeSvg,
                              ),
                            ),
                          ),
                        ],
                      ),

                      //Score
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (timesTwoActivated)
                            CustomText(
                              label: 'x2',
                              color: AppColors.everGreen,
                              fontSize: getFontSize(18, size),
                              fontWeight: FontWeight.bold,
                            ),
                          SizedBox(
                            width: d.pSH(10),
                          ),
                          CustomText(
                            label: '$totalPoints',
                            color: AppColors.kPrimaryColor,
                            fontSize: getFontSize(24, size),
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: PageView.builder(
                  controller: pageController,
                  itemCount: widget.questionList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (val) {
                    selectedIndex = val;
                    hideDoublePointsKey = false;
                    hideMysteryBoxKey = false;
                    if (widget.questionList[selectedIndex].isGolden) {
                      FlameAudio.play('when_question_is_star.mp3');
                    } else {
                      FlameAudio.play('new_question.mp3');
                    }
                    startTimer(widget.questionList[selectedIndex].questionTime);
                  },
                  itemBuilder: (context, index) {
                    QuestionModel question = widget.questionList[index];

                    return Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: d.pSH(16)),
                            child: Column(
                              children: [
                                if (question.isGolden)
                                  SvgPicture.asset(
                                    'assets/icons/star.svg',
                                    height: d.pSH(25),
                                  ).animate()
                                    ..shimmer(duration: 1000.ms)
                                    ..scale(duration: 1000.ms),
                                SizedBox(height: d.pSH(10)),
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(question.text,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: AppFonts.caveat,
                                          color: AppColors.textBlack,
                                          fontSize: getFontSize(
                                              question.image.isEmpty ? 30 : 22,
                                              size), //88 : 20
                                          fontWeight: FontWeight.w600,
                                        )),
                                    if (question.image.isNotEmpty)
                                      SizedBox(height: d.pSH(20)),
                                    if (question.image.isNotEmpty)
                                      Expanded(
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: Transform(
                                            alignment: Alignment.center,
                                            transform: Matrix4.identity()
                                              ..setEntry(3, 2,
                                                  0.002) // Adjust the perspective by changing this value
                                              ..rotateX(0.3)
                                              ..rotateY(0.05),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            d.pSH(20))),
                                                padding:
                                                    EdgeInsets.all(d.pSH(5)),
                                                child: Image.network(
                                                  question.image,
                                                  fit: BoxFit.fill,
                                                )),
                                          ),
                                        ),
                                      ),
                                    if (question.image.isNotEmpty)
                                      SizedBox(height: d.pSH(10)),
                                  ],
                                )),

                                //Question Number and Timer
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ///
                                    ///Question number
                                    Text(
                                      "${index + 1}/${widget.questionList.length}",
                                      style: TextStyle(
                                          color: AppColors.hintTextBlack,
                                          fontSize: getFontSize(20, size),
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(width: d.pSH(30)),
                                    GameTopKeysList(
                                      showHint: false,
                                      showMysteryBox: question.hasMysteryBox &&
                                          !hideMysteryBoxKey,
                                      showTimesTwo:
                                          question.hasTimesTwoPoints &&
                                              !hideDoublePointsKey,
                                      onMysteryBoxPressed: () {
                                        _showMysteryBox();
                                      },
                                      onHintPressed: () {
                                        _showHintDialog(question.hint);
                                      },
                                      onTimesTwoPressed: () {
                                        setState(() {
                                          timesTwoActivated = true;
                                          hideDoublePointsKey = true;
                                        });
                                      },
                                    ),
                                    SizedBox(width: d.pSH(30)),
                                    ////
                                    /// Timer
                                    ValueListenableBuilder<int>(
                                        valueListenable: seconds,
                                        builder: (context, time, child) {
                                          return SizedBox(
                                            width: d.pSH(25),
                                            child: Text(
                                              '$time',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  fontSize:
                                                      getFontSize(20, size),
                                                  color: time < 6
                                                      ? AppColors.kGameRed
                                                      : AppColors.kGameGreen,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: d.pSH(5)),
                        const Divider(color: AppColors.blueBird, thickness: 4),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    ///// Options --- (Text)
                                    ///
                                    if (question.option.isNotEmpty &&
                                        question.option[0].image.isEmpty &&
                                        question.option[0].text != '.')
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: d.pSW(15),
                                          right: d.pSW(15),
                                          top: d.pSH(5),
                                        ),
                                        child: ValueListenableBuilder<
                                                List<int>>(
                                            valueListenable: fiftyfityList,
                                            builder: (context, list, child) {
                                              return SingleChildScrollView(
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      ...List.generate(
                                                          question
                                                              .option.length,
                                                          (subIndex) {
                                                        final option = question
                                                            .option[subIndex];

                                                        return list.contains(
                                                                option.id)
                                                            ? const SizedBox()
                                                            : AnswerButton(
                                                                answer: option,
                                                                onTap: () {
                                                                  answerButtonPressed(
                                                                      option,
                                                                      question,
                                                                      context,
                                                                      index);
                                                                },
                                                                isSelected:
                                                                    selectedAnswer
                                                                            ?.id ==
                                                                        option
                                                                            .id,
                                                                isReversed:
                                                                    subIndex %
                                                                            2 ==
                                                                        0);
                                                      }),
                                                      const SizedBox(height: 20)
                                                    ]),
                                              );
                                            }),
                                      ),

                                    if (question.option.isNotEmpty &&
                                            question
                                                .option[0].image.isNotEmpty ||
                                        question.option[0].text == '.')
                                      Container(
                                          width: d.getPhoneScreenWidth() * 0.75,
                                          padding: EdgeInsets.only(
                                              top: d.pSH(20),
                                              bottom: d.pSH(10)),
                                          child: ValueListenableBuilder<
                                                  List<int>>(
                                              valueListenable: fiftyfityList,
                                              builder: (context, list, child) {
                                                return GameImageOptions(
                                                    options: question.option,
                                                    selectedAnswer:
                                                        selectedAnswer,
                                                    fiftyfityList:
                                                        fiftyfityList.value,
                                                    onOptionSelected: (option) {
                                                      answerButtonPressed(
                                                          option,
                                                          question,
                                                          context,
                                                          index);
                                                    });
                                              }))
                                  ],
                                ),
                              ),
                              SizedBox(height: d.pSH(15)),

                              //Bottom Keys
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: d.pSH(16)),
                                  child: GamePageKeysList(
                                    answerStreaks: answerStreak,
                                    onFiftyTapped: () {
                                      _useFiftyFiifty(question.option);
                                    },
                                    hideSwap: true,
                                    onFreezeTapped: () {
                                      _freezeTime(question.questionTime);
                                    },
                                    onSwapTapped: () {},
                                    onGoldenTapped: () {
                                      _useGoldenChance(
                                          question: question,
                                          questionID: question.id);
                                    },
                                  ))
                            ],
                          ),
                        ),
                        if (Platform.isAndroid) SizedBox(height: d.pSH(8))
                      ],
                    );
                  },
                ))
              ],
            );
          }),
        ),

        ////Pause cover
        if (breakTime)
          Container(
            color: Colors.black.withOpacity((showRetake ? 0.9 : 0.5)),
          ),

        //// Animation pointss
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
                          Shadow(color: Colors.black, offset: Offset(1, 1))
                        ]),
                  ),
                );
              }),
      ],
    ));
  }

  void answerButtonPressed(OptionModel option, QuestionModel question,
      BuildContext context, int index) {
    selectedAnswer = option;
    breakTime = true;
    //timer?.cancel();
    FlameAudio.bgm.stop();
    setState(() {});
    if (option.isCorrect) {
      FlameAudio.play('correct_ans.mp3');
      _addPoints(
          questionPoints: question.points,
          isGolden: question.isGolden,
          time: question.questionTime);
      answerStreak++;
      if (answerStreak == 5) {
        gameItemsProvider.increaseKeyAmount(GameKeyType.fiftyFifty);
        answerStreak = 0;
      }
      // gameProvider.increaseAnswerStreak(
      //     context: context, hasGolden: question.isGolden && seconds.value > 6);
    } else {
      FlameAudio.play('wong_ans.mp3');

      if (survivalHearts > 1) {
        setState(() {
          survivalHearts--;
        });
      } else {
        //Game over
        nextScreen(
            context,
            CategorySubmitPage(
              questionList: widget.questionList,
              totalPoints: totalPoints,
              resultList: resultList,
            ));

        return;
      }
      answerStreak = 0;
      loseStreaks++;
    }

    // GameComments().showGameCommentToast(
    //     context: context,
    //     isCorrectAswer: option.isCorrect,
    //     streaks: gameProvider.answerStreaks,
    //     lostStreaks: loseStreaks,
    //     fifty: gameProvider.fiftyFifty,
    //     goldenBadge: gameProvider.goldenChances);
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        breakTime = false;
        showRetake = false;
      });

      moveToNextScreen(index: index, questionId: question.id);
    });
  }

  _addPoints(
      {required int questionPoints,
      required bool isGolden,
      required int time}) {
    if (seconds.value <= time * 0.4) {
      gamePoints = questionPoints;
    } else if (seconds.value <= time * 0.7) {
      gamePoints = questionPoints * 2;
    } else {
      gamePoints = questionPoints * 3;
      if (isGolden) {
        gameItemsProvider.increaseKeyAmount(GameKeyType.goldenKey);
      }
    }
    if (timesTwoActivated) {
      gamePoints = gamePoints * 2;
      setState(() {
        timesTwoActivated = false;
      });
    }
    startScoreAnimation();
    Future.delayed(const Duration(seconds: 2), () {
      currentGamePoints = gamePoints;
      totalPoints += currentGamePoints;
      if (mounted) currentGamePoints;
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

  void setAnimations() {
    positionAnimation = Tween<Offset>(
      begin: Offset((d.getPhoneScreenWidth() / 2) - 40,
          (d.getPhoneScreenHeight() / 2) - 80),
      end: const Offset(-5.0, 10.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    _fontSizeAnimation = Tween<double>(begin: 100.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  ////////////////////////////####################////////////////////////
  //////////////////////////  KEY TAPPED ACTIONS   ///////////////////////
  ////////////////////////////####################////////////////////////
  _showHintDialog(String hint) async {
    timer?.cancel();
    await showDialog(
      context: context,
      builder: ((context) => AlertDialog(content: GameHintDialog(hint: hint))),
    );
    startTimer(seconds.value);

    setState(() {});
  }

  _showMysteryBox() async {
    timer?.cancel();
    hideMysteryBoxKey = true;
    setState(() {});
    await showDialog(
      context: context,
      builder: ((context) => const MysteryBoxOpen()),
    );
    startTimer(seconds.value);
  }

  _freezeTime(int questionTime) {
    timer?.cancel();
    setState(() {});
    Future.delayed(Duration(seconds: questionTime), () {
      startTimer(seconds.value);
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
      gameItemsProvider.reduceKeyAmount(GameKeyType.fiftyFifty);
    }
  }

  _useGoldenChance({required QuestionModel question, required int questionID}) {
    for (var element in question.option) {
      if (element.isCorrect) {
        FlameAudio.play('correct_ans.mp3');
        selectedAnswer = element;
        break;
      }
    }
    breakTime = true;
    timer?.cancel();
    setState(() {});
    loseStreaks = 0;
    _addPoints(
        questionPoints: question.points,
        isGolden: false,
        time: question.questionTime);
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        breakTime = false;
      });
      moveToNextScreen(index: selectedIndex, questionId: questionID);
    });
  }

  moveToNextScreen({required int index, required int questionId}) {
    timer?.cancel();
    FlameAudio.bgm.stop();
    selectedAnswer =null;
    if (index < widget.questionList.length - 1) {
      pageController.nextPage(
          duration: const Duration(
            milliseconds: 400,
          ),
          curve: Curves.easeIn);
      addSelectedAnswer(
          option: selectedAnswer, questioinId: widget.questionList[index].id);
    } else {
      addSelectedAnswer(
          option: selectedAnswer, questioinId: widget.questionList[index].id);
      nextScreen(
          context,
          CategorySubmitPage(
            questionList: widget.questionList,
            totalPoints: totalPoints,
            resultList: resultList,
          ));
    }

    ///  GameLocalDatabase.deleteQuestion(questionId);
  }

  void addSelectedAnswer(
      {required int questioinId, required OptionModel? option}) {
    if (option == null) {
      resultList.addAll({
        questioinId: {
          'question': questioinId,
          'option': null,
          'marks': 0,
        }
      });
    } else {
      resultList.addAll({
        option.question: {
          'question': option.question,
          'option': option.id,
          'marks': option.isCorrect ? 1 : 0,
        }
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    swapController.dispose();

    if (timer != null) {
      timer!.cancel();
    }
    seconds.dispose();
    fiftyfityList.dispose();
    super.dispose();
  }
}
