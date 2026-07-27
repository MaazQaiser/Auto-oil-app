import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/schema_registry.dart';

/// Workshop owner profile and synced app settings.
class UserProfile extends Equatable {
  const UserProfile({
    required this.uid,
    required this.schemaVersion,
    required this.accountStatus,
    required this.email,
    required this.displayName,
    this.phone,
    required this.workshopName,
    this.workshopTagline,
    this.workshopAddress,
    this.workshopPhone,
    this.workshopEmail,
    this.workshopLogoUrl,
    this.countryCode,
    required this.timezone,
    required this.invoiceTaxPercent,
    required this.invoiceCurrency,
    required this.invoiceCurrencySymbol,
    required this.invoicePrefix,
    required this.invoiceNextNumber,
    required this.themeMode,
    required this.language,
    required this.notificationsEnabled,
    required this.dailyReminderHour,
    required this.dailyReminderMinute,
    required this.weeklySummaryEnabled,
    required this.monthlySummaryEnabled,
    required this.whatsappShortcutEnabled,
    this.defaultMessageTemplateId,
    this.extraJson,
    required this.createdAt,
    required this.updatedAt,
  });

  final String uid;
  final int schemaVersion;
  final String accountStatus;
  final String email;
  final String displayName;
  final String? phone;
  final String workshopName;
  final String? workshopTagline;
  final String? workshopAddress;
  final String? workshopPhone;
  final String? workshopEmail;
  final String? workshopLogoUrl;
  final String? countryCode;
  final String timezone;
  final double invoiceTaxPercent;
  final String invoiceCurrency;
  final String invoiceCurrencySymbol;
  final String invoicePrefix;
  final int invoiceNextNumber;
  final String themeMode;
  final String language;
  final bool notificationsEnabled;
  final int dailyReminderHour;
  final int dailyReminderMinute;
  final bool weeklySummaryEnabled;
  final bool monthlySummaryEnabled;
  final bool whatsappShortcutEnabled;
  final String? defaultMessageTemplateId;
  final String? extraJson;
  final DateTime createdAt;
  final DateTime updatedAt;

  ThemeMode get themeModeValue => switch (themeMode) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  Map<String, dynamic> get extraFields {
    if (extraJson == null || extraJson!.trim().isEmpty) return {};
    try {
      final decoded = jsonDecode(extraJson!);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {}
    return {};
  }

  factory UserProfile.defaults({
    required String uid,
    required String email,
    String? displayName,
  }) {
    final DateTime now = DateTime.now().toUtc();
    return UserProfile(
      uid: uid,
      schemaVersion: UserProfileSchema.version,
      accountStatus: AccountStatus.active,
      email: email,
      displayName: displayName?.isNotEmpty == true
          ? displayName!
          : AppConfig.workshopName,
      workshopName: AppConfig.workshopName,
      workshopTagline: AppConfig.workshopTagline,
      timezone: 'Asia/Karachi',
      invoiceTaxPercent: 0,
      invoiceCurrency: AppConstants.defaultCurrencyCode,
      invoiceCurrencySymbol: AppConstants.defaultCurrencySymbol,
      invoicePrefix: 'INV',
      invoiceNextNumber: 1,
      themeMode: 'system',
      language: AppConfig.defaultLanguage,
      notificationsEnabled: true,
      dailyReminderHour: 8,
      dailyReminderMinute: 0,
      weeklySummaryEnabled: true,
      monthlySummaryEnabled: true,
      whatsappShortcutEnabled: true,
      createdAt: now,
      updatedAt: now,
    );
  }

  UserProfile copyWith({
    int? schemaVersion,
    String? accountStatus,
    String? email,
    String? displayName,
    String? phone,
    String? workshopName,
    String? workshopTagline,
    String? workshopAddress,
    String? workshopPhone,
    String? workshopEmail,
    String? workshopLogoUrl,
    String? countryCode,
    String? timezone,
    double? invoiceTaxPercent,
    String? invoiceCurrency,
    String? invoiceCurrencySymbol,
    String? invoicePrefix,
    int? invoiceNextNumber,
    String? themeMode,
    String? language,
    bool? notificationsEnabled,
    int? dailyReminderHour,
    int? dailyReminderMinute,
    bool? weeklySummaryEnabled,
    bool? monthlySummaryEnabled,
    bool? whatsappShortcutEnabled,
    String? defaultMessageTemplateId,
    bool clearDefaultMessageTemplateId = false,
    String? extraJson,
    bool clearExtraJson = false,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      accountStatus: accountStatus ?? this.accountStatus,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phone: phone ?? this.phone,
      workshopName: workshopName ?? this.workshopName,
      workshopTagline: workshopTagline ?? this.workshopTagline,
      workshopAddress: workshopAddress ?? this.workshopAddress,
      workshopPhone: workshopPhone ?? this.workshopPhone,
      workshopEmail: workshopEmail ?? this.workshopEmail,
      workshopLogoUrl: workshopLogoUrl ?? this.workshopLogoUrl,
      countryCode: countryCode ?? this.countryCode,
      timezone: timezone ?? this.timezone,
      invoiceTaxPercent: invoiceTaxPercent ?? this.invoiceTaxPercent,
      invoiceCurrency: invoiceCurrency ?? this.invoiceCurrency,
      invoiceCurrencySymbol:
          invoiceCurrencySymbol ?? this.invoiceCurrencySymbol,
      invoicePrefix: invoicePrefix ?? this.invoicePrefix,
      invoiceNextNumber: invoiceNextNumber ?? this.invoiceNextNumber,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
      dailyReminderHour: dailyReminderHour ?? this.dailyReminderHour,
      dailyReminderMinute: dailyReminderMinute ?? this.dailyReminderMinute,
      weeklySummaryEnabled:
          weeklySummaryEnabled ?? this.weeklySummaryEnabled,
      monthlySummaryEnabled:
          monthlySummaryEnabled ?? this.monthlySummaryEnabled,
      whatsappShortcutEnabled:
          whatsappShortcutEnabled ?? this.whatsappShortcutEnabled,
      defaultMessageTemplateId: clearDefaultMessageTemplateId
          ? null
          : (defaultMessageTemplateId ?? this.defaultMessageTemplateId),
      extraJson: clearExtraJson ? null : (extraJson ?? this.extraJson),
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    final map = <String, dynamic>{
      'uid': uid,
      'schemaVersion': schemaVersion,
      'accountStatus': accountStatus,
      'email': email,
      'displayName': displayName,
      'phone': phone,
      'workshopName': workshopName,
      'workshopTagline': workshopTagline,
      'workshopAddress': workshopAddress,
      'workshopPhone': workshopPhone,
      'workshopEmail': workshopEmail,
      'workshopLogoUrl': workshopLogoUrl,
      'countryCode': countryCode,
      'timezone': timezone,
      'invoiceTaxPercent': invoiceTaxPercent,
      'invoiceCurrency': invoiceCurrency,
      'invoiceCurrencySymbol': invoiceCurrencySymbol,
      'invoicePrefix': invoicePrefix,
      'invoiceNextNumber': invoiceNextNumber,
      'themeMode': themeMode,
      'language': language,
      'notificationsEnabled': notificationsEnabled,
      'dailyReminderHour': dailyReminderHour,
      'dailyReminderMinute': dailyReminderMinute,
      'weeklySummaryEnabled': weeklySummaryEnabled,
      'monthlySummaryEnabled': monthlySummaryEnabled,
      'whatsappShortcutEnabled': whatsappShortcutEnabled,
      'defaultMessageTemplateId': defaultMessageTemplateId,
      'extraJson': extraJson,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };
    map.removeWhere((_, value) => value == null);
    return map;
  }

  factory UserProfile.fromFirestoreMap(Map<String, dynamic> m) {
    DateTime parseDate(dynamic value, {DateTime? fallback}) {
      if (value == null) {
        return fallback ?? DateTime.now().toUtc();
      }
      if (value is DateTime) return value.toUtc();
      if (value is String) {
        return DateTime.tryParse(value)?.toUtc() ??
            (fallback ?? DateTime.now().toUtc());
      }
      try {
        final dynamic seconds = value.seconds;
        if (seconds is int) {
          return DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);
        }
      } catch (_) {}
      return fallback ?? DateTime.now().toUtc();
    }

    final int remoteSchema = m['schemaVersion'] as int? ?? 1;
    final knownKeys = {...UserProfileSchema.v1Fields, 'ownerUid', 'syncedAt'};
    final unknown = <String, dynamic>{};
    for (final entry in m.entries) {
      if (!knownKeys.contains(entry.key)) {
        unknown[entry.key] = entry.value;
      }
    }

    String? mergedExtraJson = m['extraJson'] as String?;
    if (unknown.isNotEmpty) {
      Map<String, dynamic> base = {};
      if (mergedExtraJson != null && mergedExtraJson.isNotEmpty) {
        try {
          final decoded = jsonDecode(mergedExtraJson);
          if (decoded is Map) {
            base = Map<String, dynamic>.from(decoded);
          }
        } catch (_) {}
      }
      base.addAll(unknown);
      mergedExtraJson = jsonEncode(base);
    }

    return UserProfile(
      uid: m['uid'] as String,
      schemaVersion: remoteSchema,
      accountStatus: m['accountStatus'] as String? ?? AccountStatus.active,
      email: m['email'] as String? ?? '',
      displayName: m['displayName'] as String? ?? 'Owner',
      phone: m['phone'] as String?,
      workshopName: m['workshopName'] as String? ?? AppConfig.workshopName,
      workshopTagline: m['workshopTagline'] as String?,
      workshopAddress: m['workshopAddress'] as String?,
      workshopPhone: m['workshopPhone'] as String?,
      workshopEmail: m['workshopEmail'] as String?,
      workshopLogoUrl: m['workshopLogoUrl'] as String?,
      countryCode: m['countryCode'] as String?,
      timezone: m['timezone'] as String? ?? 'Asia/Karachi',
      invoiceTaxPercent: (m['invoiceTaxPercent'] as num?)?.toDouble() ?? 0,
      invoiceCurrency:
          m['invoiceCurrency'] as String? ?? AppConstants.defaultCurrencyCode,
      invoiceCurrencySymbol: m['invoiceCurrencySymbol'] as String? ??
          AppConstants.defaultCurrencySymbol,
      invoicePrefix: m['invoicePrefix'] as String? ?? 'INV',
      invoiceNextNumber: m['invoiceNextNumber'] as int? ?? 1,
      themeMode: m['themeMode'] as String? ?? 'system',
      language: m['language'] as String? ?? AppConfig.defaultLanguage,
      notificationsEnabled: m['notificationsEnabled'] as bool? ?? true,
      dailyReminderHour: m['dailyReminderHour'] as int? ?? 8,
      dailyReminderMinute: m['dailyReminderMinute'] as int? ?? 0,
      weeklySummaryEnabled: m['weeklySummaryEnabled'] as bool? ?? true,
      monthlySummaryEnabled: m['monthlySummaryEnabled'] as bool? ?? true,
      whatsappShortcutEnabled: m['whatsappShortcutEnabled'] as bool? ?? true,
      defaultMessageTemplateId: m['defaultMessageTemplateId'] as String?,
      extraJson: mergedExtraJson,
      createdAt: parseDate(m['createdAt']),
      updatedAt: parseDate(m['updatedAt']),
    );
  }

  @override
  List<Object?> get props => [uid, updatedAt, schemaVersion];
}
