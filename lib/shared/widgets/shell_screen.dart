// =============================================================================
// File: shell_screen.dart
// Module: Shared / Widgets
// Description: Main scaffold with bottom navigation bar and side drawer.
//              Wraps all main screens with consistent navigation.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

/// Main shell screen providing bottom navigation and side drawer.
class ShellScreen extends StatelessWidget {
  final Widget child;

  const ShellScreen({super.key, required this.child});

  /// Returns the current navigation index based on the route location.
  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/drones') || location.startsWith('/vehicles')) return 1;
    if (location.startsWith('/threats')) return 2;
    if (location.startsWith('/logistics')) return 3;
    return 4; // More
  }

  /// Navigates to the appropriate route based on bottom nav index.
  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0: context.go('/dashboard'); break;
      case 1: context.go('/drones'); break;
      case 2: context.go('/threats'); break;
      case 3: context.go('/logistics'); break;
      case 4: Scaffold.of(context).openDrawer(); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      drawer: _buildDrawer(context),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  /// Builds the bottom navigation bar with 5 items.
  Widget _buildBottomNav(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex > 4 ? 4 : currentIndex,
        onTap: (index) => _onNavTap(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            activeIcon: Icon(Icons.dashboard_rounded),
            label: AppStrings.navDashboard,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rocket_launch_rounded),
            activeIcon: Icon(Icons.rocket_launch_rounded),
            label: AppStrings.navFleet,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield_rounded),
            activeIcon: Icon(Icons.shield_rounded),
            label: AppStrings.navThreats,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_rounded),
            activeIcon: Icon(Icons.inventory_2_rounded),
            label: AppStrings.navLogistics,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_rounded),
            activeIcon: Icon(Icons.menu_rounded),
            label: AppStrings.navMore,
          ),
        ],
      ),
    );
  }

  /// Builds the side drawer with secondary navigation items.
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Drawer header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: AppColors.militaryGradient,
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
                    ),
                    child: const Icon(Icons.security, color: AppColors.accent, size: 28),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppStrings.appName,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Text(
                    'Command Center',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            // Navigation items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _drawerItem(context, Icons.build_rounded, AppStrings.navMaintenance, '/maintenance'),
                  _drawerItem(context, Icons.precision_manufacturing_rounded, AppStrings.navManufacturing, '/manufacturing'),
                  _drawerItem(context, Icons.trending_up_rounded, AppStrings.navSales, '/sales'),
                  const Divider(indent: 16, endIndent: 16),
                  _drawerItem(context, Icons.smart_toy_rounded, AppStrings.navAiAssistant, '/ai-assistant'),
                  _drawerItem(context, Icons.settings_rounded, AppStrings.navSettings, '/settings'),
                ],
              ),
            ),
            // Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'v${AppStrings.appVersion} • ${AppStrings.organization1}',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Creates a single drawer navigation item.
  Widget _drawerItem(BuildContext context, IconData icon, String label, String route) {
    final isActive = GoRouterState.of(context).uri.toString().startsWith(route);
    return ListTile(
      leading: Icon(icon, color: isActive ? AppColors.accent : AppColors.textSecondary, size: 22),
      title: Text(
        label,
        style: TextStyle(
          color: isActive ? AppColors.accent : AppColors.textPrimary,
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          fontSize: 14,
        ),
      ),
      selected: isActive,
      selectedTileColor: AppColors.accent.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      onTap: () {
        Navigator.pop(context); // Close drawer
        context.go(route);
      },
    );
  }
}
