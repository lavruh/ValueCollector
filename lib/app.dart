import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rh_collector/ui/screens/meters_screen.dart';
import 'package:rh_collector/domain/states/camera_state.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<App>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final camera = Get.find<CameraState>();

  @override
  void dispose() async {
    camera.disposeCamera();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
    } else if (state == AppLifecycleState.resumed) {
      camera.initCamera();
    } else if (state == AppLifecycleState.paused) {
    } else if (state == AppLifecycleState.detached) {}
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _theme,
      home: const MetersScreen(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('uk', ''), // Spanish, no country code
      ],
    );
  }

  final ThemeData _theme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.grey,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey))),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: "Georgia",
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
      headline2: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      headline3: TextStyle(
          fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
      headline6: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      bodyText1: TextStyle(fontSize: 12.0),
    ),
    // inputDecorationTheme: InputDecorationTheme(
    //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
  );
}
