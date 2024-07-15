import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/providers/categories_provider.dart';
import 'package:savyminds/providers/game_items_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/categories/components/category_card.dart';
import 'package:savyminds/utils/cache/shared_preferences_helper.dart';
import 'package:savyminds/widgets/custom_text.dart';
import 'package:savyminds/widgets/page_template.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyTraining extends StatefulWidget {
  const DailyTraining({super.key});

  @override
  State<DailyTraining> createState() => _DailyTrainingState();
}

class _DailyTrainingState extends State<DailyTraining> {
  late CategoryProvider categoryProvider;
  bool isLoading = true;
  List<CategoryModel> categories = [];

  @override
  void initState() {
    categoryProvider = context.read<CategoryProvider>();
    getThreeCategoriesForDailyChallenge();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      pageTitle: "Daily Training",
      navActionItems: [
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
            SvgPicture.asset("assets/icons/flame.svg")
          ],
        )
      ],
      child: Padding(
        padding: EdgeInsets.all(d.pSH(16)),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  height: d.pSH(51),
                  width: d.pSH(59),
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/quest_icon_container.svg",
                        fit: BoxFit.fill,
                        colorFilter: const ColorFilter.mode(
                          AppColors.borderPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                      Align(
                        child: SvgPicture.asset(
                            "assets/icons/daily_training_icon.svg"),
                      )
                    ],
                  ),
                ),
                SizedBox(width: d.pSW(16)),
                const Expanded(
                    child: CustomText(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  label:
                      'Categories are selected at random based on your favourites or your frequently played games. You will need to play in  3 categories. ',
                ))
              ],
            ),
            SizedBox(height: d.pSH(32)),
            Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            //Categories
                            ...List.generate(categories.length, (index) {
                              return Container(
                                height: d.pSH(156.5),
                                width: d.pSW(160.2),
                                margin: EdgeInsets.only(bottom: d.pSH(8)),
                                child: CategoryCard(
                                  category: categories[index],
                                ),
                              );
                            }),
                            SizedBox(height: d.pSH(16)),
                          ],
                        ),
                      ))
          ],
        ),
      ),
    );
  }

  Future<List<CategoryModel>> getThreeCategoriesForDailyChallenge() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedDate = prefs.getString('dailyChallengeDate');
    final result = SharedPreferencesHelper.getStringList('dailyChallenges');

    List<CategoryModel> storedChallenges = [];
    if (result != null) {
      List<CategoryModel> categories = result.map((value) {
        return CategoryModel.fromJson(json.decode(value));
      }).toList();

      storedChallenges = categories;
    }

    final String today = DateTime.now().toIso8601String().substring(0, 10);

    if (storedDate == today && storedChallenges.isNotEmpty) {
      setState(() {
        isLoading = false;
      });
      categories = storedChallenges;
      return storedChallenges;
    }

    final selectedCategories = categoryProvider.getThreeRandomCategories();

    await prefs.setString('dailyChallengeDate', today);
    await SharedPreferencesHelper.setObjectList(
        'dailyChallenges',
        List.generate(selectedCategories.length,
            (index) => selectedCategories[index].toMap()));

    setState(() {
      isLoading = false;
    });

    categories = selectedCategories;

    return selectedCategories;
  }
}
