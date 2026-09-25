import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../constants/lottie_assets.dart';
import '../theme/app_colors.dart';
import 'app_lottie_view.dart';

class ConfirmationBottomSheet {
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    IconData icon = Icons.warning_amber_rounded,
    String? lottieUrl,
    Color? iconColor,
    Color? confirmButtonColor,
    bool isDestructive = true,
    List<String>? cancellationReasons,
  }) {
    HapticFeedback.mediumImpact();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = confirmButtonColor ?? (isDestructive ? AppColors.error : AppColors.primary);
    final selectedReason = (cancellationReasons != null && cancellationReasons.isNotEmpty)
        ? cancellationReasons.first.obs
        : null;

    // Automatic smart Lottie fallback
    final activeLottie = lottieUrl ??
        (isDestructive
            ? LottieAssets.paymentFailed
            : (confirmButtonColor == AppColors.success
                ? LottieAssets.successCheck
                : LottieAssets.verifiedBadge));

    return Get.bottomSheet<bool>(
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(34)),
            border: Border(
              top: BorderSide(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                width: 1.2,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.6 : 0.18),
                blurRadius: 36,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top drag pill
              Center(
                child: Container(
                  width: 44,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Animated Lottie & Multi-Ring Aura
              Stack(
                alignment: Alignment.center,
                children: [
                  // Outer Pulsing Glow Ring
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (iconColor ?? primaryColor).withValues(alpha: isDark ? 0.15 : 0.08),
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(
                        begin: const Offset(0.92, 0.92),
                        end: const Offset(1.12, 1.12),
                        duration: 1400.ms,
                        curve: Curves.easeInOut,
                      ),

                  // Middle Border Ring
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (iconColor ?? primaryColor).withValues(alpha: isDark ? 0.22 : 0.12),
                      border: Border.all(
                        color: (iconColor ?? primaryColor).withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                    ),
                  ),

                  // Central Lottie Animation / Fallback Icon
                  AppLottieView(
                    url: activeLottie,
                    width: 84,
                    height: 84,
                    fallbackIcon: icon,
                    fallbackColor: iconColor ?? primaryColor,
                  ),
                ],
              ).animate().scale(duration: 350.ms, curve: Curves.easeOutBack),

              const SizedBox(height: 16),

              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                  letterSpacing: -0.4,
                ),
              ).animate().fadeIn(delay: 50.ms).slideY(begin: 0.1, end: 0),

              const SizedBox(height: 8),

              // Message
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.8,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                ),
              ).animate().fadeIn(delay: 100.ms),

              // Optional Reasons Selector
              if (cancellationReasons != null && cancellationReasons.isNotEmpty) ...[
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select a reason:',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white70 : const Color(0xFF475569),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Obx(
                    () => DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedReason?.value,
                        isExpanded: true,
                        dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                        items: cancellationReasons.map((reason) {
                          return DropdownMenuItem(
                            value: reason,
                            child: Text(
                              reason,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : const Color(0xFF1E293B),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null && selectedReason != null) {
                            selectedReason.value = val;
                          }
                        },
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 150.ms),
              ],

              const SizedBox(height: 24),

              // Action Buttons Row
              Row(
                children: [
                  // Cancel / Dismiss Button
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Get.back(result: false);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: isDark
                              ? const Color(0xFF0F172A).withValues(alpha: 0.5)
                              : const Color(0xFFF8FAFC),
                        ),
                        child: Text(
                          cancelText,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white70 : const Color(0xFF475569),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Confirm Action Button
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          Get.back(result: true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: primaryColor.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          confirmText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
