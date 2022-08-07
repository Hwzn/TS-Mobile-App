import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:ts_academy/core/services/notification/notification_service.dart';
import 'package:ts_academy/core/services/preference/preference.dart';
import 'package:ts_academy/ui/pages/shared/splash/splash_page.dart';
import 'package:ts_academy/ui/styles/size_config.dart';
import 'core/providers/provider_setup.dart';
import 'core/services/localization/localization.dart';
import 'core/services/theme/theme_provider.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );

  await Preference.init();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    print(e.toString());
  }

  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

// This widget is the root of your application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguageModel>(
        create: (_) => AppLanguageModel(),
        child: Consumer<AppLanguageModel>(builder: (context, model, child) {
          return ChangeNotifierProvider<ThemeProvider>(
              create: (_) => ThemeProvider(),
              child: Consumer<ThemeProvider>(builder: (context, theme, child) {
                return OverlaySupport(
                  child: MultiProvider(
                    providers: providers,
                    child: LayoutBuilder(
                      builder: (context, constraints) =>
                          OrientationBuilder(builder: (context, orientation) {
                        SizeConfig().init(constraints, orientation);
                        // model.fetchLocale();
                        return MaterialApp(
                          navigatorKey: navigatorKey,
                          themeMode: ThemeMode.light,
                          home: SplashScreen(),
                          debugShowCheckedModeBanner: false,
                          theme: theme.light,
                          locale: model.appLocal,
                          supportedLocales: const [Locale('en'), Locale('ar')],
                          localizationsDelegates: const [
                            AppLocalizations.delegate,
                            GlobalMaterialLocalizations.delegate,
                            GlobalWidgetsLocalizations.delegate,
                            DefaultMaterialLocalizations.delegate,
                            DefaultCupertinoLocalizations.delegate,
                            DefaultWidgetsLocalizations.delegate,
                            GlobalCupertinoLocalizations.delegate,
                          ],
                        );
                      }),
                    ),
                  ),
                );
              }));
        }));
  }
}
