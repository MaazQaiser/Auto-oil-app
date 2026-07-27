import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

/// Login-only persistence — session hints, not business data.
class AuthPreferences {
  AuthPreferences(this._prefs);

  final SharedPreferences _prefs;

  static Future<AuthPreferences> create() async {
    final prefs = await SharedPreferences.getInstance();
    return AuthPreferences(prefs);
  }

  String? get lastLoginEmail =>
      _prefs.getString(AppConstants.lastLoginEmailKey);

  Future<void> setLastLoginEmail(String email) async {
    await _prefs.setString(AppConstants.lastLoginEmailKey, email.trim());
  }

  String? get activeUid => _prefs.getString(AppConstants.activeUidKey);

  Future<void> setActiveUid(String? uid) async {
    if (uid == null || uid.isEmpty) {
      await _prefs.remove(AppConstants.activeUidKey);
    } else {
      await _prefs.setString(AppConstants.activeUidKey, uid);
    }
  }
}
