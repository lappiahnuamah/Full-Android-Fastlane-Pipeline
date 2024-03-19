import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/providers/appsocket_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/utils/func.dart';
import 'package:savyminds/widgets/trasformed_button.dart';


class PauseGameState extends StatefulWidget {
  const PauseGameState({super.key, required this.isAdmin});
  final bool isAdmin;

  @override
  State<PauseGameState> createState() => _PauseGameStateState();
}

class _PauseGameStateState extends State<PauseGameState> {
  late GameWebSocket gameSocket;

  @override
  void initState() {
    gameSocket = context.read<GameWebSocket>();
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
              'Game has been paused ${widget.isAdmin ? '' : 'by admin'}',
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
            widget.isAdmin
                ? TransformedButton(
                    onTap: () {
                      gameSocket.startGame();
                    },
                    buttonText: 'Resume Game',
                  )
                : Center(
                    child: Text(
                      'Please wait for admin to resume game',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: bright == Brightness.dark
                            ? AppColors.kGameDarkText2Color
                            : AppColors.kGameText2Color,
                        fontFamily: 'Architects_Daughter',
                        fontSize: getFontSize(20, size),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    ));
  }
}
