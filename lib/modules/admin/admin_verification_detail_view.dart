import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/confirmation_bottom_sheet.dart';
import '../../core/widgets/custom_button.dart';
import '../../data/models/admin_model.dart';
import 'admin_controller.dart';

class AdminVerificationDetailView extends StatelessWidget {
  const AdminVerificationDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final req = Get.arguments as VerificationRequest? ??
        VerificationRequest(
          id: 'req-1',
          workerId: 'w-10',
          fullName: 'Devon Vance',
          email: 'devon@example.com',
          phoneNumber: '+1 (555) 392-1928',
          workerType: 'HVAC Specialist',
          yearsOfExperience: 8,
          idDocumentUrl: 'https://example.com/id.jpg',
          certificateUrl: 'https://example.com/cert.jpg',
          status: 'Pending',
          submittedAt: DateTime.now().subtract(const Duration(hours: 5)),
        );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.find<AdminController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Inspection'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Worker Summary
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      req.fullName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${req.workerType} • ${req.yearsOfExperience} Years of Verified Experience',
                      style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                    const Divider(height: 24),
                    _buildInfoLine('Email', req.email, isDark),
                    const SizedBox(height: 8),
                    _buildInfoLine('Phone', req.phoneNumber, isDark),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Attached Documents Preview
              const Text('Submitted Documents', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),

              _buildDocPreviewCard(context, 'Government ID Proof', req.idDocumentUrl, isDark),
              const SizedBox(height: 12),
              if (req.certificateUrl != null)
                _buildDocPreviewCard(context, 'Trade Board License / Certificate', req.certificateUrl!, isDark),

              const SizedBox(height: 32),

              // Decision Action Buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Reject',
                      backgroundColor: AppColors.error,
                      onPressed: () async {
                        final confirmed = await ConfirmationBottomSheet.show(
                          context: context,
                          title: 'Reject Application?',
                          message: 'Are you sure you want to reject ${req.fullName}\'s verification application?',
                          confirmText: 'Reject Application',
                          cancelText: 'Cancel',
                          icon: Icons.block_rounded,
                          iconColor: AppColors.error,
                          confirmButtonColor: AppColors.error,
                          isDestructive: true,
                          cancellationReasons: const [
                            'Incomplete or unreadable ID documentation',
                            'Expired trade certificate / license',
                            'Experience does not match claims',
                            'Failed background verification check',
                            'Other administrative reason',
                          ],
                        );
                        if (confirmed == true) {
                          controller.rejectWorker(req.workerId, 'Application rejected by administrator');
                          Get.back();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: CustomButton(
                      text: 'Approve',
                      gradient: AppColors.emeraldGradient,
                      onPressed: () async {
                        final confirmed = await ConfirmationBottomSheet.show(
                          context: context,
                          title: 'Approve Application?',
                          message: 'Verify ${req.fullName} as an official ${req.workerType}? They will immediately receive access to accept customer jobs.',
                          confirmText: 'Approve & Activate',
                          cancelText: 'Review Later',
                          icon: Icons.verified_user_rounded,
                          iconColor: AppColors.success,
                          confirmButtonColor: AppColors.success,
                          isDestructive: false,
                        );
                        if (confirmed == true) {
                          controller.approveWorker(req.workerId);
                          Get.back();
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoLine(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)),
        Text(value, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildDocPreviewCard(BuildContext context, String title, String url, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.description_rounded, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                const Text('Tap to view high-res scan', style: TextStyle(fontSize: 11.5, color: AppColors.primary)),
              ],
            ),
          ),
          const Icon(Icons.open_in_new_rounded, size: 18, color: AppColors.textSecondaryLight),
        ],
      ),
    );
  }
}
