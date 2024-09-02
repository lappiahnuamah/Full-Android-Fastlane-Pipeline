import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/providers/categories_provider.dart';
import 'package:savyminds/providers/game_items_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_hero_tags.dart';
import 'package:savyminds/screens/categories/components/category_card.dart';
import 'package:savyminds/utils/cache/shared_preferences_helper.dart';
import 'package:savyminds/utils/extensions/extensions.dart';
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
  late GameItemsProvider gameItemsProvider;
  bool _isExpanded = false;

  @override
  void initState() {
    categoryProvider = context.read<CategoryProvider>();
    gameItemsProvider = context.read<GameItemsProvider>();
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
            Hero(
              tag: AppHeroTags.streakIcon,
              child: SvgPicture.asset(
                "assets/icons/flame.svg",
                height: d.isTablet ? d.pSW(25) : null,
              ),
            )
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
                  height: d.isTablet ? d.pSW(71) : d.pSW(51),
                  width: d.isTablet ? d.pSW(79) : d.pSW(59),
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/quest_icon_container.svg",
                        fit: BoxFit.fill,
                        height: d.isTablet ? d.pSW(71) : d.pSW(51),
                        width: d.isTablet ? d.pSW(79) : d.pSW(59),
                        colorFilter: const ColorFilter.mode(
                          AppColors.borderPrimary,
                          BlendMode.srcIn,
                        ),
                      ),
                      Align(
                        child: Hero(
                          tag: AppHeroTags.dailyTrainingLogo,
                          child: SvgPicture.asset(
                            "assets/icons/daily_training_icon.svg",
                            height: d.isTablet ? d.pSW(40) : null,
                          ),
                        ),
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
                      'Categories are selected at random based on your favorites or your frequently played games. You will need to play in 3 categories. ',
                ))
              ],
            ),
            SizedBox(height: d.pSH(32)),
            Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Consumer<GameItemsProvider>(
                        builder: (context, itemProvider, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: itemProvider.dailyTrainingCategories.entries
                              .map((e) {
                            int index = itemProvider
                                .dailyTrainingCategories.keys
                                .toList()
                                .indexOf(e.key);
                            return AnimatedPositioned(
                                duration: Duration(seconds: 1),
                                curve: Curves.easeInOut,
                                top: _isExpanded
                                    ? index * d.pSW(d.isTablet ? 173 : 156)
                                    : _isExpanded
                                        ? index == 0
                                            ? 0
                                            : d.pSW(20)
                                        : d.pSW(176),
                                child: Container(
                                  height:
                                      d.isTablet ? d.pSW(173) : d.pSH(156.5),
                                  width: d.isTablet ? d.pSW(230) : d.pSW(160.2),
                                  margin: EdgeInsets.only(bottom: d.pSW(8)),
                                  child: CategoryCard(
                                    category: e.value['category'],
                                    hidePlay: e.value['isPlayed'],
                                    greyedOut: e.value['isPlayed'],
                                    isDailyTraining: true,
                                  ),
                                ));
                          }).toList(),
                        );
                      }))
          ],
        ),
      ),
    );
  }

  Future<List<CategoryModel>> getThreeCategoriesForDailyChallenge() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedDate = prefs.getString('dailyChallengeDate');
    final result = SharedPreferencesHelper.getStringList('dailyChallenges');
    final instanceProviderData = prefs.getString('dailyChallengesInstance');

    log('providerData 1: ${prefs.getString('dailyChallengesInstance')}');
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

      gameItemsProvider.setDailyTrainingCategories(storedChallenges);
      log('providerData 2: $instanceProviderData');

      if (instanceProviderData != null && instanceProviderData != 'null') {
        log('providerData 3: $instanceProviderData');
        final newProviderData = instanceProviderData.stringToMap();
        gameItemsProvider.setDailyTrainingPlayInstanceFromCache(
            categories: newProviderData);
      }

      ///Expand animation
      Future.delayed(const Duration(milliseconds: 700), () {
        setState(() {
          _isExpanded = true;
        });
      });
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

    gameItemsProvider.setDailyTrainingCategories(selectedCategories);

    ///Expand animation
    Future.delayed(const Duration(milliseconds: 700), () {
      setState(() {
        _isExpanded = true;
      });
    });

    return selectedCategories;
  }
}
