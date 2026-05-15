/// ================================================
/// File    : app.dart
/// Module  : App
/// Desc    : Application shell and root configuration
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_theme.dart';
import '../core/constants/app_strings.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../widgets/loading_widget.dart';
import 'routes.dart';

class AmopsApp extends ConsumerWidget {
  const AmopsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: AppStrings.appName,
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: authState.isLoading 
          ? const Scaffold(body: LoadingWidget(message: "Checking session..."))
          : authState.user != null 
              ? const MainShell() // We'll define this in routes or a new file
              : const LoginScreen(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const Center(child: Text("Fleet")),
    const Center(child: Text("Threats")),
    const Center(child: Text("Logistics")),
    const Center(child: Text("More")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.airplanemode_active), label: "Fleet"),
          BottomNavigationBarItem(icon: Icon(Icons.warning_amber), label: "Threats"),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Logistics"),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "More"),
        ],
      ),
    );
  }
}
