import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:savyminds/providers/appsocket_provider.dart';
import 'package:savyminds/providers/dark_theme_provider.dart';
import 'package:savyminds/providers/game_provider.dart';
import 'package:savyminds/providers/registration_provider.dart';
import 'package:savyminds/providers/user_details_provider.dart';
import 'package:savyminds/screens/authentication/splashscreen.dart';
import 'package:savyminds/utils/cache/shared_preferences_helper.dart';
import 'package:savyminds/utils/theme_manager.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferencesHelper().init();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserDetailsProvider()),
    ChangeNotifierProvider(create: (_) => RegistrationProvider()),
    ChangeNotifierProvider(create: (_) => DarkThemeProvider()),
    ChangeNotifierProvider(create: (_) => GameProvider()),
    ChangeNotifierProvider(create: (_) => GameWebSocket())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, child) {
      return OverlaySupport.global(
          child: MaterialApp(
        title: 'Savy Minds',
        theme: CustomTheme().lightTheme,
        darkTheme: CustomTheme().darkTheme,
        themeMode: value.theme == 0
            ? ThemeMode.system
            : value.theme == 2
                ? ThemeMode.dark
                : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ));
    });
  }
}
