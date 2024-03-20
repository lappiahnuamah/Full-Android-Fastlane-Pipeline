import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
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
                children: const [
                  CategoryCard(),
                  CategoryCard(),
                  CategoryCard(),
                  CategoryCard(),
                ]),
            SizedBox(height: d.pSH(16)),

            /// All Categories
            const CustomText(
              label: 'All Categories',
              fontWeight: FontWeight.w500,
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
                children: const [
                  CategoryCard(),
                  CategoryCard(),
                  CategoryCard(),
                  CategoryCard(),
                  CategoryCard(),
                  CategoryCard(),
                ]),
          ],
        ),
      ),
    );
  }
}
