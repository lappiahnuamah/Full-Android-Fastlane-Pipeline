import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/data/shared_preference_values.dart';
import 'package:savyminds/functions/contests/contests_functions.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/providers/contest_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/contest/battle_mode/join_battle_team.dart';
import 'package:savyminds/screens/contest/contest_mode/join_contest.dart';
import 'package:savyminds/screens/solo_quest/components/quest_card.dart';
import 'package:savyminds/utils/cache/shared_preferences_helper.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/custom_text.dart';

class Contest extends StatefulWidget {
  const Contest({super.key});

  @override
  State<Contest> createState() => _ContestState();
}

class _ContestState extends State<Contest> {
  bool isLoading = false;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      getContests();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(d.pSH(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CustomText(
          label: 'Multi Player',
          fontWeight: FontWeight.w700,
          fontSize: getFontSize(24, size),
        ),
        SizedBox(height: d.pSH(16)),
        const CustomText(
          label: 'All Contests',
          fontWeight: FontWeight.w500,
          color: AppColors.hintTextBlack,
        ),
        SizedBox(height: d.pSH(16)),
        Expanded(
          child: Consumer<ContestProvider>(
              builder: (context, contestProvider, child) {
            return isLoading
                ?
                //Loading states
                const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.kPrimaryColor,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        ...List.generate(contestProvider.contests.length,
                            (index) {
                          final quest = contestProvider.contests[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: d.pSH(15)),
                            child: QuestCard(
                              isMultiCard: true,
                              quest: contestProvider.contests[index],
                              onTap: () {
                                if (quest.isLocked) {
                                  Fluttertoast.showToast(
                                      msg: 'This contest is locked');
                                } else {
                                  if (quest.name == "Contest Mode") {
                                    nextScreen(
                                        context, JoinContest(quest: quest));
                                  } else if (quest.name == "Team Battle") {
                                    nextScreen(
                                        context, JoinBattleTeam(quest: quest));
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            'This contest is not available yet');
                                  }
                                }
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  );
          }),
        )
      ]),
    );
  }

  Future<void> getContests() async {
    final contestProvider = context.read<ContestProvider>();
    setState(() {
      isLoading = true;
    });
    final result =
        SharedPreferencesHelper.getStringList(SharedPreferenceValues.contests);
    if (result != null) {
      List<QuestModel> soloQuests = result.map((value) {
        return QuestModel.fromJson(json.decode(value));
      }).toList();
      contestProvider.setContests(soloQuests);
    }
    await ContestFunctions().getQuests(context: context);
    setState(() {
      isLoading = false;
    });
  }
}
