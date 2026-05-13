// =============================================================================
// File: main.dart
// Module: App Entry Point
// Description: Main entry point for the AMOPS Flutter application.
//              Initializes the app with Riverpod ProviderScope.
// Author: AMOPS Development Team
// Date: 2026-05-13
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';

/// Main entry point for the AMOPS application.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: AmopsApp(),
    ),
  );
}
