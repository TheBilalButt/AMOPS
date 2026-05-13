// =============================================================================
// File: settings_screen.dart
// Module: Settings
// Description: Settings and profile screen with notification preferences,
//              alert thresholds, and about section.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/providers.dart';
import '../../shared/widgets/military_card.dart';

/// Settings screen with profile, notifications, thresholds, and about info.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: Row(children: [
        Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppColors.textSecondary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.settings, color: AppColors.textSecondary, size: 20)),
        const SizedBox(width: 10),
        const Text(AppStrings.settingsTitle),
      ])),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // User Profile
        MilitaryCard(
          gradient: AppColors.militaryGradient,
          child: Row(children: [
            Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.5), width: 2),
              ),
              child: const Icon(Icons.military_tech, color: AppColors.accent, size: 32),
            ),
            const SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Brig. Gen. Asad Khan', style: Theme.of(context).textTheme.headlineMedium),
              Text('Commander, AMOPS Division', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
                child: Text('TOP SECRET CLEARANCE', style: TextStyle(color: AppColors.accent, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1)),
              ),
            ]),
          ]),
        ),
        const SizedBox(height: 20),
        // Notification Preferences
        _sectionLabel(context, AppStrings.notificationPrefs),
        const SizedBox(height: 8),
        MilitaryCard(child: Column(children: [
          _switchTile(context, 'Push Notifications', settings.notificationsEnabled, (v) => ref.read(settingsProvider.notifier).toggleNotifications(v)),
          const Divider(color: AppColors.border, height: 1),
          _switchTile(context, 'Critical Alerts', settings.criticalAlertsEnabled, (v) => ref.read(settingsProvider.notifier).toggleCriticalAlerts(v)),
          const Divider(color: AppColors.border, height: 1),
          _switchTile(context, 'Maintenance Alerts', settings.maintenanceAlertsEnabled, (v) => ref.read(settingsProvider.notifier).toggleMaintenanceAlerts(v)),
        ])),
        const SizedBox(height: 20),
        // Alert Thresholds
        _sectionLabel(context, AppStrings.alertThresholds),
        const SizedBox(height: 8),
        MilitaryCard(child: Column(children: [
          _sliderTile(context, 'Battery Alert (%)', settings.batteryThreshold, 5, 50, (v) => ref.read(settingsProvider.notifier).updateBatteryThreshold(v)),
          const Divider(color: AppColors.border, height: 1),
          _sliderTile(context, 'Fuel Alert (%)', settings.fuelThreshold, 10, 50, (v) => ref.read(settingsProvider.notifier).updateFuelThreshold(v)),
          const Divider(color: AppColors.border, height: 1),
          _sliderTile(context, 'Ammo Alert (%)', settings.ammoThreshold, 10, 50, (v) => ref.read(settingsProvider.notifier).updateAmmoThreshold(v)),
        ])),
        const SizedBox(height: 20),
        // Theme
        _sectionLabel(context, AppStrings.themeToggle),
        const SizedBox(height: 8),
        MilitaryCard(child: ListTile(
          leading: const Icon(Icons.dark_mode, color: AppColors.accent),
          title: Text('Dark Mode (Military)', style: Theme.of(context).textTheme.titleMedium),
          subtitle: Text('Active', style: Theme.of(context).textTheme.bodySmall),
          trailing: Switch(value: true, onChanged: (_) {}),
          contentPadding: EdgeInsets.zero,
        )),
        const SizedBox(height: 20),
        // About
        _sectionLabel(context, AppStrings.aboutAmops),
        const SizedBox(height: 8),
        MilitaryCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(AppStrings.appName, style: Theme.of(context).textTheme.headlineMedium),
          Text(AppStrings.appFullName, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text('Version ${AppStrings.appVersion}', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Text(AppStrings.appDescription, style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5)),
          const SizedBox(height: 8),
          Text('${AppStrings.organization1}\n${AppStrings.organization2}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.accent)),
        ])),
        const SizedBox(height: 20),
        // Logout
        SizedBox(width: double.infinity, child: ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.logout, color: AppColors.statusRed),
          label: Text(AppStrings.logout, style: TextStyle(color: AppColors.statusRed)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.statusRed.withValues(alpha: 0.1),
            side: BorderSide(color: AppColors.statusRed.withValues(alpha: 0.3)),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        )),
        const SizedBox(height: 32),
      ])),
    );
  }

  Widget _sectionLabel(BuildContext context, String label) {
    return Text(label.toUpperCase(), style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.textSecondary, letterSpacing: 1.5));
  }

  Widget _switchTile(BuildContext context, String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [
      Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
      Switch(value: value, onChanged: onChanged),
    ]));
  }

  Widget _sliderTile(BuildContext context, String title, double value, double min, double max, ValueChanged<double> onChanged) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const Spacer(),
        Text('${value.toStringAsFixed(0)}%', style: TextStyle(color: AppColors.accent, fontSize: 14, fontWeight: FontWeight.w700)),
      ]),
      Slider(value: value, min: min, max: max, divisions: (max - min).toInt(), onChanged: onChanged),
    ]));
  }
}
