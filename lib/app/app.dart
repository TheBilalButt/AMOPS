// =============================================================================
// File: app.dart
// Module: App
// Description: Root application widget with ProviderScope and GoRouter.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import 'package:flutter/material.dart';

import '../shared/theme/app_theme.dart';
import '../core/constants/app_strings.dart';
import 'routes.dart';

/// Root widget for the AMOPS application.
/// Wraps the app in ProviderScope and configures theming + routing.
class AmopsApp extends StatelessWidget {
  const AmopsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: AppRoutes.router,
    );
  }
}
