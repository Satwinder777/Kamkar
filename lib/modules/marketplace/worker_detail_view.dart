import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../data/models/worker_model.dart';

class WorkerDetailView extends StatelessWidget {
  const WorkerDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final worker = Get.arguments as WorkerProfile? ??
        WorkerProfile(
          id: 'demo-w1',
          userId: 'u1',
          fullName: 'Alex Reynolds',
          workerType: 'Master Electrician',
          hourlyRate: 45.0,
          rating: 4.9,
          reviewsCount: 128,
          jobsCompleted: 340,
          isVerified: true,
          isAvailable: true,
          city: 'San Francisco, CA',
          bio: 'Licensed Master Electrician with 12+ years experience in residential wiring, panel upgrades, and EV charger installations.',
        );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsible Image App Bar
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'worker-img-${worker.id}',
                    child: Container(
                      color: isDark ? AppColors.cardDark : const Color(0xFFE2E8F0),
                      child: Center(
                        child: Icon(
                          Icons.engineering_rounded,
                          size: 72,
                          color: isDark ? AppColors.textSecondaryDark : const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ),
                  // Vignette overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.6),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Worker Details Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full Name & Verified Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              worker.fullName,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              worker.workerType,
                              style: TextStyle(
                                fontSize: 14.5,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          '\$${worker.hourlyRate.toStringAsFixed(0)}/hr',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 300.ms),

                  const SizedBox(height: 20),

                  // 3 Key Metric Cards
                  Row(
                    children: [
                      _buildMetricCard(
                        context,
                        title: 'Rating',
                        value: '${worker.rating.toStringAsFixed(1)} ★',
                        subtitle: '${worker.reviewsCount} reviews',
                        isDark: isDark,
                      ),
                      const SizedBox(width: 10),
                      _buildMetricCard(
                        context,
                        title: 'Completed',
                        value: '${worker.jobsCompleted}+',
                        subtitle: 'Jobs done',
                        isDark: isDark,
                      ),
                      const SizedBox(width: 10),
                      _buildMetricCard(
                        context,
                        title: 'Identity',
                        value: 'Verified',
                        subtitle: 'Gov ID Checked',
                        isDark: isDark,
                      ),
                    ],
                  ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1, end: 0),

                  const SizedBox(height: 24),

                  // About / Bio
                  Text(
                    'About Professional',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    worker.bio ?? 'Verified professional offering high-standard trade craftsmanship and reliable service.',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Offered Services
                  Text(
                    'Specialty Services',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Diagnostics & Inspection',
                      'Panel Upgrades',
                      'Emergency Wiring',
                      'Smart Home Setup',
                      'Commercial Maintenance',
                    ]
                        .map(
                          (service) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.cardDark : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                              ),
                            ),
                            child: Text(
                              service,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Action Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          border: Border(
            top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Negotiate',
                isOutlined: true,
                onPressed: () {
                  Get.toNamed(
                    AppRoutes.chatDetail,
                    arguments: {
                      'workerId': worker.id,
                      'workerName': worker.fullName,
                      'hourlyRate': worker.hourlyRate,
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: CustomButton(
                text: 'Book Consultation',
                onPressed: () {
                  Get.toNamed(
                    AppRoutes.createBooking,
                    arguments: worker,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
