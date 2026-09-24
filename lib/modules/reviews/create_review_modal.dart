import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../data/models/booking_model.dart';

class CreateReviewModal extends StatefulWidget {
  final Booking booking;

  const CreateReviewModal({super.key, required this.booking});

  @override
  State<CreateReviewModal> createState() => _CreateReviewModalState();
}

class _CreateReviewModalState extends State<CreateReviewModal> {
  double selectedRating = 5.0;
  final commentController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void _submitReview() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => isLoading = false);
    Get.back();
    Get.snackbar(
      'Review Submitted',
      'Thank you for rating ${widget.booking.workerName}!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Rate Service Quality',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'How was your experience with ${widget.booking.workerName}?',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 20),

          // 5-Star Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starValue = index + 1.0;
              final isFilled = selectedRating >= starValue;
              return IconButton(
                iconSize: 36,
                icon: Icon(
                  isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                  color: const Color(0xFFF59E0B),
                ),
                onPressed: () {
                  setState(() {
                    selectedRating = starValue;
                  });
                },
              );
            }),
          ),
          const SizedBox(height: 16),

          CustomTextField(
            controller: commentController,
            label: 'Your Review',
            hint: 'Describe the craftsmanship, punctuality, and overall work...',
            maxLines: 3,
          ),

          const SizedBox(height: 24),

          CustomButton(
            text: 'Submit Review',
            isLoading: isLoading,
            onPressed: _submitReview,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
