import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_fonts.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/screens/contest/contest_mode/create_contest.dart';
import 'package:savyminds/screens/game/game/components/game_text_feild.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/utils/validator.dart';
import 'package:savyminds/widgets/custom_text.dart';
import 'package:savyminds/widgets/page_template.dart';
import 'package:savyminds/widgets/quest_icon_desc_card.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

class JoinContest extends StatefulWidget {
  const JoinContest({super.key, required this.quest});
  final QuestModel quest;

  @override
  State<JoinContest> createState() => _JoinContestState();
}

class _JoinContestState extends State<JoinContest> {
  TextEditingController gameCode = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PageTemplate(
      pageTitle: 'Join Contest',
      child: Padding(
        padding: EdgeInsets.all(d.pSH(16)),
        child: Column(children: [
          QuestIconDescCard(
            quest: widget.quest,
            isContest: true,
            description:
                "Join a contest by entering the game code. You can also create a new game by clicking on ‘Create A New Game’.",
          ),
          SizedBox(height: d.pSH(40)),
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
                      text:
                          ' Game session codes are persistent and can be played over and over again.'),
                ]),
          ),
          SizedBox(height: d.pSH(30)),
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
                // nextScreen(
                //     context,
                //     StartContestMode(
                //       quest: widget.quest,
                //       category: const CategoryModel(
                //           id: 1,
                //           name: 'Happy',
                //           icon: '',
                //           isLocked: false,
                //           color: AppColors.kGameGreen,
                //           noOfQuestion: 200),
                //       level: levelList[2],
                //       gameName: 'Happy Game',
                //       isCreator: false,
                //     ));
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
              nextScreen(context, CreateContest(quest: widget.quest));
            },
            child: CustomText(
              label: 'Create A New Game',
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
