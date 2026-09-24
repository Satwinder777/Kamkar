import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import 'settings_controller.dart';

class UserSettingsView extends GetView<SettingsController> {
  const UserSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Appearance Section
              Text(
                'Appearance & Theme',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Obx(
                  () => SwitchListTile(
                    title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: const Text('Toggle between sleek dark and clean light styles', style: TextStyle(fontSize: 12.5)),
                    secondary: const Icon(Icons.dark_mode_outlined, color: AppColors.primary),
                    value: controller.isDarkMode.value,
                    activeTrackColor: AppColors.primaryLight,
                    activeThumbColor: AppColors.primary,
                    onChanged: controller.toggleTheme,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Language Section
              Text(
                'Language / اللغة',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Obx(
                  () => Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          controller.currentLanguage.value == 'en'
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_off_rounded,
                          color: controller.currentLanguage.value == 'en' ? AppColors.primary : null,
                        ),
                        title: const Text('English (US)', style: TextStyle(fontWeight: FontWeight.w600)),
                        onTap: () => controller.changeLanguage('en'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(
                          controller.currentLanguage.value == 'ar'
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_off_rounded,
                          color: controller.currentLanguage.value == 'ar' ? AppColors.primary : null,
                        ),
                        title: const Text('العربية (Arabic)', style: TextStyle(fontWeight: FontWeight.w600)),
                        onTap: () => controller.changeLanguage('ar'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // About & Compliance
              Text(
                'About Kamkar',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('App Version', style: TextStyle(fontWeight: FontWeight.w600)),
                        Text('v1.0.0 (Production Build)', style: TextStyle(color: AppColors.textSecondaryLight)),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Backend API', style: TextStyle(fontWeight: FontWeight.w600)),
                        Text('ASP.NET Core 8 /api/v1', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              CustomButton(
                text: 'Sign Out',
                backgroundColor: AppColors.error,
                onPressed: controller.logout,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
