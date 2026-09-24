import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/constants/lottie_assets.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../data/models/chat_model.dart';
import 'chat_controller.dart';

class ConversationListView extends GetView<ChatController> {
  const ConversationListView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Negotiation Messages'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.threads.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          }

          if (controller.threads.isEmpty) {
            return EmptyStateWidget(
              title: 'No Active Chats',
              message: 'Initiate a rate negotiation or book a worker to start a conversation thread.',
              lottieUrl: LottieAssets.emptyBox,
              buttonText: 'Discover Workers',
              onButtonPressed: () => Get.toNamed(AppRoutes.marketplace),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.fetchThreads,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: controller.threads.length,
              itemBuilder: (context, index) {
                final thread = controller.threads[index];
                return _buildThreadTile(context, thread, isDark);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildThreadTile(BuildContext context, NegotiationThread thread, bool isDark) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.chatDetail,
          arguments: {
            'threadId': thread.id,
            'workerName': thread.workerName,
            'hourlyRate': thread.currentOfferedRate,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.person_rounded, color: AppColors.primary, size: 26),
              ),
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
                          thread.workerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        DateFormat('hh:mm a').format(thread.updatedAt),
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    thread.serviceName,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    thread.lastMessage ?? 'Negotiation initiated',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            if (thread.unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(7),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${thread.unreadCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.05, end: 0);
  }
}
