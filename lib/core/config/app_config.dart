/// Application-wide configuration values — Muzammil Autos.
class AppConfig {
  const AppConfig._();

  static const String appName = 'Muzammil Autos';
  static const String workshopName = 'Muzammil Autos';
  static const String workshopTagline = 'Spare Parts and Oil Change';
  static const String appVersion = '1.0.0';
  static const String databaseName = 'autocare_manager.db';
  static const int databaseVersion = 1;

  /// Brand logo asset (full identity kit mark).
  static const String logoAsset = 'assets/branding/muzammil_autos_logo.png';

  /// Splash screen display duration.
  static const Duration splashDuration = Duration(seconds: 2);

  /// Default locale.
  static const String defaultLanguage = 'en';
}
