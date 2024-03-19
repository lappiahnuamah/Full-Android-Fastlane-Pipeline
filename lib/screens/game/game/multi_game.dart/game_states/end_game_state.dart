import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/providers/game_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/utils/func.dart';

class EndGameState extends StatefulWidget {
  const EndGameState({super.key, required this.isAdmin});
  final bool isAdmin;

  @override
  State<EndGameState> createState() => _EndGameStateState();
}

class _EndGameStateState extends State<EndGameState> {
  late GameProvider gameProvider;

  @override
  void initState() {
    gameProvider = context.read<GameProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bright = Theme.of(context).brightness;

    return Expanded(
        child: Center(
      child: Container(
        margin: EdgeInsets.all(d.pSH(20)),
        padding:
            EdgeInsets.symmetric(horizontal: d.pSH(15), vertical: d.pSH(25)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(d.pSH(15)),
          color: bright == Brightness.dark
              ? AppColors.kDarkOptionBoxColor
              : AppColors.kOptionBoxColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Game has ended. Please wait while we process the results.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: bright == Brightness.dark
                    ? AppColors.kGameDarkText2Color
                    : AppColors.kGameText2Color,
                fontFamily: 'Architects_Daughter',
                fontSize: getFontSize(26, size),
              ),
            ),
            SizedBox(
              height: d.pSH(25),
            ),
            const Center(
              child: CircularProgressIndicator(color: AppColors.kGameRed),
            ),
          ],
        ),
      ),
    ));
  }
}
