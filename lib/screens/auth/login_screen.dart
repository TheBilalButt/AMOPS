import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/lottie_anim.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.background.withOpacity(0.9),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'app_logo',
                  child: const TechLottie(
                    url: 'https://assets5.lottiefiles.com/packages/lf20_wprbpf4c.json', // Secure portal radar
                    size: 160,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  AppStrings.appName,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const Text(
                  "SECURE AUTHENTICATION PROTOCOL",
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12, letterSpacing: 1.5),
                ),
                const SizedBox(height: 50),
                
                if (authState.isLoading)
                  const Column(
                    children: [
                      CircularProgressIndicator(color: AppColors.primary),
                      SizedBox(height: 16),
                      Text("Authenticating role access...", style: TextStyle(color: AppColors.primary)),
                    ],
                  )
                else
                  Column(
                    children: [
                      const Text(
                        "SELECT OPERATIONS ROLE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildRoleCard(context, ref, "Base Commander", Icons.star, "Full administrative access"),
                      const SizedBox(height: 16),
                      _buildRoleCard(context, ref, "Logistics Officer", Icons.local_shipping, "Manage supplies and distribution"),
                      const SizedBox(height: 16),
                      _buildRoleCard(context, ref, "Fleet Operator", Icons.airplanemode_active, "Monitor drones and vehicles"),
                    ],
                  ),
                
                if (authState.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Text(
                      authState.error!,
                      style: const TextStyle(color: AppColors.danger),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, WidgetRef ref, String role, IconData icon, String desc) {
    return InkWell(
      onTap: () async {
        final success = await ref.read(authProvider.notifier).loginWithRole(role);
        if (!success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Authentication failed")),
          );
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ]
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: AppColors.primary, size: 16),
          ],
        ),
      ),
    );
  }
}
