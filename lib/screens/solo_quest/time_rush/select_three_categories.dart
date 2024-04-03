import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/data/shared_preference_values.dart';
import 'package:savyminds/functions/categories/categories_functions.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/providers/categories_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/categories/components/category_card.dart';
import 'package:savyminds/screens/categories/components/category_placeholder.dart';
import 'package:savyminds/utils/cache/shared_preferences_helper.dart';
import 'package:savyminds/widgets/custom_search_feild.dart';
import 'package:savyminds/widgets/page_template.dart';
import 'package:savyminds/widgets/trasformed_button.dart';

class SelectedThreeCategories extends StatefulWidget {
  const SelectedThreeCategories({super.key});

  @override
  State<SelectedThreeCategories> createState() =>
      _SelectedThreeCategoriesState();
}

class _SelectedThreeCategoriesState extends State<SelectedThreeCategories> {
  late CategoryProvider categoryProvider;
  bool isLoading = false;
  final searchController = TextEditingController();
  ValueNotifier<String> searchValue = ValueNotifier<String>('');
  List<CategoryModel> selectedCategories = [];

  @override
  void initState() {
    categoryProvider = context.read<CategoryProvider>();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (categoryProvider.categories.isEmpty) {
        getCategories();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      pageTitle: 'Select Categories',
      child: Column(
        children: [
          SizedBox(height: d.pSH(10)),

          Row(
            children: [
              ...List.generate(
                3,
                (index) => selectedCategories.length > index
                    ? Expanded(
                        child: Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: AspectRatio(
                              aspectRatio: 1.08,
                              child: CategoryCard(
                                category: selectedCategories[index],
                                hidePlay: true,
                                fontSize: 12,
                                iconSize: d.pSH(26),
                                borderRadius: d.pSH(18),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: Center(
                          child: CategoryPlaceholder(
                            onTap: () {},
                          ),
                        ),
                      ),
              )
            ],
          ),
          SizedBox(height: d.pSH(10)),

          ///
          Expanded(
            child: Consumer<CategoryProvider>(
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

                  //Content
                  Padding(
                      padding: EdgeInsets.all(d.pSH(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Serach Feild
                          CustomSearchFeild(
                            controller: searchController,
                            hintText: 'Search Categories',
                            onChanged: (val) {
                              searchValue.value = val ?? '';
                              return val;
                            },
                          ),
                          SizedBox(height: d.pSH(16)),

                          //
                          Expanded(
                              child: ValueListenableBuilder(
                                  valueListenable: searchValue,
                                  builder: (context, search, child) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          if (categoryProvider
                                              .favoriteCategories.isNotEmpty)
                                            SizedBox(height: d.pSH(16)),
                                          GridView(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      crossAxisSpacing:
                                                          d.pSH(24),
                                                      mainAxisSpacing:
                                                          d.pSH(10),
                                                      childAspectRatio: 1.05),
                                              children: [
                                                ...List.generate(
                                                    categoryProvider.categories
                                                        .length, (index) {
                                                  final category =
                                                      categoryProvider
                                                          .categories[index];
                                                  return category.name
                                                          .toLowerCase()
                                                          .contains(search
                                                              .toLowerCase())
                                                      ? InkWell(
                                                          onTap: () {
                                                            if (selectedCategories
                                                                    .length >=
                                                                3) {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'You can only select 3 categories');
                                                            } else if ((selectedCategories
                                                                .contains(
                                                                    category))) {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'Category is already selected');
                                                            } else {
                                                              setState(() {
                                                                selectedCategories
                                                                    .add(
                                                                        category);
                                                              });
                                                            }
                                                          },
                                                          child: CategoryCard(
                                                              category:
                                                                  category,
                                                              index: index,
                                                              hidePlay: true),
                                                        )
                                                      : const SizedBox();
                                                }),
                                              ]),
                                        ],
                                      ),
                                    );
                                  }))
                        ],
                      ));
            }),
          ),

          //GOs
          SizedBox(height: d.pSH(8)),
          if (selectedCategories.length == 3)
            TransformedButton(
              onTap: () {
                Navigator.pop(context, selectedCategories);
              },
              buttonColor: AppColors.kGameGreen,
              buttonText: ' GO ',
              textColor: Colors.white,
              textWeight: FontWeight.bold,
              height: d.pSH(66),
            ),
          if (Platform.isIOS) SizedBox(height: d.pSH(25)),
        ],
      ),
    );
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

  @override
  void dispose() {
    searchValue.dispose();
    super.dispose();
  }
}
