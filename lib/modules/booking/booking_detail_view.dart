import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/models/booking_model.dart';
import 'booking_controller.dart';

class BookingDetailView extends StatelessWidget {
  const BookingDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = Get.arguments as Booking? ??
        Booking(
          id: 'b-101',
          customerId: 'c-1',
          customerName: 'You',
          workerId: 'w-1',
          workerName: 'Alex Reynolds',
          serviceName: 'Electrical Panel Inspection',
          scheduledDate: DateTime.now().add(const Duration(days: 2)),
          address: '742 Evergreen Terrace, San Francisco, CA',
          notes: 'Main fuse box tripping intermittently.',
          agreedRate: 45.0,
          status: 'Confirmed',
          createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.find<BookingController>();

    Color statusColor;
    switch (booking.status.toLowerCase()) {
      case 'confirmed':
        statusColor = AppColors.success;
        break;
      case 'inprogress':
        statusColor = AppColors.secondary;
        break;
      case 'completed':
        statusColor = AppColors.primary;
        break;
      case 'cancelled':
        statusColor = AppColors.error;
        break;
      default:
        statusColor = AppColors.warning;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Booking #${booking.id.substring(0, booking.id.length > 8 ? 8 : booking.id.length)}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                        StatusBadge(text: booking.status.toUpperCase(), color: statusColor),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      booking.serviceName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Agreed Rate: \$${booking.agreedRate.toStringAsFixed(0)}/hr',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 20),

              // Scheduled Time & Location Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      context,
                      icon: Icons.calendar_month_rounded,
                      title: 'Scheduled Date & Time',
                      value: DateFormat('EEEE, MMM dd, yyyy • hh:mm a').format(booking.scheduledDate),
                      isDark: isDark,
                    ),
                    const Divider(height: 24),
                    _buildDetailRow(
                      context,
                      icon: Icons.location_on_rounded,
                      title: 'Service Address',
                      value: booking.address,
                      isDark: isDark,
                    ),
                    if (booking.notes != null && booking.notes!.isNotEmpty) ...[
                      const Divider(height: 24),
                      _buildDetailRow(
                        context,
                        icon: Icons.notes_rounded,
                        title: 'Job Instructions / Notes',
                        value: booking.notes!,
                        isDark: isDark,
                      ),
                    ],
                  ],
                ),
              ).animate().fadeIn(delay: 150.ms),

              const SizedBox(height: 20),

              // Assigned Professional Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : AppColors.primarySoft,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.person_rounded, color: AppColors.primary, size: 28),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.workerName,
                            style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Assigned Professional',
                            style: TextStyle(fontSize: 12.5, color: AppColors.textSecondaryLight),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primary),
                      onPressed: () {
                        Get.toNamed(
                          AppRoutes.chatDetail,
                          arguments: {
                            'workerId': booking.workerId,
                            'workerName': booking.workerName,
                          },
                        );
                      },
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 32),

              // Action Buttons based on status
              if (booking.status.toLowerCase() == 'confirmed') ...[
                CustomButton(
                  text: 'Cancel Booking',
                  backgroundColor: AppColors.error,
                  onPressed: () {
                    controller.updateStatus(booking.id, 'Cancelled');
                    Get.back();
                  },
                ),
              ],
              if (booking.status.toLowerCase() == 'completed') ...[
                CustomButton(
                  text: 'Write a Review',
                  icon: Icons.star_rounded,
                  onPressed: () {
                    Get.toNamed(AppRoutes.createReview, arguments: booking);
                  },
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.primarySoft,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
