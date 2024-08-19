import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/providers/audio_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/settings/account_deactivate.dart';
import 'package:savyminds/screens/settings/components/settings_tile.dart';
import 'package:savyminds/screens/settings/personalization.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/savvy_webview.dart';
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
      child: Consumer<AudioProvider>(builder: (context, audioProvider, child) {
        return Padding(
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
                onTap: () {},
                trailing: switchWidget(
                  value: audioProvider.playBackgroundMusic,
                  audioProvider: audioProvider,
                  onChanged: (value) {
                    audioProvider.toggleBackgroundMusic();
                  },
                ),
              ),
              SettingsTile(
                title: 'Sound Effects',
                description: 'Put in game sound on or off',
                onTap: () {},
                trailing: switchWidget(
                  value: audioProvider.playSoundEffects,
                  audioProvider: audioProvider,
                  onChanged: (value) {
                    audioProvider.toggleSoundEffects();
                  },
                ),
              ),
              SettingsTile(
                  title: 'Terms & Conditions',
                  description: '',
                  onTap: () {
                    nextScreen(
                        context,
                        SavvyWebView(
                          pageTitle: 'Terms & Conditions',
                          initialURL:
                              'https://www.teratecksolutions.com/tncs-savvyminds',
                        ));
                  }),
              SettingsTile(
                  title: 'Privacy Policy',
                  description: '',
                  onTap: () {
                    nextScreen(
                        context,
                        SavvyWebView(
                          pageTitle: 'Privacy Policy',
                          initialURL:
                              'https://www.teratecksolutions.com/privacy',
                        ));
                  }),
              SettingsTile(
                  title: 'Delete Account',
                  description: 'Terminate your account',
                  onTap: () {
                    nextScreen(context, DeactivateAccount());
                  }),
            ],
          ),
        );
      }),
    );
  }

  Widget switchWidget(
      {required AudioProvider audioProvider,
      required bool value,
      required void Function(bool)? onChanged}) {
    return SizedBox(
      height: d.pSH(50),
      child: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColors.everGreen.withOpacity(0.6),
        inactiveThumbColor: AppColors.hintTextBlack,
        thumbColor: MaterialStateProperty.all(AppColors.everGreen),
        overlayColor:
            MaterialStateProperty.all(AppColors.kGameRed.withOpacity(0.4)),
      ),
    );
  }
}
