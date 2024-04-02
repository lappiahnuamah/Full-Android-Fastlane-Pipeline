import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/models/level_model.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/categories/components/category_card.dart';
import 'package:savyminds/screens/categories/components/level_card.dart';
import 'package:savyminds/screens/profile/components/key_card.dart';
import 'package:savyminds/screens/profile/profile.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/page_template.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

class CategoryDetailsPage extends StatefulWidget {
  const CategoryDetailsPage({super.key, required this.category});
  final CategoryModel category;

  @override
  State<CategoryDetailsPage> createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final bright = Theme.of(context).brightness;
    Size size = MediaQuery.of(context).size;

    return PageTemplate(
      pageTitle: 'Start Game',
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: d.pSH(16), horizontal: d.pSW(30)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                  height: d.pSH(150.5),
                  width: d.pSH(160.2),
                  child: Hero(
                    tag: "Category ${widget.category.id}",
                    child: CategoryCard(
                      category: widget.category,
                      hidePlay: true,
                    ),
                  )),
              SizedBox(
                height: d.pSH(40),
              ),
              Wrap(
                runSpacing: d.pSH(10),
                spacing: d.pSW(15),
                alignment: WrapAlignment.center,
                children: [
                  for (int i = 0; i < levelList.length; i++)
                    LevelCard(
                      level: levelList[i],
                    )
                ],
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: TextStyle(
                        color: bright == Brightness.dark
                            ? AppColors.kGameDarkText2Color
                            : AppColors.kGameText2Color,
                        fontSize: getFontSize(20, size),
                        fontFamily: 'Architects_Daughter',
                        height: 1.7),
                    children: [
                      const TextSpan(
                        text:
                            'These questions have been selected at random from a pool of questions.\n',
                      ),
                      TextSpan(
                        style: TextStyle(
                          color: bright == Brightness.dark
                              ? AppColors.kGameDarkRed
                              : AppColors.kGameRed,
                        ),
                        text: 'Once started you cannot pause the game.\n',
                      ),
                      const TextSpan(
                        text: 'Take a deep breath and let us go!',
                      ),
                    ]),
              ),
              SizedBox(
                height: d.pSH(40),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...List.generate(4, (index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: d.pSW(8)),
                      child: KeyCard(
                        gameKey: gameKeyList[index],
                        height: 35,
                      ),
                    );
                  }),
                ],
              ),
              SizedBox(
                height: d.pSH(30),
              ),
              TransformedButton(
                onTap: () {},
                buttonColor: AppColors.kGameGreen,
                buttonText: ' START ',
                textColor: Colors.white,
                textWeight: FontWeight.bold,
                height: d.pSH(66),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List levelList = [
  LevelModel(
    name: 'Beginner',
    isLocked: false,
    progress: 1.0,
    active: true,
    id: 1,
    color: const Color(0xFF85DB98),
  ),
  LevelModel(
    name: 'Intermediate',
    isLocked: false,
    progress: 0.4,
    active: true,
    id: 2,
    color: const Color(0xFF85C6DB),
  ),
  LevelModel(
      name: 'Advanced',
      isLocked: false,
      progress: 0.0,
      active: false,
      id: 3,
      color: const Color(0xFFE8DD72)),
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
