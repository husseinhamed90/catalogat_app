import 'package:catalogat_app/core/config/app_config.dart';
import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/core/constants/app_constants.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/routes/router_generator.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  setupLocator();
  runApp(
    DevicePreview(
      enabled: AppConfig.devicePreview,
      tools: const [
        ...DevicePreview.defaultTools,
      ],
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale(AppConstants.arabicLanguageCode),
      navigatorKey: globalKey,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale(AppConstants.englishLanguageCode), // English
        Locale(AppConstants.arabicLanguageCode), // Spanish
      ],
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        fontFamily: AppConstants.fontFamilyName,
      ),
      initialRoute: Routes.home,
      onGenerateRoute: RouterGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
