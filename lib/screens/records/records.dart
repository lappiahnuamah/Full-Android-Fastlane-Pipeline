import 'package:flutter/material.dart';
import 'package:savyminds/screens/authentication/splashscreen.dart';
import 'package:savyminds/utils/cache/content_mgt.dart';
import 'package:savyminds/utils/cache/shared_preferences_helper.dart';
import 'package:savyminds/utils/next_screen.dart';

class Records extends StatefulWidget {
  const Records({super.key});

  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          SharedPreferencesHelper.clearCache();
          ContentManagement().clearAll();
          nextScreen(context, const SplashScreen());
        },
        child: const Text('Records'),
      ),
    );
  }
}
