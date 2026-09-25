import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/confirmation_bottom_sheet.dart';
import '../../data/models/booking_model.dart';
import 'booking_controller.dart';

class BookingDetailView extends StatefulWidget {
  const BookingDetailView({super.key});

  @override
  State<BookingDetailView> createState() => _BookingDetailViewState();
}

class _BookingDetailViewState extends State<BookingDetailView> {
  late Rx<Booking> currentBooking;

  @override
  void initState() {
    super.initState();
    final initial = Get.arguments as Booking? ??
        Booking(
          id: 'b-101',
          customerId: 'c-1',
          customerName: 'You',
          workerId: 'w-1',
          workerName: 'Alex Reynolds',
          workerImageUrl: 'https://images.unsplash.com/photo-1540569014015-19a7be504e3a?w=400',
          serviceName: 'Electrical Panel Inspection',
          scheduledDate: DateTime.now().add(const Duration(days: 2)),
          address: '742 Evergreen Terrace, Dubai Marina',
          notes: 'Main fuse box tripping intermittently.',
          agreedRate: 45.0,
          status: 'Confirmed',
          createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        );
    currentBooking = initial.obs;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF10B981);
      case 'inprogress':
        return const Color(0xFF0284C7);
      case 'completed':
        return AppColors.primary;
      case 'cancelled':
      case 'rejected':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFFF59E0B);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Icons.verified_rounded;
      case 'inprogress':
        return Icons.hourglass_top_rounded;
      case 'completed':
        return Icons.task_alt_rounded;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.schedule_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.find<BookingController>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Booking Details',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        elevation: 0,
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      ),
      body: SafeArea(
        child: Obx(() {
          final booking = currentBooking.value;
          final statusColor = _getStatusColor(booking.status);
          final statusIcon = _getStatusIcon(booking.status);
          final isCancelled = booking.status.toLowerCase() == 'cancelled';
          final isConfirmed = booking.status.toLowerCase() == 'confirmed';
          final isCompleted = booking.status.toLowerCase() == 'completed';

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Status Hero Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withValues(alpha: isDark ? 0.15 : 0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Booking #${booking.id.length > 8 ? booking.id.substring(0, 8) : booking.id}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          // Status Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: isDark ? 0.2 : 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: statusColor.withValues(alpha: 0.5),
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(statusIcon, size: 14, color: statusColor),
                                const SizedBox(width: 4),
                                Text(
                                  booking.status.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    color: statusColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        booking.serviceName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Agreed Rate: ',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                            ),
                          ),
                          Text(
                            '\$${booking.agreedRate.toInt()}/hr',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),

                      // Status Progress Indicator
                      if (!isCancelled) ...[
                        const SizedBox(height: 20),
                        _buildStatusProgress(booking.status, isDark),
                      ],
                    ],
                  ),
                ).animate().fadeIn(duration: 250.ms),

                const SizedBox(height: 18),

                // Scheduled Date & Time and Address Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        context,
                        icon: Icons.calendar_month_rounded,
                        iconColor: const Color(0xFF4F46E5),
                        title: 'Scheduled Date & Time',
                        value: DateFormat('EEEE, MMM dd, yyyy • hh:mm a').format(booking.scheduledDate),
                        isDark: isDark,
                      ),
                      Divider(height: 28, color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
                      _buildDetailRow(
                        context,
                        icon: Icons.location_on_rounded,
                        iconColor: const Color(0xFF0284C7),
                        title: 'Service Address',
                        value: booking.address.isNotEmpty ? booking.address : 'Address not specified',
                        isDark: isDark,
                      ),
                      if (booking.notes != null && booking.notes!.isNotEmpty) ...[
                        Divider(height: 28, color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
                        _buildDetailRow(
                          context,
                          icon: Icons.notes_rounded,
                          iconColor: const Color(0xFFD97706),
                          title: 'Job Instructions / Notes',
                          value: booking.notes!,
                          isDark: isDark,
                        ),
                      ],
                    ],
                  ),
                ).animate().fadeIn(delay: 100.ms),

                const SizedBox(height: 18),

                // Assigned Professional Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: booking.workerImageUrl != null && booking.workerImageUrl!.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: booking.workerImageUrl!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: AppColors.primarySoft,
                                    child: const Icon(Icons.person, color: AppColors.primary),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: AppColors.primarySoft,
                                    child: const Icon(Icons.person, color: AppColors.primary),
                                  ),
                                )
                              : Container(
                                  color: AppColors.primarySoft,
                                  child: const Icon(Icons.person, color: AppColors.primary),
                                ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    booking.workerName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.verified, size: 15, color: AppColors.primary),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Assigned Professional',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Chat Action Button
                      InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Get.toNamed(
                            AppRoutes.chatDetail,
                            arguments: {
                              'workerId': booking.workerId,
                              'workerName': booking.workerName,
                              'workerImageUrl': booking.workerImageUrl,
                            },
                          );
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFC7D2FE),
                            ),
                          ),
                          child: const Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 150.ms),

                const SizedBox(height: 30),

                // Bottom Action Buttons with Confirmation Dialog
                if (isConfirmed) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () async {
                        final confirmed = await ConfirmationBottomSheet.show(
                          context: context,
                          title: 'Cancel Booking?',
                          message: 'Are you sure you want to cancel this booking with ${booking.workerName}? The professional will be released.',
                          confirmText: 'Yes, Cancel Booking',
                          cancelText: 'Keep Booking',
                          icon: Icons.cancel_rounded,
                          iconColor: const Color(0xFFEF4444),
                          confirmButtonColor: const Color(0xFFEF4444),
                          isDestructive: true,
                          cancellationReasons: const [
                            'Change of plans / Emergency',
                            'Selected wrong time or date',
                            'Found another provider',
                            'Issue resolved already',
                            'Other reason',
                          ],
                        );

                        if (confirmed == true) {
                          await controller.updateStatus(booking.id, 'Cancelled');
                          currentBooking.value = currentBooking.value.copyWith(status: 'Cancelled');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cancel_outlined, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Cancel Booking',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                if (isCompleted) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Get.toNamed(AppRoutes.createReview, arguments: booking),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star_rounded, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Write a Review',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                if (isCancelled) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: isDark ? 0.15 : 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline_rounded, color: Color(0xFFEF4444), size: 18),
                        SizedBox(width: 8),
                        Text(
                          'This booking has been cancelled.',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStatusProgress(String status, bool isDark) {
    final steps = ['Booked', 'Confirmed', 'In Progress', 'Completed'];
    int activeIndex = 0;
    switch (status.toLowerCase()) {
      case 'pending':
        activeIndex = 0;
        break;
      case 'confirmed':
        activeIndex = 1;
        break;
      case 'inprogress':
        activeIndex = 2;
        break;
      case 'completed':
        activeIndex = 3;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(steps.length * 2 - 1, (index) {
            if (index.isOdd) {
              final stepIndex = index ~/ 2;
              final isDone = stepIndex < activeIndex;
              return Expanded(
                child: Container(
                  height: 3,
                  color: isDone
                      ? const Color(0xFF10B981)
                      : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                ),
              );
            } else {
              final stepIndex = index ~/ 2;
              final isDone = stepIndex <= activeIndex;
              return Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone
                      ? const Color(0xFF10B981)
                      : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                  border: Border.all(
                    color: isDone
                        ? const Color(0xFF10B981)
                        : (isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                      : Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                          ),
                        ),
                ),
              );
            }
          }),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: steps.map((s) {
            final isCur = steps.indexOf(s) == activeIndex;
            return Text(
              s,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isCur ? FontWeight.w800 : FontWeight.w500,
                color: isCur
                    ? (isDark ? Colors.white : const Color(0xFF0F172A))
                    : (isDark ? AppColors.textSecondaryDark : const Color(0xFF94A3B8)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 19, color: iconColor),
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
                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
