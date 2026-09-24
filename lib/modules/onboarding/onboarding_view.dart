import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/constants/lottie_assets.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_lottie_view.dart';
import '../../core/widgets/custom_button.dart';
import 'onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<_OnboardingItem> items = [
      _OnboardingItem(
        title: 'Find Verified Skilled Pros Instantly',
        subtitle:
            'Connect with background-checked electricians, plumbers, carpenters, HVAC pros and painters in seconds.',
        lottieUrl: LottieAssets.parkingRadar,
        fallbackIcon: Icons.verified_user_rounded,
        badgeText: 'INSTANT VERIFICATION',
        accentGradient: AppColors.primaryGradient,
        features: ['✓ Government ID Verified', '✓ Multi-Trade Network', '✓ 4.8★ Top Rated'],
      ),
      _OnboardingItem(
        title: 'Live Chat & Direct Rate Negotiation',
        subtitle:
            'Negotiate hourly rates directly in real-time chat before booking. Mutual agreements with zero hidden fees.',
        lottieUrl: LottieAssets.walletCashout,
        fallbackIcon: Icons.handshake_rounded,
        badgeText: 'TRANSPARENT PRICING',
        accentGradient: AppColors.cyanGradient,
        features: ['✓ Live SignalR Chat', '✓ Rate Counter-Offers', '✓ No Surprise Markups'],
      ),
      _OnboardingItem(
        title: '1-Tap Booking & Live Dispatch',
        subtitle:
            'Schedule your preferred date, time and job scope with seamless dispatch tracking from arrival to job finish.',
        lottieUrl: LottieAssets.carDriving,
        fallbackIcon: Icons.event_available_rounded,
        badgeText: 'EFFORTLESS SCHEDULING',
        accentGradient: AppColors.emeraldGradient,
        features: ['✓ Flexible Time Slots', '✓ Live Status Milestones', '✓ Rapid Dispatch'],
      ),
      _OnboardingItem(
        title: 'Milestone Protection & Safe Pay',
        subtitle:
            'Pay with peace of mind after work completion and verified satisfaction. Transparent invoices and receipts.',
        lottieUrl: LottieAssets.paymentSuccess,
        fallbackIcon: Icons.shield_rounded,
        badgeText: '100% SATISFACTION',
        accentGradient: AppColors.goldGradient,
        features: ['✓ Protected Transactions', '✓ Digital Invoices', '✓ Verified Reviews'],
      ),
      _OnboardingItem(
        title: 'Empowering Freelancers & Companies',
        subtitle:
            'Skilled tradesperson or running a maintenance firm? Register your profile or organisation and grow your revenue.',
        lottieUrl: LottieAssets.proUpgrade,
        fallbackIcon: Icons.workspace_premium_rounded,
        badgeText: 'WORKER & ORG HUB',
        accentGradient: AppColors.primaryGradient,
        features: ['✓ Instant Job Alerts', '✓ Team Dispatch Hub', '✓ Direct Payouts'],
      ),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Brand Mark + Skip Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Brand Logo Mark
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.handyman_rounded, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'KAMKAR',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  // Skip Button
                  Obx(
                    () => controller.currentPage.value < controller.totalPages - 1
                        ? TextButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              controller.skipOnboarding();
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: BorderSide(
                                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                ),
                              ),
                            ),
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          )
                        : const SizedBox(height: 34),
                  ),
                ],
              ),
            ),

            // Main Walkthrough Slides PageView
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: items.length,
                onPageChanged: (idx) {
                  HapticFeedback.selectionClick();
                  controller.onPageChanged(idx);
                },
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _buildOnboardingPage(context, item, isDark);
                },
              ),
            ),

            // Bottom Navigation Indicators & Action Buttons
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                border: Border(
                  top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Obx(() {
                final isLastPage = controller.currentPage.value == controller.totalPages - 1;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Smooth Expanding Pill Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        items.length,
                        (dotIdx) {
                          final isSelected = controller.currentPage.value == dotIdx;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 7,
                            width: isSelected ? 28 : 7,
                            decoration: BoxDecoration(
                              gradient: isSelected ? AppColors.primaryGradient : null,
                              color: isSelected
                                  ? null
                                  : (isDark ? AppColors.borderDark : const Color(0xFFCBD5E1)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Action Buttons
                    if (isLastPage) ...[
                      // Get Started / Explore
                      CustomButton(
                        text: 'Get Started & Explore Pros',
                        icon: Icons.explore_rounded,
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          controller.finishOnboarding(targetRoute: AppRoutes.marketplace);
                        },
                      ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 12),
                      // Sign In Option
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontSize: 13.5,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              controller.finishOnboarding(targetRoute: AppRoutes.login);
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 150.ms),
                    ] else ...[
                      // Continue / Next Button
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Continue',
                              icon: Icons.arrow_forward_rounded,
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                controller.nextPage();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(BuildContext context, _OnboardingItem item, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        children: [
          const SizedBox(height: 10),
          // Animation Card with Glow Background
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                    : [const Color(0xFFEEF2FF), const Color(0xFFF8FAFC)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AppLottieView(
                  url: item.lottieUrl,
                  width: 170,
                  height: 170,
                  fallbackIcon: item.fallbackIcon,
                  fallbackColor: AppColors.primary,
                ),
                // Top Frosted Badge
                Positioned(
                  top: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: item.accentGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      item.badgeText,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),

          const SizedBox(height: 24),

          // Title
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  letterSpacing: -0.5,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),

          const SizedBox(height: 10),

          // Subtitle
          Text(
            item.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              height: 1.45,
            ),
          ).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 20),

          // Feature Highlights Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: item.features.map((feature) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  feature,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              );
            }).toList(),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.05, end: 0),
        ],
      ),
    );
  }
}

class _OnboardingItem {
  final String title;
  final String subtitle;
  final String lottieUrl;
  final IconData fallbackIcon;
  final String badgeText;
  final LinearGradient accentGradient;
  final List<String> features;

  _OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.lottieUrl,
    required this.fallbackIcon,
    required this.badgeText,
    required this.accentGradient,
    required this.features,
  });
}
