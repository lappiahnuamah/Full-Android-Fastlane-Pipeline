import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/models/level_model.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/providers/categories_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_fonts.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/screens/contest/contest_mode/start_contest_mode.dart';
import 'package:savyminds/screens/game/game/components/game_text_feild.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/utils/validator.dart';
import 'package:savyminds/widgets/page_template.dart';
import 'package:savyminds/widgets/quest_icon_desc_card.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

class CreateBattleTeam extends StatefulWidget {
  const CreateBattleTeam({super.key, required this.quest});
  final QuestModel quest;

  @override
  State<CreateBattleTeam> createState() => _CreateBattleTeamState();
}

class _CreateBattleTeamState extends State<CreateBattleTeam> {
  TextEditingController gameName = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late CategoryProvider categoryProvider;
  CategoryModel? selectedCategory;
  LevelModel? selectedLevel;

  List levelList = [];

  String teamImage = '';
  @override
  void initState() {
    categoryProvider = context.read<CategoryProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PageTemplate(
      pageTitle: 'Create Team',
      child: Padding(
        padding: EdgeInsets.all(d.pSH(16)),
        child: SingleChildScrollView(
          child: Column(children: [
            QuestIconDescCard(
                quest: widget.quest,
                isContest: true,
                description:
                    "Create a team and share for two others to join. Other people can join with the team code. You need exactly 3 people in a team."),
            SizedBox(height: d.pSH(30)),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: TextStyle(
                    color: AppColors.textBlack,
                    fontSize: getFontSize(24, size),
                    fontFamily: AppFonts.caveat,
                    height: 1.7,
                    fontStyle: FontStyle.italic,
                  ),
                  children: const [
                    TextSpan(
                        text: 'Hint:',
                        style: TextStyle(color: AppColors.kGameDarkRed)),
                    TextSpan(
                        text: ' Team name must not be more than 15 characters'),
                  ]),
            ),
            SizedBox(height: d.pSH(30)),
            Container(
              height: d.pSH(160),
              width: d.pSH(160),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              padding: EdgeInsets.all(d.pSH(0.5)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.textBlack, width: 2),
                  shape: BoxShape.circle,
                  image: teamImage.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(teamImage), fit: BoxFit.cover)
                      : null),
              child: teamImage.isEmpty
                  ? Image.asset(AppImages.groupPicBackground, fit: BoxFit.cover)
                  : null,
            ),
            SizedBox(height: d.pSH(50)),
            Form(
              key: _formKey,
              child: GameTextFeild(
                controller: gameName,
                labelText: '',
                hintText: "Enter Game Name",
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.person_outline_rounded,
                onChanged: (value) {
                  return;
                },
                //(Validation)//
                validator: (value) => AuthValidate().validateNotEmpty(value),
                onSaved: (value) {
                  gameName.text = value ?? '';
                },
              ),
            ),
            SizedBox(height: d.pSH(40)),
            TransformedButton(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState?.save();
                  if (selectedCategory == null || selectedLevel == null) return;
                  nextScreen(
                      context,
                      StartContestMode(
                        quest: widget.quest,
                        category: selectedCategory!,
                        level: selectedLevel!,
                        gameName: gameName.text,
                        isCreator: true,
                      ));
                }
              },
              buttonColor: AppColors.kGameGreen,
              buttonText: 'CREATE TEAM',
              textColor: Colors.white,
              textWeight: FontWeight.bold,
              height: d.pSH(66),
            ),
            SizedBox(height: d.pSH(40)),
            SizedBox(height: d.pSH(40)),
          ]),
        ),
      ),
    );
  }
}
