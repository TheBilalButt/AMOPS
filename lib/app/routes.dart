// =============================================================================
// File: routes.dart
// Module: App
// Description: GoRouter configuration with all application routes.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../modules/dashboard/dashboard_screen.dart';
import '../modules/drone_control/drone_list_screen.dart';
import '../modules/drone_control/drone_detail_screen.dart';
import '../modules/tank_fleet/vehicle_list_screen.dart';
import '../modules/tank_fleet/vehicle_detail_screen.dart';
import '../modules/threat_intel/threat_screen.dart';
import '../modules/logistics/logistics_screen.dart';
import '../modules/maintenance/maintenance_screen.dart';
import '../modules/manufacturing/manufacturing_screen.dart';
import '../modules/sales/sales_screen.dart';
import '../modules/ai_assistant/ai_assistant_screen.dart';
import '../modules/settings/settings_screen.dart';
import '../shared/widgets/shell_screen.dart';

/// App routing configuration using GoRouter with ShellRoute for bottom nav.
class AppRoutes {
  AppRoutes._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  /// The GoRouter instance for the entire application.
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/dashboard',
    routes: [
      // Shell route wraps screens that show bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardScreen(),
            ),
          ),
          GoRoute(
            path: '/drones',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DroneListScreen(),
            ),
          ),
          GoRoute(
            path: '/vehicles',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: VehicleListScreen(),
            ),
          ),
          GoRoute(
            path: '/threats',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ThreatScreen(),
            ),
          ),
          GoRoute(
            path: '/logistics',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: LogisticsScreen(),
            ),
          ),
          GoRoute(
            path: '/maintenance',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MaintenanceScreen(),
            ),
          ),
          GoRoute(
            path: '/manufacturing',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ManufacturingScreen(),
            ),
          ),
          GoRoute(
            path: '/sales',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SalesScreen(),
            ),
          ),
          GoRoute(
            path: '/ai-assistant',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AiAssistantScreen(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),
      // Full-screen routes (no bottom nav)
      GoRoute(
        path: '/drone/:id',
        builder: (context, state) => DroneDetailScreen(
          droneId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/vehicle/:id',
        builder: (context, state) => VehicleDetailScreen(
          vehicleId: state.pathParameters['id']!,
        ),
      ),
    ],
  );
}
