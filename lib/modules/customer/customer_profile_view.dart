import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/storage/secure_storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../data/repositories/auth_repository.dart';

class CustomerProfileView extends StatelessWidget {
  const CustomerProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = Get.find<AuthRepository>();
    final userData = authRepo.userData ?? {};
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final name = userData['fullName']?.toString() ?? 'John Doe';
    final email = userData['email']?.toString() ?? 'john@example.com';
    final phone = userData['phoneNumber']?.toString() ?? '+1 (555) 019-2834';
    final role = authRepo.userRole;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Avatar & Name Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.person_rounded, size: 44, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        role.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Contact & Account Info
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(context, 'Email', email, Icons.email_outlined, isDark),
                    const Divider(height: 24),
                    _buildInfoRow(context, 'Phone', phone, Icons.phone_outlined, isDark),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Preferences & Actions Card
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    // Quick Dark Mode Switch
                    SwitchListTile(
                      secondary: Icon(
                        isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        color: AppColors.primary,
                      ),
                      title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(
                        isDark ? 'Dark theme enabled' : 'Clean light theme enabled',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                      value: isDark,
                      activeTrackColor: AppColors.primaryLight,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) {
                        final storage = Get.find<SecureStorageService>();
                        final mode = val ? 'dark' : 'light';
                        storage.setThemeMode(mode);
                        Get.changeThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                      },
                    ),
                    const Divider(height: 1),
                    // App Tour / Onboarding Walkthrough
                    ListTile(
                      leading: const Icon(Icons.auto_awesome_rounded, color: AppColors.warning),
                      title: const Text('App Tour & Feature Guide', style: TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: const Text('Review the animated features walkthrough', style: TextStyle(fontSize: 12.5)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => Get.toNamed(AppRoutes.onboarding),
                    ),
                    const Divider(height: 1),
                    // Full App Settings
                    ListTile(
                      leading: const Icon(Icons.settings_outlined, color: AppColors.primary),
                      title: const Text('Settings & Language', style: TextStyle(fontWeight: FontWeight.w700)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => Get.toNamed(AppRoutes.settings),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              CustomButton(
                text: 'Sign Out',
                isOutlined: true,
                onPressed: () async {
                  await authRepo.logout();
                  Get.offAllNamed(AppRoutes.login);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }
}
