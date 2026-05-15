/// ================================================
/// File    : settings_provider.dart
/// Module  : Providers
/// Desc    : Application settings state management
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/shared_prefs_helper.dart';

class SettingsState {
  final double batteryThreshold;
  final double fuelThreshold;
  final double ammoThreshold;
  final bool criticalAlerts;
  final bool maintenanceAlerts;
  final bool supplyAlerts;
  final bool threatAlerts;

  SettingsState({
    this.batteryThreshold = 20.0,
    this.fuelThreshold = 20.0,
    this.ammoThreshold = 20.0,
    this.criticalAlerts = true,
    this.maintenanceAlerts = true,
    this.supplyAlerts = true,
    this.threatAlerts = true,
  });

  SettingsState copyWith({
    double? batteryThreshold,
    double? fuelThreshold,
    double? ammoThreshold,
    bool? criticalAlerts,
    bool? maintenanceAlerts,
    bool? supplyAlerts,
    bool? threatAlerts,
  }) {
    return SettingsState(
      batteryThreshold: batteryThreshold ?? this.batteryThreshold,
      fuelThreshold: fuelThreshold ?? this.fuelThreshold,
      ammoThreshold: ammoThreshold ?? this.ammoThreshold,
      criticalAlerts: criticalAlerts ?? this.criticalAlerts,
      maintenanceAlerts: maintenanceAlerts ?? this.maintenanceAlerts,
      supplyAlerts: supplyAlerts ?? this.supplyAlerts,
      threatAlerts: threatAlerts ?? this.threatAlerts,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    state = state.copyWith(
      batteryThreshold: await SharedPrefsHelper.getThreshold(SharedPrefsHelper.keyBatteryThreshold),
      fuelThreshold: await SharedPrefsHelper.getThreshold(SharedPrefsHelper.keyFuelThreshold),
      ammoThreshold: await SharedPrefsHelper.getThreshold(SharedPrefsHelper.keyAmmoThreshold),
      criticalAlerts: await SharedPrefsHelper.getNotificationToggle(SharedPrefsHelper.keyAlertNotifications),
      maintenanceAlerts: await SharedPrefsHelper.getNotificationToggle(SharedPrefsHelper.keyMaintenanceNotifications),
      supplyAlerts: await SharedPrefsHelper.getNotificationToggle(SharedPrefsHelper.keySupplyNotifications),
      threatAlerts: await SharedPrefsHelper.getNotificationToggle(SharedPrefsHelper.keyThreatNotifications),
    );
  }

  Future<void> updateThreshold(String key, double value) async {
    await SharedPrefsHelper.setThreshold(key, value);
    if (key == SharedPrefsHelper.keyBatteryThreshold) state = state.copyWith(batteryThreshold: value);
    if (key == SharedPrefsHelper.keyFuelThreshold) state = state.copyWith(fuelThreshold: value);
    if (key == SharedPrefsHelper.keyAmmoThreshold) state = state.copyWith(ammoThreshold: value);
  }

  Future<void> updateToggle(String key, bool value) async {
    await SharedPrefsHelper.setNotificationToggle(key, value);
    if (key == SharedPrefsHelper.keyAlertNotifications) state = state.copyWith(criticalAlerts: value);
    if (key == SharedPrefsHelper.keyMaintenanceNotifications) state = state.copyWith(maintenanceAlerts: value);
    if (key == SharedPrefsHelper.keySupplyNotifications) state = state.copyWith(supplyAlerts: value);
    if (key == SharedPrefsHelper.keyThreatNotifications) state = state.copyWith(threatAlerts: value);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
