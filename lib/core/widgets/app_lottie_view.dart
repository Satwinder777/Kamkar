import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import '../theme/app_colors.dart';

class AppLottieView extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final IconData fallbackIcon;
  final Color? fallbackColor;
  final bool repeat;

  const AppLottieView({
    super.key,
    required this.url,
    this.width = 140,
    this.height = 140,
    this.fallbackIcon = Icons.auto_awesome_rounded,
    this.fallbackColor,
    this.repeat = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Lottie.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.contain,
        repeat: repeat,
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
        frameBuilder: (context, child, composition) {
          if (composition == null) {
            return _buildFallback(isShimmering: true);
          }
          return child;
        },
      ),
    );
  }

  Widget _buildFallback({bool isShimmering = false}) {
    final color = fallbackColor ?? AppColors.primary;
    return Center(
      child: Container(
        width: width * 0.75,
        height: height * 0.75,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Center(
          child: Icon(fallbackIcon, size: width * 0.4, color: color),
        ),
      ),
    )
        .animate(onPlay: (c) => isShimmering ? c.repeat(reverse: true) : null)
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.05, 1.05),
          duration: 1200.ms,
          curve: Curves.easeInOut,
        );
  }
}
