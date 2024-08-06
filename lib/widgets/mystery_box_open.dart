import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/providers/game_items_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_enums.dart';
import 'package:savyminds/resources/app_fonts.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/custom_text.dart';

class MysteryBoxOpen extends StatefulWidget {
  const MysteryBoxOpen({super.key});

  @override
  State<MysteryBoxOpen> createState() => _MysteryBoxOpenState();
}

class _MysteryBoxOpenState extends State<MysteryBoxOpen> {
  late GameItemsProvider gameItemsProvider;
  bool openingMysteryBox = false;
  bool showReward = false;
  GameKeyType? key;

  @override
  void initState() {
    gameItemsProvider = context.read<GameItemsProvider>();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      openBox();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    dev.log('key: $key');
    return Material(
      child: Container(
        padding: EdgeInsets.all(d.pSH(16)),
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xFFDEFEFC),
          Color(0xFFF2E5FF),
        ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              label: 'Congratulations',
              fontSize: getFontSize(38, size),
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.caveat,
              color: AppColors.everGreen,
            ),
            SizedBox(height: d.pSH(10)),
            CustomText(
              label: 'You got a mystery box!',
              fontSize: getFontSize(30, size),
              fontWeight: FontWeight.bold,
              fontFamily: AppFonts.caveat,
            ),
            SizedBox(height: d.pSH(40)),
            if (showReward && key != null)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    label: key != null
                        ? 'You got a ${gameItemsProvider.userKeys[key!]?.name ?? 'key'}'
                        : 'You got a key',
                    fontSize: getFontSize(30, size),
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.caveat,
                  ).animate()
                    ..scale(duration: 1000.ms)
                    ..moveY(duration: 1000.ms, begin: 50, end: 0),
                  SizedBox(height: d.pSH(20)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        key == null
                            ? ''
                            : gameItemsProvider.userKeys[key!]?.icon ?? '',
                        height: d.pSH(45),
                      ),
                      CustomText(
                        label: ' +1',
                        fontSize: getFontSize(38, size),
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.caveat,
                        color: AppColors.borderAccent,
                      ),
                    ],
                  ).animate()
                    ..scale(duration: 1000.ms)
                    ..moveY(duration: 1000.ms, begin: 50, end: 0),
                ],
              ),
            if (showReward && key != null) SizedBox(height: d.pSH(20)),
            SvgPicture.asset(
              AppImages.mysteryBox,
              height: d.pSH(100),
            ).animate()
              ..shimmer(duration: 1000.ms)
              ..shakeX(duration: 1000.ms),
            if (showReward) SizedBox(height: d.pSH(50)),
            if (showReward)
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: d.pSH(5), horizontal: d.pSW(12)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(d.pSH(22)),
                    border: Border.all(color: AppColors.blueBird, width: 1),
                  ),
                  child: CustomText(
                    label: 'Continue',
                    fontSize: getFontSize(20, size),
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.caveat,
                    color: AppColors.blueBird,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  void openBox() {
    setState(() {
      openingMysteryBox = true;
    });
    getRadomKey();
    openingMysteryBox = false;
    showReward = true;
  }

  getRadomKey() {
    int randomNumer = Random().nextInt(gameItemsProvider.keyTypes.length);
    key = gameItemsProvider.keyTypes[randomNumer];
    gameItemsProvider.increaseKeyAmount(key!);
    setState(() {});
  }
}
