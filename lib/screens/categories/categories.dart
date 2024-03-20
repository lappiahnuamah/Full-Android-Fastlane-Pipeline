import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/categories/categories_model.dart';
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
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
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
            const CustomText(
              label: 'Favorites',
              fontWeight: FontWeight.w500,
              color: AppColors.hintTextBlack,
            ),
            SizedBox(height: d.pSH(16)),
            GridView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: d.pSW(30),
                  mainAxisSpacing: d.pSH(16),
                ),
                children: [
                  ...List.generate(
                    4,
                    (index) => CategoryCard(
                      category: CategoryModel(
                        id: index,
                        name: 'Mathematics',
                        color: [
                          const Color(0xFF448BA2),
                          const Color(0xFFAD6F4A),
                          const Color(0xFF9B4B72),
                          const Color(0xFF53A251),
                        ][index],
                        noOfQuestion: 10,
                        icon: 'assets/icons/math.svg',
                        isLocked: false,
                      ),
                    ),
                  ),
                ]),
            SizedBox(height: d.pSH(16)),

            /// All Categories
            const CustomText(
              label: 'All Categories',
              fontWeight: FontWeight.w500,
              color: AppColors.hintTextBlack,
            ),
            SizedBox(height: d.pSH(16)),
            GridView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: d.pSW(30),
                  mainAxisSpacing: d.pSH(16),
                ),
                children: [
                  ...List.generate(
                    8,
                    (index) => CategoryCard(
                        category: CategoryModel(
                      id: index,
                      name: 'Mathematics',
                      color: const Color(0xFF448BA2),
                      noOfQuestion: 10,
                      icon: 'assets/icons/math.svg',
                      isLocked: true,
                    )),
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}
