import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/providers/game_items_provider.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/authentication/splashscreen.dart';
import 'package:savyminds/screens/profile/components/key_card.dart';
import 'package:savyminds/screens/records/components/record_rank_header.dart';
import 'package:savyminds/utils/cache/content_mgt.dart';
import 'package:savyminds/utils/cache/shared_preferences_helper.dart';
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

    return Consumer2<GameItemsProvider, UserDetailsProvider>(
        builder: (context, gameItemsProvider, userDetailsProvider, child) {
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

                // InkWell(
                //   onTap: () {
                //     nextScreen(context, const Personalization());
                //     //ƒ().clearAll();
                //   },
                //   child: const Icon(
                //     Icons.settings,
                //     color: AppColors.hintTextBlack,
                //   ),
                // ),
              ],
            ),
            SizedBox(height: d.pSH(22)),
            Expanded(
              child: Column(
                children: [
                  //Name
                  CustomText(
                    label:
                        '${userDetailsProvider.getUserDetails().displayName ?? userDetailsProvider.getUserDetails().username}',
                    fontWeight: FontWeight.w500,
                    fontSize: getFontSize(25, size),
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
                        label:
                            '${gameItemsProvider.gameStreaks.streaks} ${gameItemsProvider.gameStreaks.streaks > 1 ? "Days" : "Day"}',
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
                        label: '${gameItemsProvider.gameStreaks.gamesPlayed}',
                        fontWeight: FontWeight.w500,
                        fontSize: getFontSize(16, size),
                      ),
                    ],
                  ),
                  SizedBox(height: d.pSH(20)),

                  InkWell(
                    onTap: () {
                      showLogoutDialog();
                    },
                    child: Container(
                      width: size.width * 0.3,
                      padding: EdgeInsets.symmetric(
                          horizontal: d.pSW(10), vertical: d.pSH(4)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.kGameRed,
                        ),
                      ),
                      child: Center(
                        child: CustomText(
                          label: 'Log Out',
                          fontSize: getFontSize(13, size),
                          color: AppColors.kGameRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: d.pSH(35)),

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

  Future<void> showLogoutDialog() async {
    await showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                logout();
              },
              child: const Text(
                'Log Out',
                style: TextStyle(color: AppColors.kGameRed),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> logout() async {
    gameItemsProvider.clearStreaks();
    ContentManagement().clearAll();
    SharedPreferencesHelper.clearCache();
    nextScreenCloseOthers(context, const SplashScreen());
  }
}
