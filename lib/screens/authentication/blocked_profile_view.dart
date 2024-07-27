import 'package:flutter/material.dart';
import 'package:savyminds/models/auth/app_user.dart';

class BlockedProfileView extends StatefulWidget {
  const BlockedProfileView(
      {super.key, required this.currentUser, required this.isMyAccount});
  final AppUser currentUser;
  final bool isMyAccount;

  @override
  State<BlockedProfileView> createState() => _BlockedProfileViewState();
}

class _BlockedProfileViewState extends State<BlockedProfileView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
