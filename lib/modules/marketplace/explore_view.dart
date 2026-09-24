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
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.loadCatalogAndWorkers,
          color: AppColors.primary,
          child: CustomScrollView(
            slivers: [
              // Top App Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'KAMKAR',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Find Verified Pros',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  letterSpacing: -0.5,
                                ),
                          ),
                        ],
                      ),
                      // Notification Bell
                      IconButton(
                        onPressed: () => Get.toNamed(AppRoutes.notifications),
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            ),
                          ),
                          child: Icon(
                            Icons.notifications_outlined,
                            size: 20,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Search Bar & Filter Button
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.surfaceDark : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: controller.searchController,
                            onChanged: (val) => controller.searchQuery.value = val,
                            style: TextStyle(
                              fontSize: 14.5,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search Electrician, Plumber, HVAC...',
                              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                              suffixIcon: Obx(
                                () => controller.searchQuery.value.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear_rounded, size: 18),
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
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Filter Button
                      InkWell(
                        onTap: () => _showFilterBottomSheet(context),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Categories Horizontal List
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: SizedBox(
                    height: 42,
                    child: Obx(
                      () {
                        final selected = controller.selectedWorkerType.value;
                        final list = [
                          'All Trades',
                          'Electrician',
                          'Plumbing',
                          'HVAC',
                          'Carpentry',
                          'Painting',
                        ];
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: list.map((name) {
                            final isSelected = (name == 'All Trades' && selected == null) ||
                                (selected?.name == name);

                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
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
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: AppColors.primary.withValues(alpha: 0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Text(
                                    name,
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
                      return WorkerCard(
                        id: worker.id,
                        fullName: worker.fullName,
                        workerType: worker.workerType,
                        hourlyRate: worker.hourlyRate,
                        rating: worker.rating,
                        reviewsCount: worker.reviewsCount,
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

              const SliverToBoxAdapter(child: SizedBox(height: 80)),
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
