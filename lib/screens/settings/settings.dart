import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/providers/audio_provider.dart';
import 'package:savyminds/providers/game_items_provider.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:savyminds/resources/app_colors.dart';
import 'package:savyminds/screens/authentication/change_display_name.dart';
import 'package:savyminds/screens/authentication/splashscreen.dart';
import 'package:savyminds/screens/settings/account_deactivate.dart';
import 'package:savyminds/screens/settings/components/settings_tile.dart';
import 'package:savyminds/screens/settings/personalization.dart';
import 'package:savyminds/utils/cache/content_mgt.dart';
import 'package:savyminds/utils/cache/shared_preferences_helper.dart';
import 'package:savyminds/utils/next_screen.dart';
import 'package:savyminds/widgets/savvy_webview.dart';
import 'package:savyminds/widgets/page_template.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late GameItemsProvider gameItemsProvider;

  @override
  void initState() {
    gameItemsProvider = context.read<GameItemsProvider>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      pageTitle: 'Settings',
      child: Consumer2<AudioProvider, UserDetailsProvider>(
          builder: (context, audioProvider, userProvider, child) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: d.pSH(20)),
          child: Column(
            children: [
              SettingsTile(
                  title: 'Edit Account',
                  description: 'Change some details of your account',
                  onTap: () {
                    nextScreen(
                        context,
                        ChangeDisplayName(
                          username: userProvider.getUserDetails().displayName ??
                              userProvider.getUserDetails().username ??
                              '',
                          fromSettingsPage: true,
                        ));
                  }),
              SettingsTile(
                  title: 'Personalization',
                  description: 'Personalize your experience',
                  onTap: () {
                    nextScreen(
                        context,
                        Personalization(
                          fromSettingsPage: true,
                        ));
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
                  title: 'Log out',
                  description: 'Sign out your account',
                  onTap: () {
                    showLogoutDialog();
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
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
    nextScreenCloseOthers(context, const SplashScreen());
  }
}
