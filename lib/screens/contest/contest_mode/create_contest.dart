import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/models/level_model.dart';
import 'package:savyminds/models/solo_quest/quest_model.dart';
import 'package:savyminds/providers/categories_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_fonts.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/screens/categories/components/category_placeholder.dart';
import 'package:savyminds/screens/categories/components/level_card.dart';
import 'package:savyminds/screens/categories/select_categoiries.dart';
import 'package:savyminds/screens/contest/contest_mode/start_contest_mode.dart';
import 'package:savyminds/screens/game/game/components/game_text_feild.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/utils/validator.dart';
import 'package:savyminds/widgets/custom_text.dart';
import 'package:savyminds/widgets/page_template.dart';
import 'package:savyminds/widgets/quest_icon_desc_card.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

import '../../categories/components/category_card.dart';

class CreateContest extends StatefulWidget {
  const CreateContest({super.key, required this.quest});
  final QuestModel quest;

  @override
  State<CreateContest> createState() => _CreateContestState();
}

class _CreateContestState extends State<CreateContest> {
  TextEditingController gameName = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late CategoryProvider categoryProvider;
  CategoryModel? selectedCategory;
  LevelModel? selectedLevel;

  List<LevelModel> levelList = [
    LevelModel(
      name: 'Beginner',
      isLocked: false,
      progress: 0,
      active: true,
      id: 1,
      color: const Color(0xFF85DB98),
    ),
    LevelModel(
      name: 'Intermediate',
      isLocked: false,
      progress: 0,
      active: true,
      id: 2,
      color: const Color(0xFF85C6DB),
    ),
    LevelModel(
      name: 'Advanced',
      isLocked: false,
      progress: 0.0,
      active: true,
      id: 3,
      color: const Color(0xFFE8DD72),
    ),
    LevelModel(
      name: 'Expert',
      isLocked: true,
      progress: 0.0,
      active: false,
      id: 4,
      color: const Color(0xFF85C6DB),
    ),
    LevelModel(
      name: 'Elite',
      isLocked: true,
      progress: 0.0,
      active: false,
      id: 5,
      color: const Color(0xFF85C6DB),
    ),
  ];

  @override
  void initState() {
    categoryProvider = context.read<CategoryProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PageTemplate(
      pageTitle: widget.quest.name,
      child: Padding(
        padding: EdgeInsets.all(d.pSH(16)),
        child: SingleChildScrollView(
          child: Column(children: [
            QuestIconDescCard(
              quest: widget.quest,
              isContest: true,
              description:
                  "Setup a contest and share the code with your friends. This is a fresh session and a clean sheet. Let’s go!",
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
                            ' Be sure of the category you want to play as a group'),
                  ]),
            ),
            SizedBox(height: d.pSH(25)),
            selectedCategory != null
                ? SizedBox(
                    height: 159.6,
                    width: 187,
                    child: CategoryCard(
                      category: selectedCategory!,
                      hidePlay: true,
                    ),
                  )
                : Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: d.pSH(5)),
                        child: CategoryPlaceholder(
                          height: 159,
                          width: 187,
                          label: 'Click here to select a category ',
                          onTap: () async {
                            final result = await nextScreen(
                                context, const SelectCategory());
                            if (result is CategoryModel) {
                              setState(() {
                                selectedCategory = result;
                              });
                            }
                          },
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedCategory =
                                  categoryProvider.getRandomCategory();
                            });
                          },
                          child: SvgPicture.asset(
                            AppImages.randomIcon,
                          ),
                        ),
                      )
                    ],
                  ),
            SizedBox(height: d.pSH(30)),
            CustomText(
              label: 'Select you the level you want to play',
              fontSize: getFontSize(13, size),
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: d.pSH(15)),
            Wrap(
              runSpacing: d.pSH(10),
              spacing: d.pSW(15),
              alignment: WrapAlignment.center,
              children: [
                for (int i = 0; i < levelList.length; i++)
                  InkWell(
                    onTap: () {
                      for (var level in levelList) {
                        level.progress = 0;
                      }
                      setState(() {
                        levelList[i].progress = 1;
                        selectedLevel = levelList[i];
                      });
                    },
                    child: LevelCard(
                      level: levelList[i],
                    ),
                  )
              ],
            ),
            SizedBox(height: d.pSH(20)),
            SizedBox(height: d.pSH(30)),
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
              buttonText: 'SUBMIT',
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
