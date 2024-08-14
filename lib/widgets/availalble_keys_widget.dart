import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/providers/game_items_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/screens/profile/components/key_card.dart';
import 'package:savyminds/widgets/custom_text.dart';

class AvailableKeysWidget extends StatefulWidget {
  const AvailableKeysWidget({super.key, this.showShop = true});
  final bool showShop;

  @override
  State<AvailableKeysWidget> createState() => _AvailableKeysWidgetState();
}

class _AvailableKeysWidgetState extends State<AvailableKeysWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameItemsProvider>(
        builder: (context, gameItemsProvider, child) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            runSpacing: 25,
            children: [
              ...List.generate(gameItemsProvider.userKeys.length, (index) {
                final userKey =
                    gameItemsProvider.userKeys.values.elementAt(index);
                return userKey.amount > 0
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: d.pSW(d.isTablet ? 15 : 8)),
                        child: KeyCard(
                          gameKey: userKey,
                          height: d.pSH(35),
                        ).animate().shake(duration: const Duration(seconds: 2)),
                      )
                    : const SizedBox();
              }),
            ],
          ),
          if (widget.showShop) SizedBox(height: d.pSH(16)),
          if (widget.showShop)
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: d.pSH(5), horizontal: d.pSW(12)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(d.pSH(22)),
                  border: Border.all(color: AppColors.borderPrimary, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppImages.shopBag,
                      fit: BoxFit.cover,
                      height: d.pSH(12),
                      width: d.pSH(12),
                      colorFilter: const ColorFilter.mode(
                          AppColors.blueBird, BlendMode.srcIn),
                    ),
                    SizedBox(width: d.pSW(8)),
                    const CustomText(
                      label: 'Shop Keys',
                      color: AppColors.borderPrimary,
                      fontSize: 14,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            )
        ],
      );
    });
  }
}
