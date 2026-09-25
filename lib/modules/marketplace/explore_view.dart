import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/constants/lottie_assets.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../core/widgets/worker_card.dart';
import '../../data/models/worker_model.dart';
import 'marketplace_controller.dart';

class ExploreView extends GetView<MarketplaceController> {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.loadCatalogAndWorkers,
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Top Modern Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Location selector & Brand
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.location_on_rounded,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Dubai Marina, UAE',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white70 : const Color(0xFF475569),
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 16,
                                color: isDark ? Colors.white54 : const Color(0xFF64748B),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Find Verified Pros',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22,
                                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                                  letterSpacing: -0.6,
                                ),
                          ),
                        ],
                      ),
                      // Action Icons
                      Row(
                        children: [
                          // Notification Bell with Badge
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              Get.toNamed(AppRoutes.notifications);
                            },
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.surfaceDark : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Icons.notifications_outlined,
                                    size: 21,
                                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 11,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEF4444),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Search Bar & Filter Button
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                  child: Row(
                    children: [
                      // Search Input Field
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: controller.searchController,
                            onChanged: (val) => controller.searchQuery.value = val,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Search trades, services, pros...',
                              hintStyle: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w400,
                                color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                              ),
                              prefixIcon: Container(
                                padding: const EdgeInsets.only(left: 14, right: 10),
                                child: const Icon(
                                  Icons.search_rounded,
                                  color: AppColors.primary,
                                  size: 22,
                                ),
                              ),
                              prefixIconConstraints: const BoxConstraints(
                                minWidth: 44,
                                minHeight: 44,
                              ),
                              suffixIcon: Obx(
                                () => controller.searchQuery.value.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear_rounded, size: 18),
                                        splashRadius: 18,
                                        color: isDark ? Colors.white70 : const Color(0xFF64748B),
                                        onPressed: () {
                                          controller.searchController.clear();
                                          controller.searchQuery.value = '';
                                        },
                                      )
                                    : const SizedBox.shrink(),
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Filter Button
                      InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _showFilterBottomSheet(context);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.tune_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Categories Horizontal List with Icons
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    height: 44,
                    child: Obx(
                      () {
                        final selected = controller.selectedWorkerType.value;
                        final trades = [
                          {'name': 'All Trades', 'icon': Icons.grid_view_rounded},
                          {'name': 'Electrician', 'icon': Icons.bolt_rounded},
                          {'name': 'Plumbing', 'icon': Icons.water_drop_rounded},
                          {'name': 'HVAC', 'icon': Icons.ac_unit_rounded},
                          {'name': 'Carpentry', 'icon': Icons.handyman_rounded},
                          {'name': 'Painting', 'icon': Icons.format_paint_rounded},
                        ];

                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          separatorBuilder: (context, index) => const SizedBox(width: 8),
                          itemCount: trades.length,
                          itemBuilder: (context, index) {
                            final trade = trades[index];
                            final name = trade['name'] as String;
                            final icon = trade['icon'] as IconData;
                            final isSelected = (name == 'All Trades' && selected == null) ||
                                (selected?.name == name);

                            return GestureDetector(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                if (name == 'All Trades') {
                                  controller.selectedWorkerType.value = null;
                                  controller.fetchWorkers();
                                } else {
                                  controller.selectedWorkerType.value = WorkerType(id: name, name: name);
                                  controller.fetchWorkers();
                                }
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                decoration: BoxDecoration(
                                  gradient: isSelected ? AppColors.primaryGradient : null,
                                  color: isSelected
                                      ? null
                                      : (isDark ? AppColors.surfaceDark : Colors.white),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                    width: 1.2,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primary.withValues(alpha: 0.35),
                                            blurRadius: 10,
                                            offset: const Offset(0, 3),
                                          ),
                                        ]
                                      : [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.02),
                                            blurRadius: 4,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      icon,
                                      size: 16,
                                      color: isSelected
                                          ? Colors.white
                                          : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      name,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                        color: isSelected
                                            ? Colors.white
                                            : (isDark ? AppColors.textPrimaryDark : const Color(0xFF334155)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Trust Guarantee Banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 2, 16, 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified_user_rounded,
                          size: 16,
                          color: Color(0xFF10B981),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '100% Background Checked & Licensed Tradesmen',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white70 : const Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Workers Listing / Empty State
              Obx(() {
                final isLoading = controller.isLoading.value;
                final workerList = controller.workers.toList();

                if (isLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                  );
                }

                if (workerList.isEmpty) {
                  return SliverFillRemaining(
                    child: EmptyStateWidget(
                      title: 'No Workers Found',
                      message: 'Try adjusting your search query or reset the applied filters.',
                      lottieUrl: LottieAssets.emptyBox,
                      buttonText: 'Reset Filters',
                      onButtonPressed: controller.resetFilters,
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final worker = workerList[index];
                      final coverPhoto = worker.portfolioPhotos.isNotEmpty
                          ? worker.portfolioPhotos.first
                          : null;

                      return WorkerCard(
                        id: worker.id,
                        fullName: worker.fullName,
                        workerType: worker.workerType,
                        profileImageUrl: worker.profileImageUrl,
                        coverImageUrl: coverPhoto,
                        hourlyRate: worker.hourlyRate,
                        rating: worker.rating,
                        reviewsCount: worker.reviewsCount,
                        jobsCompleted: worker.jobsCompleted,
                        city: worker.city,
                        isVerified: worker.isVerified,
                        isAvailable: worker.isAvailable,
                        onTap: () => controller.navigateToWorkerDetail(worker),
                        onBookTap: () => controller.navigateToBooking(worker),
                        onNegotiateTap: () => controller.navigateToNegotiation(worker),
                      );
                    },
                    childCount: workerList.length,
                  ),
                );
              }),

              const SliverToBoxAdapter(child: SizedBox(height: 90)),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
              'Filter Professionals',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            // Min Rating Slider
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Minimum Rating', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('${controller.minRatingFilter.value.toStringAsFixed(1)} ★',
                          style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.warning)),
                    ],
                  ),
                  Slider(
                    value: controller.minRatingFilter.value,
                    min: 0.0,
                    max: 5.0,
                    divisions: 10,
                    activeColor: AppColors.primary,
                    onChanged: (val) => controller.minRatingFilter.value = val,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Max Rate Slider
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Max Hourly Rate', style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('\$${controller.maxHourlyRateFilter.value.toInt()}/hr',
                          style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
                    ],
                  ),
                  Slider(
                    value: controller.maxHourlyRateFilter.value,
                    min: 20.0,
                    max: 200.0,
                    divisions: 18,
                    activeColor: AppColors.primary,
                    onChanged: (val) => controller.maxHourlyRateFilter.value = val,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.resetFilters();
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.fetchWorkers();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
