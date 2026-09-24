import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/constants/lottie_assets.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_lottie_view.dart';
import '../../core/widgets/custom_button.dart';
import '../../data/repositories/auth_repository.dart';

class PendingApprovalView extends StatelessWidget {
  const PendingApprovalView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Animated Lottie Radar / Verification
              const AppLottieView(
                url: LottieAssets.searchRadar,
                width: 180,
                height: 180,
                fallbackIcon: Icons.pending_actions_rounded,
              ).animate().scale(duration: 500.ms),
              const SizedBox(height: 24),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.hourglass_top_rounded, size: 16, color: AppColors.warning),
                    SizedBox(width: 6),
                    Text(
                      'UNDER COMPLIANCE REVIEW',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.warning,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 150.ms),
              const SizedBox(height: 16),
              // Heading
              Text(
                'Application Submitted',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      letterSpacing: -0.3,
                    ),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 8),
              Text(
                'Our compliance team is verifying your trade licenses and background documentation. You will receive an alert once approved.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  height: 1.45,
                ),
              ).animate().fadeIn(delay: 250.ms),
              const Spacer(),
              // Refresh Status Action
              CustomButton(
                text: 'Check Status',
                icon: Icons.refresh_rounded,
                onPressed: () {
                  Get.snackbar(
                    'Status Check',
                    'Your application is still undergoing review.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 12),
              // Sign Out Button
              CustomButton(
                text: 'Sign Out',
                isOutlined: true,
                onPressed: () async {
                  await Get.find<AuthRepository>().logout();
                  Get.offAllNamed(AppRoutes.login);
                },
              ).animate().fadeIn(delay: 350.ms),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
