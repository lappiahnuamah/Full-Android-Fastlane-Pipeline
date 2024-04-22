import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/providers/categories_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/categories/components/category_card.dart';
import 'package:savyminds/widgets/custom_text.dart';
import 'package:savyminds/widgets/page_template.dart';

class DailyTraining extends StatefulWidget {
  const DailyTraining({super.key});

  @override
  State<DailyTraining> createState() => _DailyTrainingState();
}

class _DailyTrainingState extends State<DailyTraining> {
  late CategoryProvider categoryProvider;

  @override
  void initState() {
    categoryProvider = context.read<CategoryProvider>();
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
            const CustomText(
              label: '100',
              fontWeight: FontWeight.w500,
              color: AppColors.hintTextBlack,
            ),
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
                child: SingleChildScrollView(
              child: Column(
                children: [
                  //Categories
                  ...List.generate(
                      categoryProvider.categories.length > 3
                          ? 3
                          : categoryProvider.categories.length, (index) {
                    return Container(
                      height: d.pSH(156.5),
                      width: d.pSW(160.2),
                      margin: EdgeInsets.only(bottom: d.pSH(8)),
                      child: CategoryCard(
                        category: categoryProvider.categories[index],
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
}
