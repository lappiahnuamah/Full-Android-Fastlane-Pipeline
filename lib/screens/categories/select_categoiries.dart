import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/data/shared_preference_values.dart';
import 'package:savyminds/functions/categories/categories_functions.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/providers/categories_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/categories/components/category_card.dart';
import 'package:savyminds/utils/cache/shared_preferences_helper.dart';
import 'package:savyminds/widgets/custom_search_feild.dart';
import 'package:savyminds/widgets/page_template.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({super.key});

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  late CategoryProvider categoryProvider;
  bool isLoading = false;
  final searchController = TextEditingController();
  ValueNotifier<String> searchValue = ValueNotifier<String>('');

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
                                                crossAxisSpacing: d.pSH(24),
                                                mainAxisSpacing: d.pSH(10),
                                                childAspectRatio: d.pSW(1.05)),
                                        children: [
                                          ...List.generate(
                                              categoryProvider
                                                  .categories.length, (index) {
                                            final category = categoryProvider
                                                .categories[index];
                                            return category.name
                                                    .toLowerCase()
                                                    .contains(
                                                        search.toLowerCase())
                                                ? InkWell(
                                                    onTap: () {
                                                      Navigator.pop(
                                                          context, category);
                                                    },
                                                    child: CategoryCard(
                                                        category: category,
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
