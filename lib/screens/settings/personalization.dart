import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/functions/categories/categories_functions.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/providers/categories_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/settings/components/interest_badge.dart';
import 'package:savyminds/widgets/custom_text.dart';
import 'package:savyminds/widgets/custom_textfeild_with_label.dart';
import 'package:savyminds/widgets/page_template.dart';
import '../../../utils/func_new.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/load_indicator.dart';

class Personalization extends StatefulWidget {
  const Personalization({
    Key? key,
  }) : super(key: key);

  @override
  State<Personalization> createState() => _PersonalizationState();
}

class _PersonalizationState extends State<Personalization> {
  late CategoryProvider categoryProvider;
  List<CategoryModel> interests = [];
  List<CategoryModel> selectedCategories = [];

  bool categoriesReady = true;

  TextEditingController searchController = TextEditingController();

  Future getFavoriteCategories() async {}

  @override
  void initState() {
    categoryProvider = context.read<CategoryProvider>();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      getFavoriteFromApi();
      selectedCategories = categoryProvider.favoriteCategories;
      setState(() {});
    });

    super.initState();
  }

  bool savingCategories = false;

  getFavoriteFromApi() async {
    selectedCategories =
        await CategoryFunctions().getFavoriteCategories(context: context) ?? [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      PageTemplate(
        pageTitle: 'Personalize',
        child: Padding(
          padding: EdgeInsets.only(
              top: d.pSH(15), left: d.pSW(15), right: d.pSW(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        label: 'Select Favorite Categories',
                        fontWeight: FontWeight.w500,
                        fontSize: d.pSH(15),
                      ),
                      SizedBox(height: d.pSH(20)),
                      CustomTextFieldWithLabel(
                        controller: searchController,
                        hintText: 'Age Group',
                        noPrefix: true,
                        enabled: false,
                        suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
                        onTap: () {},
                      ),
                      SizedBox(height: d.pSH(40)),
                      CustomText(
                        label: 'Select Favorite Categories',
                        fontWeight: FontWeight.w500,
                        fontSize: d.pSH(15),
                      ),
                      SizedBox(height: d.pSH(16)),
                      CustomTextFieldWithLabel(
                        controller: searchController,
                        hintText: 'Search Categories',
                        noPrefix: true,
                      ),
                      if (selectedCategories.isNotEmpty)
                        SizedBox(height: d.pSH(16)),
                      if (selectedCategories.isNotEmpty)
                        Padding(
                            padding: EdgeInsets.only(top: d.pSH(15.0)),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ...List.generate(
                                    selectedCategories.length,
                                    (index) => Padding(
                                      padding: EdgeInsets.only(right: d.pSW(8)),
                                      child: CategoryBadge(
                                          onTap: () {
                                            selectedCategories.remove(
                                                selectedCategories[index]);
                                            setState(() {});
                                          },
                                          isSelected: true,
                                          isFavorites: true,
                                          text: selectedCategories[index].name),
                                    ),
                                  )
                                ],
                              ),
                            )),
                      SizedBox(height: d.pSH(32)),
                      categoriesReady
                          ? Padding(
                              padding: EdgeInsets.all(d.pSH(8.0)),
                              child: Wrap(
                                spacing: d.pSW(10),
                                runSpacing: d.pSH(10),
                                children: [
                                  ...List.generate(
                                    categoryProvider.categories.length,
                                    (index) => CategoryBadge(
                                      onTap: () {
                                        if (selectedCategories.contains(
                                            categoryProvider
                                                .categories[index])) {
                                          selectedCategories.remove(
                                              categoryProvider
                                                  .categories[index]);
                                        } else {
                                          selectedCategories.add(
                                              categoryProvider
                                                  .categories[index]);
                                        }
                                        setState(() {});
                                      },
                                      text: categoryProvider
                                          .categories[index].name,
                                      isSelected: selectedCategories.any(
                                          (element) =>
                                              element.name ==
                                              categoryProvider
                                                  .categories[index].name),
                                    ),
                                  ),
                                ],
                              ))
                          : Center(
                              child: Container(
                                height: d.pSH(20),
                                width: d.pSH(20),
                                margin: const EdgeInsets.only(top: 20),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                      color: AppColors.kPrimaryColor),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: d.pSH(35),
                    width: d.pSW(120),
                    child: CustomButton(
                        color: AppColors.kWhite,
                        key: const Key('skip-button'),
                        onTap: () async {},
                        child: Text(
                          'Skip',
                          style: TextStyle(
                              color: AppColors.hintTextBlack,
                              fontSize: d.pSH(16),
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                  SizedBox(width: d.pSW(30)),
                  SizedBox(
                    height: d.pSH(35),
                    width: d.pSW(120),
                    child: CustomButton(
                        color: AppColors.blueBird,
                        key: const Key('proceed-button'),
                        onTap: () async {
                          setState(() {
                            savingCategories = true;
                          });

                          final selectedIds =
                              selectedCategories.map((e) => e.id).toList();

                          final result = await CategoryFunctions()
                              .favoriteCategories(context, selectedIds);

                          setState(() {
                            savingCategories = false;
                          });

                          if (result) {
                            Fluttertoast.showToast(
                                msg: 'Changes saved successfully');

                            categoryProvider
                                .setFavoriteCategories(selectedCategories);
                            if (!mounted) return;
                            Navigator.pop(context);
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Failed to save changes');
                          }
                        },
                        child: Text(
                          'Proceed',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: d.pSH(16),
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: d.pSH(50),
              )
            ],
          ),
        ),
      ),

      ///////////////////////////////////////////////////////////
      ///////////// CIRCULAR PROGRESS INDICATOR///////////////////
      /////////////////////////////////////////////////////////
      savingCategories
          ? LoadIndicator(
              child: appDialog(
                  context: context, loadingMessage: "Saving Changes ..."))
          : const SizedBox()
    ]);
  }
}
