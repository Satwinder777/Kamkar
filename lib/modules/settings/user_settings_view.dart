import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/confirmation_bottom_sheet.dart';
import '../../core/widgets/custom_button.dart';
import 'settings_controller.dart';

class UserSettingsView extends GetView<SettingsController> {
  const UserSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Preferences'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Support & Help Section
              Text(
                'Customer Support & Safety',
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
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.headset_mic_rounded, color: AppColors.primary, size: 20),
                      ),
                      title: const Text('Help & Customer Support Desk', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      subtitle: const Text('24/7 Live chat, toll-free helpline, submit ticket', style: TextStyle(fontSize: 12)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => Get.toNamed(AppRoutes.helpSupport),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.auto_awesome_rounded, color: Color(0xFFD97706), size: 20),
                      ),
                      title: const Text('App Tour & Feature Guide', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      subtitle: const Text('Revisit animated walkthrough of platform features', style: TextStyle(fontSize: 12)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => Get.toNamed(AppRoutes.onboarding),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

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

              // Legal & About Kamkar
              Text(
                'Legal & About Kamkar',
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
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.shield_outlined, color: Color(0xFF10B981)),
                      title: const Text('Privacy Policy & Data Security', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _showPolicyModal(context, 'Privacy Policy', 'Kamkar complies with UAE Data Protection Law (Federal Decree Law No. 45 of 2021). All user data, identity records, and financial transactions are encrypted end-to-end with TLS 1.3 encryption and stored securely in ISO-27001 certified cloud servers within the UAE region.'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.description_outlined, color: AppColors.primary),
                      title: const Text('Terms of Service & Trades Agreement', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _showPolicyModal(context, 'Terms of Service', 'All on-demand craftsman engagements on Kamkar are protected by the Kamkar Shield Escrow Guarantee. Payments are held safely and only disbursed upon verified service completion. Disputes are handled within 2 hours by our Dubai operations center.'),
                    ),
                    const Divider(height: 1),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('App Version', style: TextStyle(fontWeight: FontWeight.w600)),
                              Text('v1.0.0 (Production Build)', style: TextStyle(color: AppColors.textSecondaryLight)),
                            ],
                          ),
                          SizedBox(height: 10),
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
                  ],
                ),
              ),

              const SizedBox(height: 36),

              CustomButton(
                text: 'Sign Out',
                backgroundColor: AppColors.error,
                onPressed: () async {
                  final confirmed = await ConfirmationBottomSheet.show(
                    context: context,
                    title: 'Sign Out?',
                    message: 'Are you sure you want to sign out? You will need to log back in to access your profile.',
                    confirmText: 'Sign Out',
                    cancelText: 'Cancel',
                    icon: Icons.logout_rounded,
                    isDestructive: true,
                  );
                  if (confirmed == true) {
                    controller.logout();
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showPolicyModal(BuildContext context, String title, String body) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              body,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF475569),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Close',
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }
}
