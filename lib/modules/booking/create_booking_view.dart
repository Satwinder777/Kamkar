import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../data/models/worker_model.dart';
import 'booking_controller.dart';

class CreateBookingView extends GetView<BookingController> {
  const CreateBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    final worker = Get.arguments as WorkerProfile? ??
        WorkerProfile(
          id: 'w1',
          userId: 'u1',
          fullName: 'Alex Reynolds',
          workerType: 'Master Electrician',
          hourlyRate: 45.0,
          rating: 4.9,
          reviewsCount: 128,
        );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Service'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Worker Snapshot Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
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
                          child: Icon(Icons.engineering_rounded, color: AppColors.primary, size: 28),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              worker.fullName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              worker.workerType,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${worker.hourlyRate.toInt()}/hr',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms),

                const SizedBox(height: 24),
                // Service Type
                Text(
                  'Selected Service Task',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedServiceName.value,
                        isExpanded: true,
                        dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
                        items: [
                          'General Maintenance & Diagnostics',
                          'Emergency Repair',
                          'Installation & Replacement',
                          'Inspection & Safety Check',
                        ].map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 14)))).toList(),
                        onChanged: (val) {
                          if (val != null) controller.selectedServiceName.value = val;
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                // Date & Time Selectors
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Date', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Obx(
                            () => InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: controller.selectedDate.value,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 90)),
                                );
                                if (picked != null) controller.selectedDate.value = picked;
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.surfaceDark : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      DateFormat('MMM dd, yyyy').format(controller.selectedDate.value),
                                      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Time', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Obx(
                            () => InkWell(
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: controller.selectedTime.value,
                                );
                                if (picked != null) controller.selectedTime.value = picked;
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.surfaceDark : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.schedule_rounded, color: AppColors.primary, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      controller.selectedTime.value.format(context),
                                      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                // Service Location
                CustomTextField(
                  controller: controller.addressController,
                  label: 'Service Location Address',
                  hint: '123 Market St, Suite 400',
                  prefixIcon: Icons.location_on_outlined,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Address is required';
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                // Work Notes
                CustomTextField(
                  controller: controller.notesController,
                  label: 'Job Notes / Problem Details',
                  hint: 'Describe what needs to be fixed or installed...',
                  maxLines: 3,
                ),

                const SizedBox(height: 32),
                // Submit Button
                Obx(
                  () => CustomButton(
                    text: 'Confirm & Dispatch Request',
                    isLoading: controller.isLoading.value,
                    onPressed: () => controller.submitBooking(worker),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
