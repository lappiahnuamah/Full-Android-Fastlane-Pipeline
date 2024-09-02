import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/categories/categories_model.dart';
import 'package:savyminds/providers/solo_quest_provider.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/screens/solo_quest/training_mode/training_mode.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/custom_text.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({
    super.key,
    required this.category,
    this.index,
    this.hidePlay = false,
    this.fontSize,
    this.iconSize,
    this.borderRadius,
    this.greyedOut = false,
    this.isDailyTraining = false,
    this.isFavCategory = false,
  });
  final CategoryModel category;
  final int? index;
  final bool hidePlay;
  final double? fontSize;
  final double? iconSize;
  final double? borderRadius;
  final bool greyedOut;
  final bool isDailyTraining;

  final bool isFavCategory;

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  late SoloQuestProvider soloQuestProvider;

  @override
  void initState() {
    soloQuestProvider = context.read<SoloQuestProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: !widget.hidePlay
          ? () {
              if (!(widget.category.isLocked || widget.greyedOut)) {
                log('is daily training on card: ${widget.isDailyTraining}');

                nextScreen(
                  context,
                  TrainingMode(
                    category: widget.category,
                    quest: soloQuestProvider.getQuestByName('Training Mode'),
                    isDailyTraining: widget.isDailyTraining,
                  ),
                  TransitionType.fade,
                );
              } else {}
            }
          : null,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: d.isTablet ? d.pSW(25) : d.pSW(4)),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.002)
                ..rotateX(0.5)
                ..rotateY(0.05),
              child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(widget.borderRadius ?? d.pSH(25)),
                ),
                child: Stack(
                  children: [
                    Container(
                      color: (widget.category.isLocked || widget.greyedOut)
                          ? const Color(0xFF717582)
                          : widget.category.color,
                      width: double.infinity,
                      height: double.maxFinite,
                    ),
                    if (widget.category.icon.isNotEmpty)
                      Positioned(
                        left: -d.pSW(50),
                        top: d.pSH(20),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation(d.pSW(40 / 360)),
                          child: SvgPicture.network(
                            widget.category.icon,
                            fit: BoxFit.cover,
                            height: d.pSH(130),
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.1),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          //Align
          Align(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  d.pSH(12), d.pSH(10), d.pSH(12), d.pSH(16)),
              child: Column(
                children: [
                  SizedBox(height: d.pSH(5)),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.category.icon.isNotEmpty)
                          SizedBox(
                              height: widget.iconSize ?? d.pSH(45),
                              child: Hero(
                                tag: widget.isFavCategory
                                    ? 'Fav-category-Logo-${widget.category.name}'
                                    : 'Category-Logo-${widget.category.name}',
                                child: SvgPicture.network(
                                  widget.category.icon,
                                  fit: d.isTablet
                                      ? BoxFit.fitWidth
                                      : BoxFit.fitHeight,
                                  height: widget.iconSize,
                                ),
                              )),
                        SizedBox(height: d.pSH(6)),
                        CustomText(
                          label: widget.category.name,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.center,
                          fontSize: widget.fontSize ?? 13,
                        )
                      ],
                    ),
                  ),

                  //Play or Unlock
                  if (!widget.hidePlay)
                    Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: () {
                            if (!(widget.category.isLocked ||
                                widget.greyedOut)) {
                              nextScreen(
                                context,
                                TrainingMode(
                                  category: widget.category,
                                  quest: soloQuestProvider
                                      .getQuestByName('Training Mode'),
                                  isDailyTraining: widget.isDailyTraining,
                                ),
                                TransitionType.fade,
                              );
                            } else {}
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: d.isTablet ? d.pSH(18) : d.pSH(8),
                                horizontal: d.isTablet ? d.pSW(35) : d.pSW(8)),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: d.pSH(3), horizontal: d.pSW(5)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(d.pSH(5)),
                                border:
                                    Border.all(color: Colors.white, width: 0.5),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    (widget.category.isLocked ||
                                            widget.greyedOut)
                                        ? AppImages.openedLock
                                        : AppImages.playCategoryIcon,
                                    fit: BoxFit.cover,
                                    height: d.isTablet ? d.pSH(15) : d.pSH(10),
                                  ),
                                  SizedBox(width: d.pSW(5)),
                                  CustomText(
                                    label: (widget.category.isLocked ||
                                            widget.greyedOut)
                                        ? 'Unlock'
                                        : 'Play',
                                    color: Colors.white,
                                    fontSize: widget.fontSize != null
                                        ? (widget.fontSize! * 0.7)
                                        : 12.5,
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
          if ((widget.category.isLocked))
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: d.isTablet ? d.pSH(20) : d.pSH(12),
                  horizontal: d.isTablet ? d.pSW(40) : d.pSW(12)),
              child: SvgPicture.asset(
                AppImages.closedLock,
                fit: BoxFit.cover,
                height: d.isTablet ? d.pSH(20) : null,
              ),
            ),
        ],
      ),
    );
  }
}
