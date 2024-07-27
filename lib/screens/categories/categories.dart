import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/data/shared_preference_values.dart';
import 'package:savyminds/functions/categories/categories_functions.dart';
import 'package:savyminds/functions/games/game_matric_function.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/providers/categories_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/categories/components/category_card.dart';
import 'package:savyminds/utils/cache/shared_preferences_helper.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/custom_search_feild.dart';
import 'package:savyminds/widgets/custom_text.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  bool isLoading = false;
  String searchText = "";
  final searchController = TextEditingController();
  ValueNotifier<List<CategoryModel>> searchValue =
      ValueNotifier<List<CategoryModel>>([]);

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      getCategories();
      CategoryFunctions().getFavoriteCategories(context: context);
      GameMatricFunction().getGameMatrics(context: context);
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
              Padding(
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

                      //Serach Feild
                      CustomSearchFeild(
                        controller: searchController,
                        hintText: 'Search Categories',
                        onChanged: (val) {
                          searchText = val ?? '';
                          searchForCategory();
                          return val;
                        },
                      ),
                      SizedBox(height: d.pSH(16)),

                      //
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Favorite Categories
                            if (categoryProvider
                                    .favoriteCategories.isNotEmpty &&
                                searchText.isEmpty)
                              const CustomText(
                                label: 'Favorites',
                                fontWeight: FontWeight.w500,
                                color: AppColors.hintTextBlack,
                              ),
                            if (categoryProvider
                                    .favoriteCategories.isNotEmpty &&
                                searchText.isEmpty)
                              SizedBox(height: d.pSH(16)),

                            if (searchText.isEmpty)
                              GridView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: d.pSH(24),
                                          mainAxisSpacing: d.pSH(10),
                                          childAspectRatio: 1.05),
                                  children: [
                                    ...List.generate(
                                        categoryProvider.favoriteCategories
                                            .length, (index) {
                                      final category = categoryProvider
                                          .favoriteCategories[index];
                                      return Hero(
                                        tag: "Category ${category.id}",
                                        child: CategoryCard(
                                          category: category,
                                          index: index,
                                        ),
                                      );
                                    }),
                                  ]),
                            if (categoryProvider
                                    .favoriteCategories.isNotEmpty &&
                                searchText.isEmpty)
                              SizedBox(height: d.pSH(16)),

                            /// All Categories
                            if (categoryProvider
                                    .favoriteCategories.isNotEmpty &&
                                searchText.isEmpty)
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
                                        crossAxisSpacing: d.pSH(24),
                                        mainAxisSpacing: d.pSH(10),
                                        childAspectRatio: 1.05),
                                children: [
                                  ...List.generate(
                                      searchText.isEmpty
                                          ? categoryProvider.categories.length
                                          : searchValue.value.length, (index) {
                                    final category = searchText.isEmpty
                                        ? categoryProvider.categories[index]
                                        : searchValue.value[index];
                                    return CategoryCard(
                                      category: category,
                                      index: index,
                                    );
                                  }),
                                ]),
                          ],
                        ),
                      ))
                    ],
                  ));
    });
  }

  Future<void> getCategories() async {
    final categoryProvider = context.read<CategoryProvider>();
    setState(() {
      isLoading = true;
    });
    final result = SharedPreferencesHelper.getStringList(
        SharedPreferenceValues.allCategories);
    if (result != null) {
      List<CategoryModel> categories = result.map((value) {
        return CategoryModel.fromJson(json.decode(value));
      }).toList();
      categoryProvider.setCategories(categories);
    }
    await CategoryFunctions().getCategories(context: context);
    setState(() {
      isLoading = false;
    });
  }

  searchForCategory() {
    final categoryProvider = context.read<CategoryProvider>();
    searchValue.value = [];
    List<CategoryModel> searchCategories = [];
    for (var category in categoryProvider.categories) {
      if (category.name.toLowerCase().contains(searchText.toLowerCase())) {
        searchCategories.add(category);
      }
    }

    searchValue.value = searchCategories;
    setState(() {});
  }

  @override
  void dispose() {
    searchValue.dispose();
    super.dispose();
  }
}
