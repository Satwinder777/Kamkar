import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/constants/lottie_assets.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/models/booking_model.dart';
import 'booking_controller.dart';

class BookingListView extends GetView<BookingController> {
  const BookingListView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                height: 40,
                child: Obx(
                  () {
                    final selectedStatus = controller.selectedFilterStatus.value;
                    final tabs = ['All', 'Confirmed', 'InProgress', 'Completed', 'Cancelled'];
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: tabs.map((tab) {
                        final isSelected = selectedStatus == tab;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => controller.filterByStatus(tab),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : (isDark ? AppColors.surfaceDark : Colors.white),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : (isDark ? AppColors.borderDark : AppColors.borderLight),
                                ),
                              ),
                              child: Text(
                                tab,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),

            // Bookings List
            Expanded(
              child: Obx(() {
                final isLoading = controller.isLoading.value;
                final bookingList = controller.bookings.toList();

                if (isLoading && bookingList.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  );
                }

                if (bookingList.isEmpty) {
                  return EmptyStateWidget(
                    title: 'No Bookings Found',
                    message: 'You currently have no services booked in this category.',
                    lottieUrl: LottieAssets.emptyBox,
                    buttonText: 'Explore Workers',
                    onButtonPressed: () => Get.toNamed(AppRoutes.marketplace),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.fetchMyBookings,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: bookingList.length,
                    itemBuilder: (context, index) {
                      final booking = bookingList[index];
                      return _buildBookingCard(context, booking, isDark);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, Booking booking, bool isDark) {
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
      case 'rejected':
        statusColor = AppColors.error;
        break;
      default:
        statusColor = AppColors.warning;
    }

    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.bookingDetail, arguments: booking),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
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
                    booking.serviceName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                StatusBadge(text: booking.status.toUpperCase(), color: statusColor),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.person_outline_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  booking.workerName,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${booking.agreedRate.toStringAsFixed(0)}/hr',
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
                const SizedBox(width: 6),
                Text(
                  DateFormat('MMM dd, yyyy • hh:mm a').format(booking.scheduledDate),
                  style: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.05, end: 0);
  }
}
