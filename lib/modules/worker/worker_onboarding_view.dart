import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';

class WorkerOnboardingView extends StatefulWidget {
  const WorkerOnboardingView({super.key});

  @override
  State<WorkerOnboardingView> createState() => _WorkerOnboardingViewState();
}

class _WorkerOnboardingViewState extends State<WorkerOnboardingView> {
  final formKey = GlobalKey<FormState>();
  final experienceController = TextEditingController(text: '5');
  final hourlyRateController = TextEditingController(text: '45');
  final bioController = TextEditingController();
  String selectedTrade = 'Electrician';
  bool isIdUploaded = false;
  bool isLicenseUploaded = false;
  bool isLoading = false;

  @override
  void dispose() {
    experienceController.dispose();
    hourlyRateController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void _submitOnboarding() async {
    if (!isIdUploaded) {
      Get.snackbar('Document Required', 'Please upload your Government Issued ID');
      return;
    }

    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => isLoading = false);

    Get.offAllNamed(AppRoutes.workerPendingApproval);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Verification'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete Your Professional Profile',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                ).animate().fadeIn(duration: 300.ms),
                const SizedBox(height: 6),
                Text(
                  'Verified professionals get up to 4x more customer job requests.',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ).animate().fadeIn(delay: 100.ms),
                const SizedBox(height: 24),

                // Primary Trade
                Text('Primary Trade Specialty', style: TextStyle(fontWeight: FontWeight.w700, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedTrade,
                      isExpanded: true,
                      dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
                      items: ['Electrician', 'Plumber', 'HVAC Specialist', 'Carpenter', 'Painter']
                          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => selectedTrade = val);
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Experience & Hourly Rate
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: experienceController,
                        label: 'Years of Experience',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.history_edu_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        controller: hourlyRateController,
                        label: 'Standard Rate (\$/hr)',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.attach_money_rounded,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                CustomTextField(
                  controller: bioController,
                  label: 'Professional Summary',
                  hint: 'Highlight your specialties, certifications, and experience...',
                  maxLines: 3,
                ),

                const SizedBox(height: 24),

                // Document Upload Cards
                Text('Compliance Documents', style: TextStyle(fontWeight: FontWeight.w700, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)),
                const SizedBox(height: 12),

                _buildUploadTile(
                  context,
                  title: 'Government Issued ID',
                  subtitle: 'Driver License or National Passport',
                  icon: Icons.badge_outlined,
                  isUploaded: isIdUploaded,
                  onTap: () => setState(() => isIdUploaded = !isIdUploaded),
                  isDark: isDark,
                ),

                const SizedBox(height: 12),

                _buildUploadTile(
                  context,
                  title: 'Trade License / Certification',
                  subtitle: 'State Board or Apprenticeship Certificate',
                  icon: Icons.verified_outlined,
                  isUploaded: isLicenseUploaded,
                  onTap: () => setState(() => isLicenseUploaded = !isLicenseUploaded),
                  isDark: isDark,
                ),

                const SizedBox(height: 32),

                CustomButton(
                  text: 'Submit Application for Review',
                  isLoading: isLoading,
                  onPressed: _submitOnboarding,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isUploaded,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUploaded
              ? (isDark ? AppColors.cardDark : AppColors.successLight.withValues(alpha: 0.3))
              : (isDark ? AppColors.surfaceDark : Colors.white),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isUploaded ? AppColors.success : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: isUploaded ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isUploaded ? AppColors.success : AppColors.primary).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUploaded ? Icons.check_circle_rounded : icon,
                color: isUploaded ? AppColors.success : AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isUploaded ? 'Document attached & ready' : subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isUploaded ? AppColors.success : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                      fontWeight: isUploaded ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isUploaded ? Icons.done_all_rounded : Icons.upload_file_rounded,
              color: isUploaded ? AppColors.success : AppColors.primary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
