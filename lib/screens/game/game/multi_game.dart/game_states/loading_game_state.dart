import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/providers/game_provider.dart';
import 'package:savyminds/resources/app_colors.dart';


class LoadingGameState extends StatefulWidget {
  const LoadingGameState({super.key, required this.isAdmin});
  final bool isAdmin;

  @override
  State<LoadingGameState> createState() => _LoadingGameStateState();
}

class _LoadingGameStateState extends State<LoadingGameState> {
  late GameProvider gameProvider;

  @override
  void initState() {
    gameProvider = context.read<GameProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(
        child: CircularProgressIndicator(color: AppColors.kGameRed),
      ),
    );
  }
}
