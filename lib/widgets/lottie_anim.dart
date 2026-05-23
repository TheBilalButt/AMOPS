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
      child: AnimatedBuilder(
        animation: _scannerController,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Circular radar backdrop
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 2,
                  ),
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              // Crosshairs
              Container(
                width: widget.size * 0.8,
                height: 1.5,
                color: AppColors.primary.withOpacity(0.2),
              ),
              Container(
                width: 1.5,
                height: widget.size * 0.8,
                color: AppColors.primary.withOpacity(0.2),
              ),
              // Outer spinning border
              RotationTransition(
                turns: _scannerController,
                child: Container(
                  width: widget.size * 0.9,
                  height: widget.size * 0.9,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(BorderSide.none),
                  ),
                  child: CircularProgressIndicator(
                    value: 0.35,
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary.withOpacity(0.8)),
                  ),
                ),
              ),
              // Moving scanner bar (Moving target scanner)
              Positioned(
                top: widget.size * 0.1 + (_scannerController.value * widget.size * 0.8),
                left: widget.size * 0.1,
                right: widget.size * 0.1,
                child: Container(
                  height: 3,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              // Glowing pulse target core dot
              ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.2).animate(
                  CurvedAnimation(parent: _scannerController, curve: Curves.easeInOut),
                ),
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary,
                        blurRadius: 12,
                        spreadRadius: 3,
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
