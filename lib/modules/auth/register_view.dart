import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import 'auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: controller.registerFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Join Kamkar',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                ).animate().fadeIn(duration: 300.ms),
                const SizedBox(height: 6),
                Text(
                  'Select your account type and start connecting',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ).animate().fadeIn(delay: 100.ms),
                const SizedBox(height: 24),

                // Role Selection Pills
                Text(
                  'Account Role',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => Row(
                    children: [
                      _buildRoleOption(
                        context,
                        title: 'Customer',
                        icon: Icons.person_rounded,
                        role: AppConstants.roleCustomer,
                        isSelected: controller.selectedRole.value == AppConstants.roleCustomer,
                        isDark: isDark,
                      ),
                      const SizedBox(width: 10),
                      _buildRoleOption(
                        context,
                        title: 'Worker',
                        icon: Icons.handyman_rounded,
                        role: AppConstants.roleWorker,
                        isSelected: controller.selectedRole.value == AppConstants.roleWorker,
                        isDark: isDark,
                      ),
                      const SizedBox(width: 10),
                      _buildRoleOption(
                        context,
                        title: 'Organisation',
                        icon: Icons.business_rounded,
                        role: AppConstants.roleOrganisation,
                        isSelected: controller.selectedRole.value == AppConstants.roleOrganisation,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 150.ms),

                const SizedBox(height: 24),
                // Full Name Field
                CustomTextField(
                  controller: controller.fullNameController,
                  label: 'Full Name',
                  hint: 'John Doe',
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Name is required';
                    return null;
                  },
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 16),

                // Email Field
                CustomTextField(
                  controller: controller.emailController,
                  label: 'Email Address',
                  hint: 'john@example.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Email is required';
                    if (!val.contains('@')) return 'Enter a valid email address';
                    return null;
                  },
                ).animate().fadeIn(delay: 250.ms),
                const SizedBox(height: 16),

                // Phone Field
                CustomTextField(
                  controller: controller.phoneController,
                  label: 'Phone Number',
                  hint: '+1 234 567 8900',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: 16),

                // Password Field
                CustomTextField(
                  controller: controller.passwordController,
                  label: 'Password',
                  hint: 'At least 6 characters',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: true,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Password is required';
                    if (val.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ).animate().fadeIn(delay: 350.ms),

                const SizedBox(height: 28),
                // Submit Button
                Obx(
                  () => CustomButton(
                    text: 'Create Account',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.register,
                  ),
                ).animate().fadeIn(delay: 400.ms),

                const SizedBox(height: 20),
                // Already have account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already registered? ',
                      style: TextStyle(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 450.ms),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String role,
    required bool isSelected,
    required bool isDark,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          controller.selectedRole.value = role;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppColors.primaryDark : AppColors.primarySoft)
                : (isDark ? AppColors.cardDark : Colors.white),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
              width: isSelected ? 1.8 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    )
                  ]
                : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                size: 24,
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
