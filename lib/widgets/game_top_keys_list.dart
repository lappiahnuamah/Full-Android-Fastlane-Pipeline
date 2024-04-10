import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/providers/game_items_provider.dart';
import 'package:savyminds/resources/app_enums.dart';

import '../resources/app_images.dart';

class GameTopKeysList extends StatelessWidget {
  const GameTopKeysList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameItemsProvider>(
        builder: (context, gameItemsProvider, chikd) {
      return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InkWell(
                onTap: () {},
                child: SvgPicture.asset(AppImages.hintKey,
                    height: d.pSH(33),
                    colorFilter: (gameItemsProvider
                                    .userKeys[GameKeyType.hintKey]?.amount ??
                                0) <
                            1
                        ? const ColorFilter.mode(Colors.grey, BlendMode.srcIn)
                        : null)),
            SizedBox(width: d.pSH(34)),
            InkWell(
                onTap: () {},
                child: SvgPicture.asset(AppImages.mysteryBox,
                    height: d.pSH(43),
                    colorFilter: (gameItemsProvider
                                    .userKeys[GameKeyType.mysteryBox]?.amount ??
                                0) <
                            1
                        ? const ColorFilter.mode(Colors.grey, BlendMode.srcIn)
                        : null)),
            SizedBox(width: d.pSH(30)),
            InkWell(
                onTap: () {},
                child: SvgPicture.asset(AppImages.doublePoints,
                    height: d.pSH(33),
                    colorFilter: (gameItemsProvider
                                    .userKeys[GameKeyType.doublePointsKey]
                                    ?.amount ??
                                0) <
                            1
                        ? const ColorFilter.mode(Colors.grey, BlendMode.srcIn)
                        : null))
          ],
        ),
      );
    });
  }
}
