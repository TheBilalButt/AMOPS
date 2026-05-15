/// ================================================
/// File    : signup_screen.dart
/// Module  : Auth
/// Desc    : User registration interface
/// Author  : AMOPS Dev Team
/// Date    : May 2026
/// ================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedRole = 'Field Operator';

  final List<String> _roles = [
    'Field Operator',
    'Base Commander',
    'Factory Manager',
    'Sales Director',
    'Executive'
  ];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.signup)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: AppStrings.fullName,
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: AppStrings.email,
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: AppStrings.password,
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: AppStrings.confirmPassword,
                prefixIcon: Icon(Icons.lock_reset),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(labelText: "Role"),
              items: _roles.map((role) {
                return DropdownMenuItem(value: role, child: Text(role));
              }).toList(),
              onChanged: (value) => setState(() => _selectedRole = value!),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: authState.isLoading
                  ? null
                  : () async {
                      if (_passwordController.text != _confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Passwords do not match")),
                        );
                        return;
                      }
                      final success = await ref.read(authProvider.notifier).signup(
                            _nameController.text.trim(),
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            _selectedRole,
                          );
                      if (success && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Registration successful! Please login.")),
                        );
                        Navigator.pop(context);
                      } else if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(authState.error ?? "Signup failed")),
                        );
                      }
                    },
              child: authState.isLoading
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text(AppStrings.register),
            ),
          ],
        ),
      ),
    );
  }
}
