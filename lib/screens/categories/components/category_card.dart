import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/screens/categories/category_details_page.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/custom_text.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard(
      {super.key, required this.category, this.index, this.hidePlay = false});
  final CategoryModel category;
  final int? index;
  final bool hidePlay;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.002)
        ..rotateX(0.4)
        ..rotateY(0.05),
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(d.pSH(25)),
        ),
        child: Stack(
          children: [
            Container(
              color:
                  category.isLocked ? const Color(0xFF717582) : category.color,
              width: double.infinity,
              height: double.maxFinite,
            ),
            Positioned(
              left: -d.pSH(50),
              top: d.pSH(20),
              child: RotationTransition(
                turns: const AlwaysStoppedAnimation(40 / 360),
                child: SvgPicture.network(
                  category.icon,
                  fit: BoxFit.cover,
                  height: d.pSH(130),
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.1),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),

            //Align
            Align(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(height: d.pSH(5)),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.network(
                            category.icon,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: d.pSH(5)),
                          CustomText(
                            label: category.name,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),

                    //Play or Unlock
                    if (!hidePlay)
                      Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: () {
                              if (!category.isLocked) {
                                nextScreen(context,
                                    CategoryDetailsPage(category: category));
                              } else {}
                            },
                            child: Padding(
                              padding: EdgeInsets.all(d.pSH(8)),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: d.pSH(3), horizontal: d.pSW(5)),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(d.pSH(5)),
                                  border: Border.all(
                                      color: Colors.white, width: 0.5),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      category.isLocked
                                          ? AppImages.openedLock
                                          : AppImages.playCategoryIcon,
                                      fit: BoxFit.cover,
                                      height: d.pSH(10),
                                    ),
                                    SizedBox(width: d.pSW(5)),
                                    CustomText(
                                      label:
                                          category.isLocked ? 'Unlock' : 'Play',
                                      color: Colors.white,
                                      fontSize: 12.5,
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ))
                  ],
                ),
              ),
            ),

            //Lock
            if (category.isLocked)
              Padding(
                padding: EdgeInsets.all(d.pSH(12)),
                child: SvgPicture.asset(
                  AppImages.closedLock,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
