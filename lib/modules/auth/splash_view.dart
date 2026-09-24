import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../core/storage/secure_storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/auth_repository.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _handleSplashFlow();
  }

  Future<void> _handleSplashFlow() async {
    await Future.delayed(AppConstants.splashDuration);
    final storageService = Get.find<SecureStorageService>();
    final authRepo = Get.find<AuthRepository>();

    if (authRepo.isLoggedIn) {
      final role = authRepo.userRole;
      final userData = authRepo.userData;
      final verificationStatus = userData?['verificationStatus']?.toString() ?? 'Approved';

      if (role == AppConstants.roleWorker && verificationStatus == 'Pending') {
        Get.offAllNamed(AppRoutes.workerPendingApproval);
      } else {
        Get.offAllNamed(AppRoutes.main);
      }
    } else {
      if (!storageService.isOnboardingCompleted()) {
        Get.offAllNamed(AppRoutes.onboarding);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // App Icon with glow
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.handyman_rounded,
                    size: 52,
                    color: Colors.white,
                  ),
                ),
              )
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.easeOutBack)
                  .fadeIn(duration: 400.ms),
              const SizedBox(height: 24),
              // App Title
              Text(
                'KAMKAR',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w900,
                    ),
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 400.ms)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: 8),
              // Tagline
              Text(
                'Verified On-Demand Workforce',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              )
                  .animate()
                  .fadeIn(delay: 350.ms, duration: 400.ms)
                  .slideY(begin: 0.2, end: 0),
              const Spacer(),
              // Loading indicator
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
                ),
              ).animate().fadeIn(delay: 600.ms),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
