import 'dart:io';

import 'package:app/src/helpers/notification_service.dart';
import 'package:app/src/ui/home_page/provider/map_provider.dart';
import 'package:app/src/ui/splash/splash_screen.dart';
import 'package:app/src/variables/util_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:optimize_battery/optimize_battery.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then((value) {
    if (value) Permission.notification.request();
  });
  WakelockPlus.enable();
  NotificationService().initNotification();
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'uz', supportedLocales: ['uz', 'ru']);
  //client.initClient();
  pref = await SharedPreferences.getInstance();
  await loadMapAssets();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then(
    (_) => runApp(
      LocalizedApp(delegate, const ProviderScope(child: MyApp())),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    if (Platform.isAndroid) {
      OptimizeBattery.isIgnoringBatteryOptimizations().then((onValue) {});
    }
    super.initState();
  }

  //
  // @override
  // void didChangePlatformBrightness() {
  //   setTheme();
  //   super.didChangePlatformBrightness();
  // }

  void setTheme() async {
    // if (pref.getBool('ThemeApp') == null) {
    //   print('pref.getBool(ThemeApp) == null');
    //   final isdark =
    //       Brightness.dark == MediaQuery.platformBrightnessOf(context);
    //   if (mounted && isdark != isDark) {
    //     setState(() {
    //       isDark = isdark;
    //     });
    //     //mapNotifier.setMapStyle();
    //   }
    // } else {
    //   isDark = pref.getBool('ThemeApp') ?? false;
    // }

    isDark = pref.getBool('ThemeApp') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          localizationDelegate
        ],
        supportedLocales: localizationDelegate.supportedLocales,
        locale: localizationDelegate.currentLocale,
        theme: ThemeData(platform: TargetPlatform.iOS),
        builder: (BuildContext context, Widget? child) {
          height = MediaQuery.of(context).size.height / 600;
          width = MediaQuery.of(context).size.width / 600;
          arifmethic = (height + width) / 2;
          return MediaQuery(data: MediaQuery.of(context), child: child!);
        },
        home: const SplashScreen(),
      ),
    );
  }
}
