import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/game_key_model.dart';
import 'package:savyminds/providers/game_items_provider.dart';
import 'package:savyminds/providers/game_provider.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/resources/app_enums.dart';
import 'package:savyminds/screens/profile/components/key_card.dart';
import 'package:savyminds/screens/records/components/record_rank_header.dart';
import 'package:savyminds/screens/settings/personalization.dart';
import 'package:savyminds/utils/cache/content_mgt.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/custom_text.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late GameItemsProvider gameItemsProvider;

  @override
  void initState() {
    gameItemsProvider = context.read<GameItemsProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer2<GameProvider, UserDetailsProvider>(
        builder: (context, gameProvider, userDetailsProvider, child) {
      return Padding(
        padding: EdgeInsets.all(d.pSH(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  label: 'Profile',
                  fontWeight: FontWeight.w700,
                  fontSize: getFontSize(24, size),
                ),
                InkWell(
                  onTap: () {
                    // nextScreen(context, const Personalization());
                    ContentManagement().clearAll();
                  },
                  child: const Icon(
                    Icons.settings,
                    color: AppColors.hintTextBlack,
                  ),
                ),
              ],
            ),
            SizedBox(height: d.pSH(22)),
            Expanded(
              child: Column(
                children: [
                  //Name
                  CustomText(
                    label:
                        '${userDetailsProvider.getUserDetails().fullname?.split(" ").first}',
                    fontWeight: FontWeight.w500,
                    fontSize: getFontSize(30, size),
                  ),
                  SizedBox(height: d.pSH(12)),

                  //Streaks and games

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        label: 'Current Streaks  ',
                        fontWeight: FontWeight.w300,
                        fontSize: getFontSize(16, size),
                      ),
                      CustomText(
                        label: '30 Days',
                        fontWeight: FontWeight.w500,
                        fontSize: getFontSize(16, size),
                      ),
                    ],
                  ),
                  SizedBox(height: d.pSH(8)),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        label: 'Games so far  ',
                        fontWeight: FontWeight.w300,
                        fontSize: getFontSize(16, size),
                      ),
                      CustomText(
                        label: '200',
                        fontWeight: FontWeight.w500,
                        fontSize: getFontSize(16, size),
                      ),
                    ],
                  ),
                  SizedBox(height: d.pSH(30)),

                  ///Savvy Store
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        label: 'Savvy Store',
                        fontWeight: FontWeight.w500,
                        fontSize: getFontSize(23, size),
                      ),
                      RecordRankHeader(
                          title: 'Open Store',
                          onTapped: () {},
                          isSelected: false),
                    ],
                  ),
                  SizedBox(height: d.pSH(16)),

                  //Current  and limited
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        label: 'Current Plan',
                        fontWeight: FontWeight.w300,
                        fontSize: getFontSize(19, size),
                      ),
                      SizedBox(
                        width: d.pSW(15),
                      ),
                      CustomText(
                        label: 'Limited User',
                        fontWeight: FontWeight.w500,
                        fontSize: getFontSize(19, size),
                      ),
                    ],
                  ),
                  SizedBox(height: d.pSH(15)),
                  CustomText(
                    label: 'User Keys',
                    fontWeight: FontWeight.w500,
                    fontSize: getFontSize(19, size),
                  ),
                  SizedBox(height: d.pSH(3)),

                  //Keys
                  GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: d.pSW(8),
                      mainAxisSpacing: d.pSH(8),
                      childAspectRatio: 1,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ...List.generate(gameItemsProvider.userKeys.length,
                          (index) {
                        final userKey =
                            gameItemsProvider.userKeys.values.elementAt(index);
                        return Padding(
                            padding: EdgeInsets.symmetric(horizontal: d.pSW(6)),
                            child: KeyCard(
                              gameKey: userKey,
                              height: d.pSH(35),
                            ));
                      }),
                    ],
                  ),

                  SizedBox(height: d.pSH(30)),

                  // ///Achievemets
                  // Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       CustomText(
                  //         label: 'Achievements',
                  //         fontWeight: FontWeight.w500,
                  //         fontSize: getFontSize(23, size),
                  //       ),
                  //     ])
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}

List gameKeyList = const [
  GameKeyModel(
    id: 1,
    name: 'Golden Key',
    amount: 3,
    icon: 'assets/icons/game_keys/golden_key.svg',
    isLocked: false,
    type: GameKeyType.goldenKey,
  ),
  GameKeyModel(
    id: 1,
    name: 'Fifty fity Key',
    amount: 3,
    icon: 'assets/icons/game_keys/fifty_fifty.svg',
    isLocked: false,
    type: GameKeyType.goldenKey,
  ),
  GameKeyModel(
    id: 1,
    name: 'Hint Key',
    amount: 2,
    icon: 'assets/icons/game_keys/hint_key.svg',
    isLocked: false,
    type: GameKeyType.goldenKey,
  ),
  GameKeyModel(
    id: 1,
    name: 'Freeze Time Key',
    amount: 3,
    icon: 'assets/icons/game_keys/freeze_time_key.svg',
    isLocked: false,
    type: GameKeyType.goldenKey,
  ),
  GameKeyModel(
    id: 1,
    name: 'Retake Key',
    amount: 3,
    icon: 'assets/icons/game_keys/retake_key.svg',
    isLocked: false,
    type: GameKeyType.goldenKey,
  ),
  GameKeyModel(
    id: 1,
    name: 'Swap Key',
    amount: 3,
    icon: 'assets/icons/game_keys/swap_key.svg',
    isLocked: true,
    type: GameKeyType.goldenKey,
  ),
  GameKeyModel(
    id: 1,
    name: 'Double Points Key',
    amount: 3,
    icon: 'assets/icons/game_keys/double_points.svg',
    isLocked: true,
    type: GameKeyType.goldenKey,
  ),
  GameKeyModel(
    id: 1,
    name: 'Mystery Box Key',
    amount: 3,
    icon: 'assets/icons/game_keys/mystery_box.svg',
    isLocked: true,
    type: GameKeyType.goldenKey,
  ),
];
