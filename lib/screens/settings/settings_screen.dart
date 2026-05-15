/// ================================================
/// File    : settings_screen.dart
/// Module  : Settings
/// Desc    : App configuration and user profile
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/shared_prefs_helper.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final settings = ref.watch(settingsProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            if (user != null)
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Text(user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U', style: const TextStyle(color: Colors.black)),
                  ),
                  title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${user.role} | ${user.email}"),
                ),
              ),
            
            const SizedBox(height: 32),
            const Text("Alert Thresholds (%)", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            const Divider(color: Colors.white10),
            _buildSlider(
              context, 
              ref, 
              "Drone Battery Threshold", 
              settings.batteryThreshold, 
              SharedPrefsHelper.keyBatteryThreshold
            ),
            _buildSlider(
              context, 
              ref, 
              "Vehicle Fuel Threshold", 
              settings.fuelThreshold, 
              SharedPrefsHelper.keyFuelThreshold
            ),
            _buildSlider(
              context, 
              ref, 
              "Ammo Reserve Threshold", 
              settings.ammoThreshold, 
              SharedPrefsHelper.keyAmmoThreshold
            ),

            const SizedBox(height: 32),
            const Text("Operational Notifications", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            const Divider(color: Colors.white10),
            _buildToggle(ref, "Critical System Alerts", settings.criticalAlerts, SharedPrefsHelper.keyAlertNotifications),
            _buildToggle(ref, "Maintenance Reminders", settings.maintenanceAlerts, SharedPrefsHelper.keyMaintenanceNotifications),
            _buildToggle(ref, "Supply Chain Alerts", settings.supplyAlerts, SharedPrefsHelper.keySupplyNotifications),
            _buildToggle(ref, "Threat Detection Alerts", settings.threatAlerts, SharedPrefsHelper.keyThreatNotifications),

            const SizedBox(height: 32),
            const Text("App Information", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            const Divider(color: Colors.white10),
            const ListTile(
              title: Text("Organization"),
              subtitle: Text(AppStrings.organization),
            ),
            const ListTile(
              title: Text("Version"),
              subtitle: Text("1.0.0 (Production Build)"),
            ),

            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showLogoutDialog(context, ref),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: Colors.white),
                child: const Text("LOGOUT SYSTEM"),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(BuildContext context, WidgetRef ref, String label, double value, String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 14)),
              Text("${value.toInt()}%", style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Slider(
          value: value,
          min: 0,
          max: 100,
          activeColor: AppColors.primary,
          inactiveColor: Colors.white10,
          onChanged: (val) => ref.read(settingsProvider.notifier).updateThreshold(key, val),
        ),
      ],
    );
  }

  Widget _buildToggle(WidgetRef ref, String label, bool value, String key) {
    return SwitchListTile(
      title: Text(label, style: const TextStyle(fontSize: 14)),
      value: value,
      activeColor: AppColors.primary,
      onChanged: (val) => ref.read(settingsProvider.notifier).updateToggle(key, val),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout and clear operational session?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
