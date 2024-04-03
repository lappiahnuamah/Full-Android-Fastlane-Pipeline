import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_images.dart';
import 'package:savyminds/screens/profile/components/key_card.dart';
import 'package:savyminds/screens/profile/profile.dart';
import 'package:savyminds/widgets/custom_text.dart';

class AvailalableKeysWidget extends StatefulWidget {
  const AvailalableKeysWidget({super.key});

  @override
  State<AvailalableKeysWidget> createState() => _AvailalableKeysWidgetState();
}

class _AvailalableKeysWidgetState extends State<AvailalableKeysWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(4, (index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: d.pSW(8)),
                child: KeyCard(
                  gameKey: gameKeyList[index],
                  height: 35,
                ),
              );
            }),
          ],
        ),
        SizedBox(height: d.pSH(16)),
        InkWell(
          onTap: () {},
          child: Container(
            padding:
                EdgeInsets.symmetric(vertical: d.pSH(5), horizontal: d.pSW(12)),
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
  }
}
