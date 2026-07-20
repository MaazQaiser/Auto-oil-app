/// Non-UI application constants.
class AppConstants {
  const AppConstants._();

  static const String preferencesBox = 'autocare_prefs';

  // Preference keys
  static const String themeModeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String notificationsEnabledKey = 'notifications_enabled';
  static const String dailyReminderHourKey = 'daily_reminder_hour';
  static const String dailyReminderMinuteKey = 'daily_reminder_minute';
  static const String weeklySummaryEnabledKey = 'weekly_summary_enabled';
  static const String monthlySummaryEnabledKey = 'monthly_summary_enabled';
  static const String whatsappShortcutEnabledKey = 'whatsapp_shortcut_enabled';
  static const String defaultMessageTemplateIdKey =
      'default_message_template_id';

  // Invoice settings
  static const String workshopAddressKey = 'workshop_address';
  static const String workshopPhoneKey = 'workshop_phone';
  static const String invoiceTaxPercentKey = 'invoice_tax_percent';
  static const String invoiceCurrencyKey = 'invoice_currency';
  static const String invoiceCurrencySymbolKey = 'invoice_currency_symbol';
  static const String invoicePrefixKey = 'invoice_prefix';
  static const String invoiceNextNumberKey = 'invoice_next_number';
  static const String workshopDisplayNameKey = 'workshop_display_name';

  // User profile
  static const String userNameKey = 'user_name';
  static const String userEmailKey = 'user_email';
  static const String userPhoneKey = 'user_phone';
  static const String userPasswordKey = 'user_password';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 100;
  static const int maxNotesLength = 1000;

  // Currency
  static const String defaultCurrencySymbol = '\$';
  static const String defaultCurrencyCode = 'USD';

  // Date formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String dateTimeFormat = 'MMM dd, yyyy · hh:mm a';
  static const String timeFormat = 'hh:mm a';
}
