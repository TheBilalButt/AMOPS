/// ================================================
/// File    : app.dart
/// Module  : App
/// Desc    : Application shell and root configuration
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_theme.dart';
import '../core/constants/app_strings.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/fleet/fleet_screen.dart';
import '../screens/threats/threat_screen.dart';
import '../screens/logistics/logistics_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/maintenance/maintenance_screen.dart';
import '../screens/manufacturing/manufacturing_screen.dart';
import '../screens/sales/sales_screen.dart';
import '../screens/ai_assistant/ai_assistant_screen.dart';
import '../providers/dashboard_provider.dart';
import '../core/constants/app_colors.dart';
import '../widgets/loading_widget.dart';
import '../screens/supabase_sync/supabase_sync_screen.dart';

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

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const FleetScreen(),
    const ThreatScreen(),
    const LogisticsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Listen to dashboard provider for seeding logic
    ref.listen(dashboardProvider, (previous, next) {
      if (next.isSeeding) {
        // Show seeding indicator if needed
      }
    });

    return Scaffold(
      drawer: const AppDrawer(),
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
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColors.card),
            accountName: Text(user?.name ?? "User", style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            accountEmail: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user?.email ?? "", style: const TextStyle(color: Colors.white60)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Text(
                    user?.role ?? "Guest",
                    style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Text(user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : "U", style: const TextStyle(color: Colors.black)),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(context, Icons.build, AppStrings.maintenance, const MaintenanceScreen()),
                if (user?.role == 'Base Commander') ...[
                  _buildDrawerItem(context, Icons.factory, AppStrings.manufacturing, const ManufacturingScreen()),
                  _buildDrawerItem(context, Icons.trending_up, AppStrings.sales, const SalesScreen()),
                ],
                _buildDrawerItem(context, Icons.psychology, AppStrings.aiAssistant, const AIAssistantScreen()),
                if (user?.role == 'Base Commander' || user?.role == 'Fleet Operator')
                  _buildDrawerItem(context, Icons.sync_alt, "Supabase Sync Hub", const SupabaseSyncScreen()),
              ],
            ),
          ),
          const Divider(color: Colors.white10, height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.danger),
            title: const Text(AppStrings.logout, style: TextStyle(color: AppColors.danger)),
            onTap: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).logout();
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, Widget screen) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
    );
  }
}
