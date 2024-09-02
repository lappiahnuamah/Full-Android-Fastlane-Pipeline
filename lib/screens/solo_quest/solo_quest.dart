import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/data/shared_preference_values.dart';
import 'package:savyminds/functions/solo_quest/solo_quest_functions.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/providers/game_items_provider.dart';
import 'package:savyminds/providers/solo_quest_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_hero_tags.dart';
import 'package:savyminds/screens/solo_quest/challlenge_of_the_day/challenge_of_day.dart';
import 'package:savyminds/screens/solo_quest/components/quest_card.dart';
import 'package:savyminds/screens/solo_quest/daily_training/daily_training.dart';
import 'package:savyminds/screens/solo_quest/survival_quest/survival_quest.dart';
import 'package:savyminds/screens/solo_quest/time_rush/time_rush.dart';
import 'package:savyminds/screens/solo_quest/training_mode/training_mode.dart';
import 'package:savyminds/utils/cache/shared_preferences_helper.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/custom_text.dart';

class SoloQuest extends StatefulWidget {
  const SoloQuest({Key? key}) : super(key: key);

  @override
  State<SoloQuest> createState() => SoloQuestState();
}

class SoloQuestState extends State<SoloQuest> with TickerProviderStateMixin {
  List<AnimationController> _controllers = [];
  List<Animation<double>> _animations = [];
  bool isLoading = false;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      getSoloQuests();
    });
    super.initState();
  }

  getAnimations(List<QuestModel> quests) {
    _controllers = quests.map((item) {
      return AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      );
    }).toList();

    _animations = _controllers.map((controller) {
      return CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      );
    }).toList();

    // startAnimations();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(d.pSH(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CustomText(
          label: 'Single Player',
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),
        SizedBox(height: d.pSH(16)),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      label: 'Daily',
                      fontWeight: FontWeight.w500,
                      color: AppColors.hintTextBlack,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Consumer<GameItemsProvider>(
                            builder: (context, itemProvider, child) {
                          return CustomText(
                            label: '${itemProvider.gameStreaks.streaks}',
                            fontWeight: FontWeight.w500,
                            color: AppColors.hintTextBlack,
                          );
                        }),
                        const SizedBox(width: 10),
                        Hero(
                            tag: AppHeroTags.streakIcon,
                            child: SvgPicture.asset("assets/icons/flame.svg"))
                      ],
                    )
                  ],
                ),
                SizedBox(height: d.pSH(16)),
                QuestCard(
                    iconHeroTag: AppHeroTags.dailyTrainingLogo,
                    onTap: () {
                      nextScreen(context, const DailyTraining());
                    },
                    quest: const QuestModel(
                        id: 1,
                        name: 'Daily Training',
                        subtitle: 'Exercise your brain one day at a time',
                        description: '',
                        icon: "assets/icons/daily_training_icon.svg",
                        isLocked: false,
                        mode: 'Single Player'),
                    isDailyTraining: true),
                SizedBox(height: d.pSH(16)),
                const CustomText(
                  label: 'All Solo Quests',
                  fontWeight: FontWeight.w500,
                  color: AppColors.hintTextBlack,
                ),
                SizedBox(height: d.pSH(16)),
                Consumer<SoloQuestProvider>(
                    builder: (context, soloQuestProvider, child) {
                  return isLoading
                      ?
                      //Loading states
                      const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.kPrimaryColor,
                          ),
                        )
                      : Column(children: [
                          ...List.generate(
                            soloQuestProvider.soloQuests.length,
                            (index) {
                              final quest = soloQuestProvider.soloQuests[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: d.pSW(15)),
                                child: _animations.isNotEmpty
                                    ? AnimatedBuilder(
                                        animation: _animations[index],
                                        builder: (context, child) {
                                          return FadeTransition(
                                              opacity: _animations[index],
                                              child: QuestCard(
                                                quest: quest,
                                                onTap: () {
                                                  if (quest.isLocked) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'This quest will be opened soon');
                                                    return;
                                                  }
                                                  checkNavigation(
                                                      quest, context);
                                                },
                                              ));
                                        })
                                    : QuestCard(
                                        quest: quest,
                                        onTap: () {
                                          if (quest.isLocked) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'This quest will be opened soon');
                                            return;
                                          }
                                          checkNavigation(quest, context);
                                        },
                                      ),
                              );
                            },
                          ),
                        ]);
                }),
              ],
            ),
          ),
        )
      ]),
    );
  }

  void checkNavigation(QuestModel quest, BuildContext context) {
    if (quest.name == 'Time Rush') {
      nextScreen(
          context,
          TimeRush(
            quest: quest,
          ));
    } else if (quest.name == 'Training Mode') {
      nextScreen(
          context,
          TrainingMode(
            quest: quest,
          ));
    } else if (quest.name == 'Survival Quest') {
      nextScreen(
          context,
          SurvivalQuest(
            quest: quest,
          ));
    } else if (quest.name == 'Challenge of the day') {
      nextScreen(
          context,
          ChallengeOfTheDay(
            quest: quest,
          ));
    }
  }

  Future<void> getSoloQuests() async {
    final soloQuestProvider = context.read<SoloQuestProvider>();
    setState(() {
      isLoading = true;
    });
    final result = SharedPreferencesHelper.getStringList(
        SharedPreferenceValues.soloQuests);
    if (result != null) {
      List<QuestModel> soloQuests = result.map((value) {
        return QuestModel.fromJson(json.decode(value));
      }).toList();
      soloQuestProvider.setSoloQuests(soloQuests);
      getAnimations(soloQuests);
    }
    await SoloQuestFunctions().getQuests(context: context);
    getAnimations(soloQuestProvider.soloQuests);
    setState(() {
      isLoading = false;
    });
  }

  void startAnimations() {
    log('start animation');
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 600), () {
        _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _animations.clear();
    _controllers.clear();
    super.dispose();
  }
}
