import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/auth/app_user.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/models/level_model.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/providers/categories_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_fonts.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/screens/categories/components/level_card.dart';
import 'package:savyminds/screens/game/game/components/user_profile_list.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/availalble_keys_widget.dart';
import 'package:savyminds/widgets/custom_text.dart';
import 'package:savyminds/widgets/page_template.dart';
import 'package:savyminds/widgets/quest_icon_desc_card.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

import '../../categories/components/category_card.dart';

class StartContestMode extends StatefulWidget {
  const StartContestMode({
    super.key,
    required this.quest,
    required this.category,
    required this.level,
    required this.gameName,
    required this.isCreator,
  });
  final QuestModel quest;
  final CategoryModel category;
  final LevelModel level;
  final String gameName;
  final bool isCreator;

  @override
  State<StartContestMode> createState() => _StartContestModeState();
}

class _StartContestModeState extends State<StartContestMode> {
  TextEditingController gameName = TextEditingController();

  late CategoryProvider categoryProvider;
  CategoryModel? selectedCategory;

  @override
  void initState() {
    categoryProvider = context.read<CategoryProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PageTemplate(
      pageTitle: 'Start Game',
      child: Padding(
        padding: EdgeInsets.all(d.pSH(16)),
        child: SingleChildScrollView(
          child: Column(children: [
            QuestIconDescCard(
                quest: widget.quest,
                isContest: true,
                description:
                    "You are about to play in a contest. Questions will be selected for everyone simultaneously based on the category and level you are playing."),
            SizedBox(height: d.pSH(20)),
            SizedBox(
              height: d.pSH(139),
              width: d.pSH(160),
              child: CategoryCard(
                category: widget.category,
                hidePlay: true,
              ),
            ),
            SizedBox(height: d.pSH(10)),
            LevelCard(
              level: widget.level,
              totalPoints: 50,
            ),
            SizedBox(height: d.pSH(25)),
            CustomText(
              label: widget.gameName,
              fontSize: getFontSize(36, size),
              fontWeight: FontWeight.w400,
              fontFamily: AppFonts.caveat,
            ),
            CustomText(
              label: 'SJKIW25',
              fontSize: getFontSize(40, size),
              fontWeight: FontWeight.w400,
              fontFamily: AppFonts.caveat,
              color: AppColors.borderAccent,
            ),
            SizedBox(height: d.pSH(20)),

            if (widget.isCreator)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppImages.copySvg),
                  SizedBox(width: d.pSW(30)),
                  SvgPicture.asset(AppImages.qrCodeSvg),
                ],
              ),
            if (widget.isCreator) SizedBox(height: d.pSH(8)),
            if (widget.isCreator)
              const CustomText(
                  label: 'Copy and share code or display QR Code.'),
            if (widget.isCreator) SizedBox(height: d.pSH(25)),
            UserProfileList(users: [
              AppUser(),
              AppUser()
            ] //(game.gameSession?.players ?? []),
                ),
            SizedBox(
              height: d.pSH(10),
            ),
            twinee(
                subTitle: 'Members Joined',
                title: '2'), //${(game.gameSession?.players ?? []).length}'),

            SizedBox(height: d.pSH(30)),
            const AvailalableKeysWidget(
              showShop: false,
            ),
            SizedBox(height: d.pSH(30)),

            widget.isCreator
                ? TransformedButton(
                    onTap: () {},
                    buttonColor: AppColors.kGameGreen,
                    buttonText: 'START',
                    textColor: Colors.white,
                    textWeight: FontWeight.bold,
                    height: d.pSH(66),
                  )
                : Padding(
                    padding: EdgeInsets.only(top: d.pSH(10)),
                    child: const CustomText(
                        label: 'Waiting for the game to start...'),
                  ),
            SizedBox(height: d.pSH(40)),
          ]),
        ),
      ),
    );
  }

  Widget twinee({required String title, required String subTitle}) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: getFontSize(32, size),
            fontFamily: AppFonts.caveat,
            color: AppColors.kPrimaryColor,
          ),
        ),
        SizedBox(height: d.pSH(3)),
        Text(subTitle,
            style: TextStyle(
              fontSize: getFontSize(15, size),
            )),
      ],
    );
  }
}
