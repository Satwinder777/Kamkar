import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/constants/lottie_assets.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/models/admin_model.dart';
import 'admin_controller.dart';

class AdminVerificationListView extends GetView<AdminController> {
  const AdminVerificationListView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Verification Queue'),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.requests.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          }

          if (controller.requests.isEmpty) {
            return const EmptyStateWidget(
              title: 'Queue Clear',
              message: 'No pending worker identity applications waiting for review.',
              lottieUrl: LottieAssets.successCheck,
            );
          }

          return RefreshIndicator(
            onRefresh: controller.fetchRequests,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.requests.length,
              itemBuilder: (context, index) {
                final req = controller.requests[index];
                return _buildVerificationCard(context, req, isDark);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildVerificationCard(BuildContext context, VerificationRequest req, bool isDark) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.adminVerificationDetail, arguments: req),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    req.fullName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
                StatusBadge(text: req.status.toUpperCase(), color: AppColors.warning),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${req.workerType} • ${req.yearsOfExperience} yrs experience',
              style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Submitted: ${DateFormat('MMM dd, yyyy • hh:mm a').format(req.submittedAt)}',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.05, end: 0);
  }
}
