import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/categories/categories_functions.dart';
import 'package:savyminds/providers/categories_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/categories/components/category_card.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/custom_text.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  bool isLoading = false;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      getCategories();
      //  CategoryFunctions().getFavoriteCategories(context: context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<CategoryProvider>(
        builder: (context, categoryProvider, child) {
      return isLoading
          ?
          //Loading states
          const Center(
              child: CircularProgressIndicator(
                color: AppColors.kPrimaryColor,
              ),
            )
          :

          //Empty states
          (categoryProvider.favoriteCategories.isEmpty) &&
                  (categoryProvider.categories.isEmpty)
              ? Center(
                  child: InkWell(
                    onTap: () {
                      getCategories();
                    },
                    child: const CustomText(
                      label: 'Failed to load categories!\nTap to Retry',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              :

              //Content
              SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.all(d.pSH(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            label: 'Categories',
                            fontWeight: FontWeight.w700,
                            fontSize: getFontSize(24, size),
                          ),
                          SizedBox(height: d.pSH(16)),

                          //Favorite Categories
                          if (categoryProvider.favoriteCategories.isNotEmpty)
                            const CustomText(
                              label: 'Favorites',
                              fontWeight: FontWeight.w500,
                              color: AppColors.hintTextBlack,
                            ),
                          if (categoryProvider.favoriteCategories.isNotEmpty)
                            SizedBox(height: d.pSH(16)),
                          GridView(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: d.pSW(30),
                                mainAxisSpacing: d.pSH(16),
                              ),
                              children: [
                                ...List.generate(
                                    categoryProvider.favoriteCategories.length,
                                    (index) {
                                  final category = categoryProvider
                                      .favoriteCategories[index];
                                  return CategoryCard(
                                    category: category,
                                    index: index,
                                  );
                                }),
                              ]),
                          SizedBox(height: d.pSH(16)),

                          /// All Categories
                          if (categoryProvider.favoriteCategories.isNotEmpty)
                            const CustomText(
                              label: 'All Categories',
                              fontWeight: FontWeight.w500,
                              color: AppColors.hintTextBlack,
                            ),
                          if (categoryProvider.favoriteCategories.isNotEmpty)
                            SizedBox(height: d.pSH(16)),
                          GridView(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: d.pSW(30),
                                mainAxisSpacing: d.pSH(16),
                              ),
                              children: [
                                ...List.generate(
                                    categoryProvider.categories.length,
                                    (index) {
                                  final category =
                                      categoryProvider.categories[index];
                                  return CategoryCard(
                                    category: category,
                                    index: index,
                                  );
                                }),
                              ]),
                        ],
                      )));
    });
  }

  Future<void> getCategories() async {
    setState(() {
      isLoading = true;
    });
    await CategoryFunctions().getCategories(context: context);
    setState(() {
      isLoading = false;
    });
  }
}
