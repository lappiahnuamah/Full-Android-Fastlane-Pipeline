import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/models/auth/app_user.dart';
import 'package:savyminds/providers/game_provider.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/game/ranking/game_ranking.dart';
import 'package:savyminds/utils/enums/game_enums.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/utils/next_screen.dart';

class GameHeader extends StatelessWidget {
  const GameHeader(
      {super.key,
      this.hideExit,
      this.onTap,
      this.isMultiPlayer,
      this.isTotal,
      this.backText});
  final bool? hideExit;
  final VoidCallback? onTap;
  final bool? isMultiPlayer;
  final bool? isTotal;
  final String? backText;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AppUser currentUser =
        Provider.of<UserDetailsProvider>(context, listen: false)
            .getUserDetails();

    final bright = Theme.of(context).brightness;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!(hideExit ?? false))
          GestureDetector(
            onTap: onTap,
            child: Text(
              backText ?? 'Exit',
              style: TextStyle(
                color: bright == Brightness.dark
                    ? AppColors.kGameDarkRed
                    : AppColors.kGameRed,
                fontSize: getFontSize(32, size),
                fontFamily: 'Architects_Daughter',
              ),
            ),
          ),
        if ((hideExit ?? false)) const SizedBox(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currentUser.username ?? 'User',
                  style: TextStyle(
                      color: bright == Brightness.dark
                          ? AppColors.kGameDarkTextColor
                          : AppColors.kGameTextColor,
                      fontFamily: 'Architects_Daughter',
                      fontSize: getFontSize(22, size)),
                ),
                Consumer<GameProvider>(builder: (context, game, child) {
                  return InkWell(
                    onTap: () {
                      if (!(isTotal ?? false)) {
                        nextScreen(
                            context,
                            GameRanking(
                              rankType: (isTotal ?? false)
                                  ? RankType.overall
                                  : (isMultiPlayer ?? false)
                                      ? RankType.multiPlayer
                                      : RankType.singlePlayer,
                            ));
                      }
                    },
                    child: Text(
                      '',
                      style: TextStyle(
                          color: bright == Brightness.dark
                              ? AppColors.kGameDarkTextColor
                              : AppColors.kGameTextColor,
                          fontFamily: 'Architects_Daughter',
                          fontSize: getFontSize(22, size)),
                    ),
                  );
                }),
              ],
            ),
            SizedBox(width: d.pSW(10)),
            ClipRRect(
              borderRadius: BorderRadius.circular(d.pSH(28)),
              child: CircleAvatar(
                radius: d.pSH(28),
                child: Image.network(
                  currentUser.profileImage ?? '',
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person);
                  },
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
