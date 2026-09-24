import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/constants/lottie_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../data/models/notification_model.dart';
import 'notification_controller.dart';

class NotificationListView extends GetView<NotificationController> {
  const NotificationListView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.notifications.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          }

          if (controller.notifications.isEmpty) {
            return const EmptyStateWidget(
              title: 'No Notifications',
              message: 'You have caught up with all updates and notifications.',
              lottieUrl: LottieAssets.emptyBox,
            );
          }

          return RefreshIndicator(
            onRefresh: controller.fetchNotifications,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.notifications.length,
              itemBuilder: (context, index) {
                final notif = controller.notifications[index];
                return _buildNotifCard(context, notif, isDark);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNotifCard(BuildContext context, AppNotification notif, bool isDark) {
    IconData iconData;
    Color iconColor;

    switch (notif.type) {
      case 'ChatOffer':
        iconData = Icons.handshake_rounded;
        iconColor = AppColors.primary;
        break;
      case 'BookingUpdate':
        iconData = Icons.event_available_rounded;
        iconColor = AppColors.success;
        break;
      case 'Verification':
        iconData = Icons.verified_user_rounded;
        iconColor = AppColors.warning;
        break;
      default:
        iconData = Icons.notifications_rounded;
        iconColor = AppColors.secondary;
    }

    return GestureDetector(
      onTap: () => controller.markAsRead(notif.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notif.isRead
              ? (isDark ? AppColors.surfaceDark : Colors.white)
              : (isDark ? AppColors.cardDark : AppColors.primarySoft.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: notif.isRead
                ? (isDark ? AppColors.borderDark : AppColors.borderLight)
                : AppColors.primary.withValues(alpha: 0.4),
            width: notif.isRead ? 1 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notif.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: notif.isRead ? FontWeight.w700 : FontWeight.w900,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                      if (!notif.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notif.message,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    DateFormat('MMM dd • hh:mm a').format(notif.createdAt),
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.05, end: 0);
  }
}
