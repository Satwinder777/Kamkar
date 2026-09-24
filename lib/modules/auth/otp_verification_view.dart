import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../core/constants/lottie_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_lottie_view.dart';
import '../../core/widgets/custom_button.dart';
import 'auth_controller.dart';

class OtpVerificationView extends GetView<AuthController> {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultPinTheme = PinTheme(
      width: 50,
      height: 56,
      textStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.primary, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              // Animated Lottie / Icon
              const AppLottieView(
                url: LottieAssets.scanningDoc,
                width: 140,
                height: 140,
                fallbackIcon: Icons.mark_email_read_rounded,
              ).animate().scale(duration: 400.ms),
              const SizedBox(height: 20),
              // Title
              Text(
                'Enter Verification Code',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 8),
              Obx(
                () => Text(
                  'We sent a 6-digit code to ${controller.registeredEmail.value.isNotEmpty ? controller.registeredEmail.value : "your email"}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    height: 1.4,
                  ),
                ),
              ).animate().fadeIn(delay: 150.ms),
              const SizedBox(height: 32),

              // Pinput 6-digit field
              Pinput(
                length: 6,
                controller: controller.otpController,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                onCompleted: (pin) {
                  controller.verifyOtp();
                },
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),

              const SizedBox(height: 32),
              // Verify Button
              Obx(
                () => CustomButton(
                  text: 'Verify & Continue',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.verifyOtp,
                ),
              ).animate().fadeIn(delay: 250.ms),

              const SizedBox(height: 24),
              // Resend Countdown
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.canResend.value
                          ? "Didn't receive code? "
                          : "Resend code in ${controller.resendCountdown.value}s",
                      style: TextStyle(
                        fontSize: 13.5,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    if (controller.canResend.value)
                      GestureDetector(
                        onTap: controller.resendOtp,
                        child: const Text(
                          'Resend Now',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                  ],
                ),
              ).animate().fadeIn(delay: 300.ms),
            ],
          ),
        ),
      ),
    );
  }
}
