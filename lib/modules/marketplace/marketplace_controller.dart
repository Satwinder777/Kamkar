import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/worker_model.dart';
import '../../data/repositories/marketplace_repository.dart';

class MarketplaceController extends GetxController {
  final MarketplaceRepository marketplaceRepository = Get.find<MarketplaceRepository>();

  // State
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<WorkerType> workerTypes = <WorkerType>[].obs;
  final RxList<WorkerProfile> workers = <WorkerProfile>[].obs;
  final Rx<WorkerType?> selectedWorkerType = Rx<WorkerType?>(null);

  // Search & Filter State
  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxDouble minRatingFilter = 0.0.obs;
  final RxDouble maxHourlyRateFilter = 200.0.obs;
  final RxBool onlyAvailableFilter = false.obs;
  final RxString selectedCity = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCatalogAndWorkers();
    debounce(
      searchQuery,
      (_) => fetchWorkers(),
      time: const Duration(milliseconds: 400),
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> loadCatalogAndWorkers() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final types = await marketplaceRepository.getWorkerTypes();
      workerTypes.assignAll(types);
      await fetchWorkers();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchWorkers() async {
    try {
      final results = await marketplaceRepository.searchWorkers(
        query: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        workerTypeId: selectedWorkerType.value?.id,
        minRating: minRatingFilter.value > 0 ? minRatingFilter.value : null,
        maxHourlyRate: maxHourlyRateFilter.value < 200 ? maxHourlyRateFilter.value : null,
        isAvailable: onlyAvailableFilter.value ? true : null,
        city: selectedCity.value.isNotEmpty ? selectedCity.value : null,
      );
      workers.assignAll(results);
    } catch (e) {
      // If local mock / offline, fallback to sample workers
      if (workers.isEmpty) {
        _populateFallbackWorkers();
      }
    }
  }

  void selectWorkerType(WorkerType? type) {
    if (selectedWorkerType.value?.id == type?.id) {
      selectedWorkerType.value = null;
    } else {
      selectedWorkerType.value = type;
    }
    fetchWorkers();
  }

  void resetFilters() {
    minRatingFilter.value = 0.0;
    maxHourlyRateFilter.value = 200.0;
    onlyAvailableFilter.value = false;
    selectedCity.value = '';
    fetchWorkers();
  }

  void navigateToWorkerDetail(WorkerProfile worker) {
    Get.toNamed(AppRoutes.workerDetail, arguments: worker);
  }

  void navigateToNegotiation(WorkerProfile worker) {
    Get.toNamed(
      AppRoutes.chatDetail,
      arguments: {
        'workerId': worker.id,
        'workerName': worker.fullName,
        'hourlyRate': worker.hourlyRate,
      },
    );
  }

  void navigateToBooking(WorkerProfile worker) {
    Get.toNamed(
      AppRoutes.createBooking,
      arguments: worker,
    );
  }

  void _populateFallbackWorkers() {
    workers.assignAll([
      WorkerProfile(
        id: 'w1',
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
      ),
      WorkerProfile(
        id: 'w2',
        userId: 'u2',
        fullName: 'Marcus Vance',
        workerType: 'Plumber & Pipefitter',
        hourlyRate: 50.0,
        rating: 4.8,
        reviewsCount: 94,
        jobsCompleted: 210,
        isVerified: true,
        isAvailable: true,
        city: 'San Francisco, CA',
        bio: 'Emergency leak repair, water heater replacement, copper & PEX repiping specialist.',
      ),
      WorkerProfile(
        id: 'w3',
        userId: 'u3',
        fullName: 'David Sterling',
        workerType: 'HVAC Specialist',
        hourlyRate: 55.0,
        rating: 5.0,
        reviewsCount: 76,
        jobsCompleted: 150,
        isVerified: true,
        isAvailable: false,
        city: 'Oakland, CA',
        bio: 'AC maintenance, furnace diagnostics, smart thermostat integration.',
      ),
      WorkerProfile(
        id: 'w4',
        userId: 'u4',
        fullName: 'Elena Rostova',
        workerType: 'Finish Carpenter',
        hourlyRate: 40.0,
        rating: 4.9,
        reviewsCount: 110,
        jobsCompleted: 280,
        isVerified: true,
        isAvailable: true,
        city: 'San Jose, CA',
        bio: 'Custom cabinetry, crown molding, door repairs, and bespoke woodworking.',
      ),
    ]);
  }
}
