import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../theme/app_colors.dart';

class FloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;
  final List<GButton> tabs;

  const FloatingNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: GNav(
          rippleColor: AppColors.primary.withValues(alpha: 0.15),
          hoverColor: AppColors.primary.withValues(alpha: 0.08),
          gap: 8,
          activeColor: AppColors.primary,
          iconSize: 22,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          duration: const Duration(milliseconds: 320),
          tabBackgroundColor: isDark ? AppColors.cardDark : AppColors.primarySoft,
          tabBorderRadius: 20,
          tabBorder: Border.all(
            color: isDark ? AppColors.primaryDark : const Color(0xFFC7D2FE),
            width: 1.0,
          ),
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          textStyle: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
          tabs: tabs,
          selectedIndex: selectedIndex,
          onTabChange: (index) {
            HapticFeedback.lightImpact();
            onTabChange(index);
          },
        ),
      ),
    );
  }
}
