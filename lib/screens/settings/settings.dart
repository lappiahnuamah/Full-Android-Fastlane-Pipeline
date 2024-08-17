import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/screens/settings/account_deactivate.dart';
import 'package:savyminds/screens/settings/components/settings_tile.dart';
import 'package:savyminds/screens/settings/personalization.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/page_template.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      pageTitle: 'Settings',
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: d.pSH(20)),
        child: Column(
          children: [
            SettingsTile(
                title: 'Edit Account',
                description: 'Change some details of your account',
                onTap: () {
                  // nextScreen(context, DeactivateAccount());
                }),
            SettingsTile(
                title: 'Personalization',
                description: 'Personalize your experience',
                onTap: () {
                  nextScreen(context, Personalization());
                }),
            SettingsTile(
                title: 'Background Music',
                description: 'Put background music on or off',
                onTap: () {
                  // nextScreen(context, DeactivateAccount());
                }),
            SettingsTile(
                title: 'TnCs',
                description: '',
                onTap: () {
                  // nextScreen(context, DeactivateAccount());
                }),
            SettingsTile(
                title: 'Privacy Policy',
                description: '',
                onTap: () {
                  // nextScreen(context, DeactivateAccount());
                }),
            SettingsTile(
                title: 'Delete Account',
                description: 'Terminate your account',
                onTap: () {
                  // nextScreen(context, DeactivateAccount());
                }),
          ],
        ),
      ),
    );
  }
}
