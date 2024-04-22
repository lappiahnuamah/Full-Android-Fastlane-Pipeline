import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/providers/game_items_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_enums.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/custom_text.dart';

class GamePageKeysList extends StatefulWidget {
  const GamePageKeysList(
      {super.key,
      required this.answerStreaks,
      required this.onFiftyTapped,
      required this.onFreezeTapped,
      required this.onSwapTapped,
      required this.onGoldenTapped,
      this.hideSwap =false,
      });
  final int answerStreaks;
  final Function() onFiftyTapped;
  final Function() onFreezeTapped;
  final Function() onSwapTapped;
  final Function() onGoldenTapped;
  final bool hideSwap;

  @override
  State<GamePageKeysList> createState() => _GamePageKeysListState();
}

class _GamePageKeysListState extends State<GamePageKeysList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<GameItemsProvider>(
        builder: (context, gameItemsProvider, chikd) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -d.pSH(60),
                left: d.pSH(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                        radius: d.pSH(3),
                        backgroundColor: widget.answerStreaks > 4
                            ? AppColors.kGameGreen
                            : AppColors.kUnselectedCircleColor),
                    SizedBox(height: d.pSH(5)),
                    CircleAvatar(
                        radius: d.pSH(3),
                        backgroundColor: widget.answerStreaks > 3
                            ? AppColors.kGameGreen
                            : AppColors.kUnselectedCircleColor),
                    SizedBox(height: d.pSH(5)),
                    CircleAvatar(
                        radius: d.pSH(3),
                        backgroundColor: widget.answerStreaks > 2
                            ? AppColors.kGameGreen
                            : AppColors.kUnselectedCircleColor),
                    SizedBox(height: d.pSH(5)),
                    CircleAvatar(
                        radius: d.pSH(3),
                        backgroundColor: widget.answerStreaks > 1
                            ? AppColors.kGameGreen
                            : AppColors.kUnselectedCircleColor),
                    SizedBox(height: d.pSH(5)),
                    CircleAvatar(
                        radius: d.pSH(3),
                        backgroundColor: widget.answerStreaks > 0
                            ? AppColors.kGameGreen
                            : AppColors.kUnselectedCircleColor),
                  ],
                ),
              ),
              keyWithAmount(
                size,
                icon: AppImages.fiftyFiftyKey,
                number: gameItemsProvider
                        .userKeys[GameKeyType.fiftyFifty]?.amount ??
                    0,
                onTap: widget.onFiftyTapped,
              ),
            ],
          ),
          // keyWithAmount(
          //   size,
          //   icon: AppImages.retakeKey,
          //   number:
          //       gameItemsProvider.userKeys[GameKeyType.retakeKey]?.amount ?? 0,
          //   onTap: () {
          //     widget.onRetakeTapped.call();
          //     gameItemsProvider.reduceKeyAmount(GameKeyType.retakeKey);
          //   },
          // ),
          keyWithAmount(size,
              icon: AppImages.freezeTimeKey,
              number: gameItemsProvider
                      .userKeys[GameKeyType.freezeTimeKey]?.amount ??
                  0, onTap: () {
            widget.onFreezeTapped.call();
            gameItemsProvider.reduceKeyAmount(GameKeyType.freezeTimeKey);
          }),

          if(!widget.hideSwap)
          keyWithAmount(size,
              icon: AppImages.swapKey,
              number: gameItemsProvider.userKeys[GameKeyType.swapKey]?.amount ??
                  0, onTap: () {
            widget.onSwapTapped.call();
            gameItemsProvider.reduceKeyAmount(GameKeyType.swapKey);
          }),
          keyWithAmount(size,
              icon: AppImages.goldenKey,
              number:
                  gameItemsProvider.userKeys[GameKeyType.goldenKey]?.amount ??
                      0, onTap: () {
            widget.onGoldenTapped.call();
            gameItemsProvider.reduceKeyAmount(GameKeyType.goldenKey);
          }),
        ],
      );
    });
  }

  Widget keyWithAmount(Size size,
      {required String icon,
      required int number,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: number < 1 ? null : onTap,
      child: Stack(
        children: [
          SvgPicture.asset(icon,
              height: d.pSH(40),
              fit: BoxFit.fitHeight,
              colorFilter: number < 1
                  ? const ColorFilter.mode(Colors.grey, BlendMode.srcIn)
                  : null),
          if (number > 0)
            Positioned(
              right: 0,
              child: CircleAvatar(
                backgroundColor: const Color(0xffF14646),
                radius: d.pSH(8),
                child: CustomText(
                  label: number.toString(),
                  color: Colors.white,
                  fontSize: getFontSize(12, size),
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
        ],
      ),
    );
  }
}
