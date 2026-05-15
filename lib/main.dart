/// ================================================
/// File    : main.dart
/// Module  : App
/// Desc    : Main entry point for AMOPS application
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    const ProviderScope(
      child: AmopsApp(),
    ),
  );
}
