import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/models/questions/option_model.dart';
import 'package:savyminds/models/level_model.dart';
import 'package:savyminds/models/questions/question_model.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/providers/game_items_provider.dart';
import 'package:savyminds/providers/game_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_enums.dart';
import 'package:savyminds/resources/app_fonts.dart';
import 'package:savyminds/screens/solo_quest/training_mode/training_mode_submit_page.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/utils/questions/questions_utils.dart';
import 'package:savyminds/widgets/answer_button.dart';
import 'package:savyminds/widgets/custom_text.dart';
import 'package:savyminds/widgets/dialogs/game_hint_dialog.dart';
import 'package:savyminds/widgets/game_image_options.dart';
import 'package:savyminds/widgets/game_page_background.dart';
import 'package:savyminds/widgets/game_page_keys_list.dart';
import 'package:savyminds/widgets/game_top_keys_list.dart';
import 'package:savyminds/widgets/mystery_box_open.dart';
import 'package:savyminds/widgets/retake_key_display.dart';

import '../../../database/new_game_db_functions.dart';

import 'dart:developer' as dev;

class TrainingModeGamePage extends StatefulWidget {
  const TrainingModeGamePage(
      {super.key,
      required this.category,
      required this.questionList,
      required this.swapQuestions,
      required this.level,
      required this.quest});
  final CategoryModel category;
  final QuestModel quest;
  final LevelName level;
  final List<NewQuestionModel> questionList;
  final Map<String, List<NewQuestionModel>> swapQuestions;

  @override
  State<TrainingModeGamePage> createState() => _TrainingModeGamePageState();
}

class _TrainingModeGamePageState extends State<TrainingModeGamePage>
    with TickerProviderStateMixin {
  PageController pageController = PageController(initialPage: 0);
  ValueNotifier<int> seconds = ValueNotifier<int>(10);
  ValueNotifier<List<int>> fiftyfityList = ValueNotifier<List<int>>([]);
  OptionModel? selectedAnswer;
  int correctAnswers = 0;

  int selectedIndex = 0;
  Timer? timer;

  bool timesTwoActivated = false;
  bool retakeActivated = false;
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

  //hide keys
  bool hideDoublePointsKey = false;
  bool hideMysteryBoxKey = false;

  bool swapQuestion = false;

  //swap
  late NewQuestionModel question;

  startTimer(int? time) {
    seconds.value = time ?? 10;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds.value = seconds.value - 1;
      if (seconds.value == 0) {
        if (selectedIndex < widget.questionList.length - 1) {
          if (swapQuestion) {
            swapQuestion = false;
            setState(() {});
          }
          pageController.nextPage(
              duration: const Duration(
                milliseconds: 400,
              ),
              curve: Curves.easeIn);
          if (selectedAnswer == null) {
            answerStreak = 0;
          }
          timer.cancel();
          FlameAudio.bgm.stop();
        } else {
          if (selectedAnswer == null) {
            answerStreak = 0;
          }
          timer.cancel();
          FlameAudio.bgm.stop();
          FlameAudio.play('outro_game_over.mp3');
          nextScreen(
              context,
              TrainingModeSubmitPage(
                categoryModel: widget.category,
                quest: widget.quest,
                pointsScored: totalPoints,
                correctAnswers: correctAnswers,
              ));
        }
      }
      if (seconds.value == 5) {
        FlameAudio.bgm.play('five_sec_more.mp3');
      }
      if (seconds.value == 3) {
        // shakeGoldenBadge();
      }
    });
  }

  late GameItemsProvider gameItemsProvider;

  Map<String, List<NewQuestionModel>> swapQuestionList = {};

  @override
  void initState() {
    gameItemsProvider = context.read<GameItemsProvider>();
    swapQuestionList = widget.swapQuestions;
    startQuestion(0);
    FlameAudio.bgm.stop();
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    setAnimations();
    super.initState();
  }

  startQuestion(int index) {
    final question = widget.questionList[index];
    final time = QuestionsUtils.getQuestionsTime(
        complexityWeight: question.complexityWeight.toDouble(),
        difficultyWeight: question.difficultyWeight.toDouble(),
        context: context,
        gameType: widget.quest.id,
        level: widget.level.name.capitalize());
    startTimer(time);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: PopScope(
      onPopInvoked: (didPop) {
        goBack();
      },
      canPop: false,
      child: Stack(
        children: [
          GamePageBackground(icon: widget.category.icon),

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
                            goBack();
                          },
                          child: SvgPicture.asset('assets/icons/log-out.svg'),
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
                            final question = widget.questionList[selectedIndex];
                            final questionTime =
                                QuestionsUtils.getQuestionsTime(
                                    complexityWeight:
                                        question.complexityWeight.toDouble(),
                                    difficultyWeight:
                                        question.difficultyWeight.toDouble(),
                                    context: context,
                                    gameType: widget.quest.id,
                                    level: widget.level.name.capitalize());

                            startTimer(questionTime);
                          },
                          itemBuilder: (context, index) {
                            if (!swapQuestion) {
                              question = widget.questionList[index];
                            }

                            return Column(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: d.pSH(16)),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(question.text,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: AppFonts.caveat,
                                                  color: AppColors.textBlack,
                                                  fontSize: getFontSize(
                                                      question.image.isEmpty
                                                          ? 30
                                                          : 22,
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
                                                    transform:
                                                        Matrix4.identity()
                                                          ..setEntry(3, 2,
                                                              0.002) // Adjust the perspective by changing this value
                                                          ..rotateX(0.3)
                                                          ..rotateY(0.05),
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        d.pSH(
                                                                            20))),
                                                        padding: EdgeInsets.all(
                                                            d.pSH(5)),
                                                        child: Image.network(
                                                          question.image,
                                                          fit: BoxFit.fill,
                                                          errorBuilder: ((context,
                                                                  error,
                                                                  stackTrace) =>
                                                              const Text(
                                                                '?',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        30),
                                                              )),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            ///
                                            ///Question number
                                            Text(
                                              "${index + 1}/${widget.questionList.length}",
                                              style: TextStyle(
                                                  color:
                                                      AppColors.hintTextBlack,
                                                  fontSize:
                                                      getFontSize(20, size),
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            SizedBox(width: d.pSH(30)),
                                            GameTopKeysList(
                                              showHint:
                                                  question.hint.isNotEmpty,
                                              showMysteryBox:
                                                  question.hasMysteryBox &&
                                                      !hideMysteryBoxKey,
                                              showTimesTwo:
                                                  question.hasTwoTimes &&
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
                                                builder:
                                                    (context, time, child) {
                                                  return SizedBox(
                                                    width: d.pSH(25),
                                                    child: Text(
                                                      '$time',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontSize: getFontSize(
                                                              20, size),
                                                          color: time < 6
                                                              ? AppColors
                                                                  .kGameRed
                                                              : AppColors
                                                                  .kGameGreen,
                                                          fontWeight:
                                                              FontWeight.w700),
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
                                const Divider(
                                    color: AppColors.blueBird, thickness: 4),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Stack(
                                          alignment:
                                              AlignmentDirectional.center,
                                          children: [
                                            ///// Options --- (Text)
                                            ///
                                            if (question.options.isNotEmpty &&
                                                question
                                                    .options[0].image.isEmpty &&
                                                question.options[0].text != '.')
                                              Container(
                                                padding: EdgeInsets.only(
                                                  left: d.pSW(15),
                                                  right: d.pSW(15),
                                                  top: d.pSH(5),
                                                ),
                                                child:
                                                    ValueListenableBuilder<
                                                            List<int>>(
                                                        valueListenable:
                                                            fiftyfityList,
                                                        builder: (context, list,
                                                            child) {
                                                          final questionOptions =
                                                              question.options;

                                                          return SingleChildScrollView(
                                                            child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  ...List.generate(
                                                                      questionOptions
                                                                          .length,
                                                                      (subIndex) {
                                                                    final option =
                                                                        questionOptions[
                                                                            subIndex];

                                                                    return list.contains(option
                                                                            .id)
                                                                        ? const SizedBox()
                                                                        : AnswerButton(
                                                                            answer:
                                                                                option,
                                                                            onTap:
                                                                                () {
                                                                              final question = widget.questionList[selectedIndex];
                                                                              final questionTime = QuestionsUtils.getQuestionsTime(complexityWeight: question.complexityWeight.toDouble(), difficultyWeight: question.difficultyWeight.toDouble(), context: context, gameType: widget.quest.id, level: widget.level.name.capitalize());
                                                                              answerButtonPressed(option: option, question: question, context: context, index: index, questionTime: questionTime);
                                                                            },
                                                                            isSelected:
                                                                                selectedAnswer?.id == option.id,
                                                                            isReversed: subIndex % 2 == 0);
                                                                  }),
                                                                  const SizedBox(
                                                                      height:
                                                                          20)
                                                                ]),
                                                          );
                                                        }),
                                              ),

                                            if (question.options.isNotEmpty &&
                                                    question.options[0].image
                                                        .isNotEmpty ||
                                                question.options[0].text == '.')
                                              Container(
                                                  width:
                                                      d.getPhoneScreenWidth() *
                                                          0.75,
                                                  padding: EdgeInsets.only(
                                                      top: d.pSH(20),
                                                      bottom: d.pSH(10)),
                                                  child: ValueListenableBuilder<
                                                          List<int>>(
                                                      valueListenable:
                                                          fiftyfityList,
                                                      builder: (context, list,
                                                          child) {
                                                        final questionOptions =
                                                            question.options;
                                                        return GameImageOptions(
                                                          options:
                                                              questionOptions,
                                                          selectedAnswer:
                                                              selectedAnswer,
                                                          fiftyfityList:
                                                              fiftyfityList
                                                                  .value,
                                                          onOptionSelected:
                                                              (option) {
                                                            final question = widget
                                                                    .questionList[
                                                                selectedIndex];
                                                            final questionTime = QuestionsUtils.getQuestionsTime(
                                                                complexityWeight:
                                                                    question
                                                                        .complexityWeight
                                                                        .toDouble(),
                                                                difficultyWeight:
                                                                    question
                                                                        .difficultyWeight
                                                                        .toDouble(),
                                                                context:
                                                                    context,
                                                                gameType: widget
                                                                    .quest.id,
                                                                level: widget
                                                                    .level.name
                                                                    .capitalize());

                                                            answerButtonPressed(
                                                                option: option,
                                                                question:
                                                                    question,
                                                                context:
                                                                    context,
                                                                index: index,
                                                                questionTime:
                                                                    questionTime);
                                                          },
                                                        );
                                                      })),
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
                                              _useFiftyFiifty(question.options);
                                            },
                                            //onRetakeTapped: () {},
                                            onFreezeTapped: () {
                                              _freezeTime(
                                                  question.questionTime);
                                            },
                                            onSwapTapped: () {
                                              if (!swapQuestion) {
                                                _swapQuestion(
                                                    question.difficulty);
                                              }
                                            },
                                            onGoldenTapped: () {
                                              final question = widget
                                                  .questionList[selectedIndex];
                                              final questionTime = QuestionsUtils
                                                  .getQuestionsTime(
                                                      complexityWeight: question
                                                          .complexityWeight
                                                          .toDouble(),
                                                      difficultyWeight: question
                                                          .difficultyWeight
                                                          .toDouble(),
                                                      context: context,
                                                      gameType: widget.quest.id,
                                                      level: widget.level.name
                                                          .capitalize());
                                              _useGoldenChance(
                                                  question: question,
                                                  questionID: question.id,
                                                  questionTime:
                                                      questionTime.toDouble());
                                            },
                                          ))
                                    ],
                                  ),
                                ),
                                if (Platform.isAndroid)
                                  SizedBox(height: d.pSH(8))
                              ],
                            );
                          }))
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

          if (breakTime && showRetake && !retakeActivated)
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SafeArea(child: RetakeKeyDisplay(
                  onRetakeTapped: () {
                    setState(() {
                      retakeActivated = true;
                    });
                  },
                )))
        ],
      ),
    ));
  }

  void answerButtonPressed(
      {required OptionModel option,
      required NewQuestionModel question,
      required BuildContext context,
      required int index,
      required int questionTime}) {
    selectedAnswer = option;
    breakTime = true;
    timer?.cancel();
    FlameAudio.bgm.stop();
    setState(() {});

    dev.log('left time: ${seconds.value}');

    if (option.isCorrect) {
      FlameAudio.play('correct_ans.mp3');
      final questionPoint = QuestionsUtils.getQuestionPoint(
        gameType: widget.quest.id,
        level: widget.level.name.capitalize(),
        context: context,
        remainingTime: seconds.value.toDouble(),
        questionTime: questionTime.toDouble(),
        categoryWeight: widget.category.categoryWeight,
        difficultWeight: question.difficultyWeight.toDouble(),
      );

      if (question.isGolden && (seconds.value / questionTime) >= 0.7) {
        gameItemsProvider.increaseKeyAmount(GameKeyType.goldenKey);
      }

      _addPoints(
        questionPoints: questionPoint, //question.points,
        isGolden: question.isGolden,
      );
      answerStreak++;
      if (answerStreak == 5) {
        gameItemsProvider.increaseKeyAmount(GameKeyType.fiftyFifty);
        answerStreak = 0;
      }
      // gameProvider.increaseAnswerStreak(
      //     context: context, hasGolden: question.isGolden && seconds.value > 6);
    } else {
      FlameAudio.play('wong_ans.mp3');
      if ((gameItemsProvider.userKeys[GameKeyType.retakeKey]?.amount ?? 0) >
          0) {
        setState(() {
          showRetake = true;
        });
      }
      answerStreak = 0;
      loseStreaks++;
    }

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        showRetake = false;
        selectedAnswer = null;
        breakTime = false;
        setState(() {});
        if (retakeActivated) {
          retakeActivated = false;
          gameItemsProvider.reduceKeyAmount(GameKeyType.retakeKey);
          setState(() {});
          startQuestion(index);
        } else {
          if (option.isCorrect) {
            NewGameLocalDatabase.deleteQuestion(question.id);
          }
          moveToNextScreen(index: index, questionId: question.id);
        }
      });
    });
  }

  _addPoints({
    required int questionPoints,
    required bool isGolden,
  }) {
    correctAnswers++;

    dev.log('question points: ${questionPoints}');

    gamePoints = timesTwoActivated ? questionPoints * 2 : questionPoints;

    dev.log('game points: ${gamePoints}');

    if (timesTwoActivated) {
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

  _useGoldenChance(
      {required NewQuestionModel question,
      required int questionID,
      required double questionTime}) {
    for (var element in question.options) {
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

    dev.log('seconds time: ${seconds.value}');

    final questionPoint = QuestionsUtils.getQuestionPoint(
      gameType: widget.quest.id,
      level: widget.level.name.capitalize(),
      context: context,
      remainingTime: seconds.value.toDouble(),
      questionTime: questionTime.toDouble(),
      categoryWeight: widget.category.categoryWeight,
      difficultWeight: question.difficultyWeight.toDouble(),
    );
    if (question.isGolden && (seconds.value / questionTime) >= 0.7) {
      gameItemsProvider.increaseKeyAmount(GameKeyType.goldenKey);
    }
    _addPoints(
      questionPoints: questionPoint, //question.points,
      isGolden: false,
    );
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        breakTime = false;
      });
      moveToNextScreen(index: selectedIndex, questionId: questionID);
    });
  }

  _swapQuestion(String questionDifficulty) async {
    timer?.cancel();
    breakTime = true;
    setState(() {});
    final result = getSwapQuestion(difficulty: questionDifficulty);
    dev.log('got swap question: $result');
    if (result) {
      swapQuestion = true;
      breakTime = false;
      gameItemsProvider.reduceKeyAmount(GameKeyType.swapKey);

      setState(() {});

      final questionTime = QuestionsUtils.getQuestionsTime(
          complexityWeight: question.complexityWeight.toDouble(),
          difficultyWeight: question.difficultyWeight.toDouble(),
          context: context,
          gameType: widget.quest.id,
          level: widget.level.name.capitalize());

      startTimer(questionTime);
    } else {
      startTimer(seconds.value);
    }
  }

  moveToNextScreen({required int index, required int questionId}) {
    timer?.cancel();
    FlameAudio.bgm.stop();
    if (swapQuestion) {
      swapQuestion = false;
      setState(() {});
    }
    if (index < widget.questionList.length - 1) {
      pageController.nextPage(
          duration: const Duration(
            milliseconds: 400,
          ),
          curve: Curves.easeIn);
    } else {
      nextScreen(
          context,
          TrainingModeSubmitPage(
            categoryModel: widget.category,
            quest: widget.quest,
            pointsScored: totalPoints,
            correctAnswers: correctAnswers,
          ));
    }
  }

  bool getSwapQuestion({required String difficulty}) {
    List<NewQuestionModel> typeQuestionList =
        swapQuestionList[difficulty] ?? [];

    if (typeQuestionList.isNotEmpty) {
      question = typeQuestionList[0];
      typeQuestionList.removeAt(0);
      swapQuestionList[difficulty] = typeQuestionList;

      return true;
    } else {
      Fluttertoast.showToast(msg: 'Failed swap question,please try again');
      return false;
    }
  }

  goBack() async {
    await showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exit Game'),
          content: const Text('Are you sure you want to exit game?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                timer?.cancel();
                FlameAudio.bgm.stop();
                Navigator.of(context)
                  ..pop()
                  ..pop();
              },
              child: const Text(
                'Exit',
                style: TextStyle(color: AppColors.kGameRed),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();

    if (timer != null) {
      timer!.cancel();
    }
    seconds.dispose();
    fiftyfityList.dispose();
    super.dispose();
  }
}
