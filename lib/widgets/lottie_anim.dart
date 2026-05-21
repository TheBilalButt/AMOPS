import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../core/constants/app_colors.dart';

class TechLottie extends StatefulWidget {
  final String url;
  final double size;
  final Widget? fallback;

  const TechLottie({
    super.key,
    required this.url,
    this.size = 180.0,
    this.fallback,
  });

  @override
  State<TechLottie> createState() => _TechLottieState();
}

class _TechLottieState extends State<TechLottie> with SingleTickerProviderStateMixin {
  late AnimationController _scannerController;

  @override
  void initState() {
    super.initState();
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: Lottie.network(
        widget.url,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return widget.fallback ?? _buildDefaultFallback();
        },
      ),
    );
  }

  Widget _buildDefaultFallback() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
        strokeWidth: 3,
      ),
    );
  }
}
