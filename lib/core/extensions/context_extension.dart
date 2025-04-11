import 'package:catalogat_app/core/constants/app_constants.dart';
import 'package:catalogat_app/core/dependencies.dart';

extension ContextExtension on BuildContext {
  /// Returns the current locale of the app.
  Locale get currentLocale => Localizations.localeOf(this);

  /// Returns the current theme mode of the app.
  ThemeMode get currentThemeMode => Theme.of(this).brightness == Brightness.dark
      ? ThemeMode.dark
      : ThemeMode.light;

  /// Returns the current text direction of the app.
  TextDirection get currentTextDirection => Directionality.of(this);

  AppLocalizations get l10n => AppLocalizations.of(this)!;

  Locale get arabicLocale => const Locale(AppConstants.arabicLanguageCode);
  /// is arabic
  bool get isRtl => currentLocale.languageCode == AppConstants.arabicLanguageCode;
}