import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/screens/categories/category_details_page.dart';
import 'package:savyminds/screens/contest/battle_mode/compoents/battle_team_card.dart';
import 'package:savyminds/screens/contest/battle_mode/create_battle_team.dart';
import 'package:savyminds/screens/contest/contest_mode/start_contest_mode.dart';
import 'package:savyminds/screens/game/game/components/game_text_feild.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/utils/validator.dart';
import 'package:savyminds/widgets/custom_text.dart';
import 'package:savyminds/widgets/page_template.dart';
import 'package:savyminds/widgets/quest_icon_desc_card.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

class JoinBattleTeam extends StatefulWidget {
  const JoinBattleTeam({super.key, required this.quest});
  final QuestModel quest;

  @override
  State<JoinBattleTeam> createState() => _JoinBattleTeamState();
}

class _JoinBattleTeamState extends State<JoinBattleTeam> {
  TextEditingController gameCode = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PageTemplate(
      pageTitle: 'Team',
      child: Padding(
        padding: EdgeInsets.all(d.pSH(16)),
        child: Column(children: [
          QuestIconDescCard(
            quest: widget.quest,
            isContest: true,
            description:
                "Select any of your teams you want to play with. OR submit a team code to join the team. You can also create a new team.",
          ),
          SizedBox(height: d.pSH(40)),
          Wrap(
            runSpacing: d.pSH(10),
            spacing: d.pSW(15),
            alignment: WrapAlignment.spaceBetween,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ...List.generate(
                8,
                (index) => BattleTeamCard(
                  teamName: index == 3
                      ? "Great team here and there  ooooo"
                      : 'Terateck',
                  teamImage: '',
                ),
              ),
            ],
          ),
          SizedBox(height: d.pSH(40)),
          const CustomText(label: 'Paste or Scan Code to Join Team'),
          SizedBox(height: d.pSH(15)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppImages.clipboardSvg),
              SizedBox(width: d.pSW(20)),
              SvgPicture.asset(AppImages.qrCreateSvg),
            ],
          ),
          SizedBox(height: d.pSH(30)),
          Form(
            key: _formKey,
            child: GameTextFeild(
              controller: gameCode,
              labelText: '',
              hintText: "Eg. X3IFN2",
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.person_outline_rounded,
              onChanged: (value) {
                return;
              },
              //(Validation)//
              validator: (value) => AuthValidate().validateNotEmpty(value),
              onSaved: (value) {
                gameCode.text = value ?? '';
              },
            ),
          ),
          SizedBox(height: d.pSH(40)),
          TransformedButton(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save();
                nextScreen(
                    context,
                    StartContestMode(
                      quest: widget.quest,
                      category: const CategoryModel(
                          id: 1,
                          name: 'Happy',
                          icon: '',
                          isLocked: false,
                          color: AppColors.kGameGreen,
                          noOfQuestion: 200),
                      level: levelList[2],
                      gameName: 'Happy Game',
                      isCreator: false,
                    ));
              }
            },
            buttonColor: AppColors.kGameGreen,
            buttonText: 'SUBMIT',
            textColor: Colors.white,
            textWeight: FontWeight.bold,
            height: d.pSH(66),
          ),
          SizedBox(height: d.pSH(40)),
          Flexible(child: Container()),
          InkWell(
            onTap: () {
              nextScreen(context, CreateBattleTeam(quest: widget.quest));
            },
            child: CustomText(
              label: 'Create A Team',
              fontSize: getFontSize(20, size),
              fontWeight: FontWeight.w600,
              color: AppColors.kPrimaryColor,
            ),
          ),
          SizedBox(height: d.pSH(20)),
        ]),
      ),
    );
  }
}
