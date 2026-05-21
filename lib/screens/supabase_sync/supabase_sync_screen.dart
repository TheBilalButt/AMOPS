import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/supabase_provider.dart';
import '../../widgets/lottie_anim.dart';

class SupabaseSyncScreen extends ConsumerWidget {
  const SupabaseSyncScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supabaseState = ref.watch(supabaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Supabase Operations Hub"),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.background.withOpacity(0.95),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Sync Card with glassmorphic style & live Lottie scanning radar animation
              Card(
                color: AppColors.card.withOpacity(0.85),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: AppColors.primary.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Cool Spinning Radar scan representation (Lottie + beautiful fallbacks)
                      Hero(
                        tag: 'supabase_sync_logo',
                        child: TechLottie(
                          url: 'https://assets5.lottiefiles.com/packages/lf20_wprbpf4c.json', // Premium security shield
                          size: 150,
                          fallback: null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        supabaseState.isSyncing
                            ? "SYNCHRONIZING DATABASES..."
                            : "SUPABASE BACKEND STREAM: SECURED",
                        style: TextStyle(
                          color: supabaseState.isSyncing
                              ? Colors.amber
                              : AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Dual backend active: Cloud Firestore replication with live Supabase Audit logging.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Glowing Sync Button
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: supabaseState.isSyncing
                              ? null
                              : () => ref.read(supabaseProvider.notifier).syncDatabase(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: supabaseState.isSyncing
                                ? Colors.amber.withOpacity(0.2)
                                : AppColors.primary,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: supabaseState.isSyncing
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                              : const Icon(Icons.sync_alt, color: Colors.black),
                          label: Text(
                            supabaseState.isSyncing
                                ? "UPDATING STREAMS..."
                                : "FORCE SUPABASE METRIC SYNC",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Header for Audit Log Stream
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Supabase Live Audit Stream",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                    onPressed: () => _showAddLogDialog(context, ref),
                    tooltip: "Trigger Custom Audit Log",
                  )
                ],
              ),
              const SizedBox(height: 12),

              // Dynamic List of Audit Logs
              Expanded(
                child: supabaseState.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: supabaseState.logs.length,
                        itemBuilder: (context, index) {
                          final log = supabaseState.logs[index];
                          return AnimatedOpacity(
                            opacity: 1.0,
                            duration: Duration(milliseconds: 300 + (index * 100)),
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              color: AppColors.card.withOpacity(0.6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Colors.white.withOpacity(0.05),
                                  width: 1,
                                ),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: _getModuleColor(log.module).withOpacity(0.15),
                                  child: Icon(
                                    _getModuleIcon(log.module),
                                    color: _getModuleColor(log.module),
                                  ),
                                ),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      log.action,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      "${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}",
                                      style: const TextStyle(
                                        color: Colors.white30,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    log.details,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getModuleColor(log.module).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: _getModuleColor(log.module).withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    log.module,
                                    style: TextStyle(
                                      color: _getModuleColor(log.module),
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getModuleColor(String module) {
    switch (module.toUpperCase()) {
      case 'FLEET':
        return AppColors.primary;
      case 'THREATS':
        return AppColors.danger;
      case 'LOGISTICS':
        return Colors.blue;
      case 'SECURITY':
        return AppColors.success;
      default:
        return Colors.purpleAccent;
    }
  }

  IconData _getModuleIcon(String module) {
    switch (module.toUpperCase()) {
      case 'FLEET':
        return Icons.airplanemode_active;
      case 'THREATS':
        return Icons.warning_amber;
      case 'LOGISTICS':
        return Icons.local_shipping;
      case 'SECURITY':
        return Icons.lock_outline;
      default:
        return Icons.settings_input_component;
    }
  }

  void _showAddLogDialog(BuildContext context, WidgetRef ref) {
    final actionController = TextEditingController();
    final detailsController = TextEditingController();
    String selectedModule = 'FLEET';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.card,
              title: const Text(
                "Trigger Custom Supabase Audit",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: actionController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Audit Action Label",
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: detailsController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Detailed Description",
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedModule,
                      dropdownColor: AppColors.card,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Target Module",
                        labelStyle: TextStyle(color: AppColors.textSecondary),
                      ),
                      items: ['FLEET', 'THREATS', 'LOGISTICS', 'SECURITY', 'SYSTEM'].map((m) {
                        return DropdownMenuItem(value: m, child: Text(m));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            selectedModule = val;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("CANCEL", style: TextStyle(color: Colors.white54)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: () {
                    final action = actionController.text.trim();
                    final details = detailsController.text.trim();
                    if (action.isNotEmpty && details.isNotEmpty) {
                      ref.read(supabaseProvider.notifier).addCustomLog(
                        action.toUpperCase(),
                        details,
                        selectedModule,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Audit logged directly via Supabase!"),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  },
                  child: const Text("LOG EVENT", style: TextStyle(color: Colors.black)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
