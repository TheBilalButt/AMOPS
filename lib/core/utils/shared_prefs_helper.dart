/// ================================================
/// File    : shared_prefs_helper.dart
/// Module  : Core
/// Desc    : Shared Preferences helper for session and settings
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String keyIsDataSeeded = "is_data_seeded";
  static const String keyUserUid = "user_uid";
  static const String keyUserRole = "user_role";
  
  // Thresholds
  static const String keyBatteryThreshold = "battery_threshold";
  static const String keyFuelThreshold = "fuel_threshold";
  static const String keyAmmoThreshold = "ammo_threshold";
  
  // Notification Toggles
  static const String keyAlertNotifications = "alert_notifications";
  static const String keyMaintenanceNotifications = "maint_notifications";
  static const String keySupplyNotifications = "supply_notifications";
  static const String keyThreatNotifications = "threat_notifications";

  static Future<void> setDataSeeded(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsDataSeeded, value);
  }

  static Future<bool> isDataSeeded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsDataSeeded) ?? false;
  }

  static Future<void> saveUserSession(String uid, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUserUid, uid);
    await prefs.setString(keyUserRole, role);
  }

  static Future<String?> getUserUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUserUid);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyUserUid);
    await prefs.remove(keyUserRole);
  }

  static Future<void> setThreshold(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  static Future<double> getThreshold(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key) ?? 20.0; // Default 20%
  }

  static Future<void> setNotificationToggle(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool> getNotificationToggle(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? true;
  }
}
