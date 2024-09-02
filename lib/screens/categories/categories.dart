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
import 'package:savyminds/widgets/custom_search_feild.dart';
import 'package:savyminds/widgets/custom_text.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> with TickerProviderStateMixin {
  List<AnimationController> _controllers = [];
  List<Animation<double>> _animations = [];
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

  getAnimations(List<CategoryModel> categories) {
    _controllers = categories.map((item) {
      return AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      );
    }).toList();

    _animations = _controllers.map((controller) {
      return CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      );
    }).toList();

    _startAnimations();
  }

  @override
  Widget build(BuildContext context) {
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
                  padding: EdgeInsets.symmetric(
                      horizontal: d.pSW(16), vertical: d.pSH(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        label: 'Categories',
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
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
                                          crossAxisSpacing: d.pSW(24),
                                          mainAxisSpacing: d.pSW(10),
                                          childAspectRatio: d.isTablet
                                              ? d.pSH(1)
                                              : d.pSW(1.05)),
                                  children: [
                                    ...List.generate(
                                        categoryProvider.favoriteCategories
                                            .length, (index) {
                                      final category = categoryProvider
                                          .favoriteCategories[index];
                                      return CategoryCard(
                                        category: category,
                                        index: index,
                                        isFavCategory: true,
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
                                        crossAxisSpacing: d.pSW(24),
                                        mainAxisSpacing: d.pSW(10),
                                        childAspectRatio: d.isTablet
                                            ? d.pSH(1)
                                            : d.pSW(1.05)),
                                children: [
                                  ...List.generate(
                                      searchText.isEmpty
                                          ? categoryProvider.categories.length
                                          : searchValue.value.length, (index) {
                                    final category = searchText.isEmpty
                                        ? categoryProvider.categories[index]
                                        : searchValue.value[index];
                                    return _buildItem(
                                        categoryModel: category,
                                        context: context,
                                        index: index);
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
      getAnimations(categories);

      await CategoryFunctions().getCategories(context: context);
    } else {
      await CategoryFunctions().getCategories(context: context);
      getAnimations(categoryProvider.categories);
    }

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
    getAnimations(searchCategories);
    setState(() {});
  }

  Widget _buildItem(
      {required BuildContext context,
      required CategoryModel categoryModel,
      required int index}) {
    return _animations.isNotEmpty
        ? AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return FadeTransition(
                opacity: _animations[index],
                child: CategoryCard(category: categoryModel, index: index),
              );
            })
        : CategoryCard(category: categoryModel, index: index);
  }

  void _startAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 600), () {
        _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    searchValue.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    _animations.clear();
    _controllers.clear();
    super.dispose();
  }
}
