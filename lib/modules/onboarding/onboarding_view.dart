import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
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
            'Connect directly with background-checked electricians, plumbers, carpenters, HVAC pros & painters across UAE in seconds.',
        imageUrl:
            'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=900&auto=format&fit=crop&q=80',
        badgeText: '500+ VERIFIED TRADES',
        badgeIcon: Icons.verified_user_rounded,
        tag: 'Instant Hiring',
        accentGradient: AppColors.primaryGradient,
        features: ['⚡ Licensed Electricians', '🔧 Master Plumbers', '❄️ AC & HVAC Specialists'],
      ),
      _OnboardingItem(
        title: 'Live Chat & Direct Rate Negotiation',
        subtitle:
            'Discuss project requirements in real-time, propose counter-rates, and agree on transparent hourly fees with zero middlemen.',
        imageUrl:
            'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=900&auto=format&fit=crop&q=80',
        badgeText: 'FAIR & OPEN PRICING',
        badgeIcon: Icons.handshake_rounded,
        tag: 'Rate Negotiation',
        accentGradient: AppColors.cyanGradient,
        features: ['💬 Real-time Chat', '🤝 Direct Counter-Offers', '🚫 No Hidden Markups'],
      ),
      _OnboardingItem(
        title: '1-Tap Booking & Live Dispatch',
        subtitle:
            'Pick your preferred date and time slot. Enjoy rapid dispatch with live status progression from technician arrival to job finish.',
        imageUrl:
            'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=900&auto=format&fit=crop&q=80',
        badgeText: '60-SECOND DISPATCH',
        badgeIcon: Icons.flash_on_rounded,
        tag: 'Fast Scheduling',
        accentGradient: AppColors.emeraldGradient,
        features: ['📅 Flexible Schedule', '📍 GPS Location Pin', '⏱️ 60-Sec Confirmation'],
      ),
      _OnboardingItem(
        title: 'Safe Milestones & Guaranteed Quality',
        subtitle:
            'Zero advance deposit required. Inspect the craftsmanship first, then complete payment with full digital invoice protection.',
        imageUrl:
            'https://images.unsplash.com/photo-1585704032915-c3400ca199e7?w=900&auto=format&fit=crop&q=80',
        badgeText: '100% QUALITY GUARANTEE',
        badgeIcon: Icons.shield_rounded,
        tag: 'Protected Payments',
        accentGradient: AppColors.goldGradient,
        features: ['🛡️ No Advance Payment', '🧾 Digital Tax Invoices', '⭐ Verified Client Reviews'],
      ),
      _OnboardingItem(
        title: 'Empowering Freelancers & Trade Companies',
        subtitle:
            'Are you a master craftsman or running a maintenance firm? Register your profile or organisation to grow your client network.',
        imageUrl:
            'https://images.unsplash.com/photo-1503387762-592deb58ef4e?w=900&auto=format&fit=crop&q=80',
        badgeText: 'WORKER & ORG HUB',
        badgeIcon: Icons.business_center_rounded,
        tag: 'Trade Opportunities',
        accentGradient: AppColors.primaryGradient,
        features: ['💼 Team Dispatch Tools', '📈 Daily Job Alerts', '💰 Direct Payouts'],
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
                              color: AppColors.primary.withValues(alpha: 0.35),
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
                      Text(
                        'KAMKAR',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          letterSpacing: 1.5,
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
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                ),
                              ),
                              elevation: 1,
                            ),
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
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
                  top: BorderSide(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    width: 1.2,
                  ),
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
                                  : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 18),

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
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
      child: Column(
        children: [
          // High Definition Project Photography Card
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: isDark ? 0.25 : 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(27),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Photo with CachedNetworkImage
                  CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(gradient: item.accentGradient),
                      child: Center(
                        child: Icon(item.badgeIcon, size: 64, color: Colors.white),
                      ),
                    ),
                  ),

                  // Atmospheric Gradient Overlays for High Contrast
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.55),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.75),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),

                  // Floating Top Frosted Tag
                  Positioned(
                    top: 14,
                    left: 14,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(item.badgeIcon, color: const Color(0xFFFBBF24), size: 14),
                              const SizedBox(width: 6),
                              Text(
                                item.tag,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bottom Overlay Value Proposition Badge
                  Positioned(
                    bottom: 14,
                    left: 14,
                    right: 14,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  item.badgeText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),

          const SizedBox(height: 22),

          // Title
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
              height: 1.25,
            ),
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),

          const SizedBox(height: 10),

          // Subtitle
          Text(
            item.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
              height: 1.45,
            ),
          ).animate().fadeIn(delay: 180.ms),

          const SizedBox(height: 18),

          // Feature Highlights Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: item.features.map((feature) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
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
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFFA5B4FC) : AppColors.primary,
                  ),
                ),
              );
            }).toList(),
          ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.05, end: 0),
        ],
      ),
    );
  }
}

class _OnboardingItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String badgeText;
  final IconData badgeIcon;
  final String tag;
  final LinearGradient accentGradient;
  final List<String> features;

  _OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.badgeText,
    required this.badgeIcon,
    required this.tag,
    required this.accentGradient,
    required this.features,
  });
}
