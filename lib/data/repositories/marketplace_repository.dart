import '../../core/config/app_config.dart';
import '../datasources/marketplace_remote_data_source.dart';
import '../mock/mock_data_provider.dart';
import '../models/worker_model.dart';

class MarketplaceRepository {
  final MarketplaceRemoteDataSource remoteDataSource;

  MarketplaceRepository({required this.remoteDataSource});

  Future<List<WorkerType>> getWorkerTypes() async {
    if (AppConfig.isMockMode) {
      return MockDataProvider.getMockWorkerTypes();
    }
    try {
      return await remoteDataSource.getWorkerTypes();
    } catch (_) {
      return MockDataProvider.getMockWorkerTypes();
    }
  }

  Future<List<ServiceItem>> getServices({String? workerTypeId}) async {
    if (AppConfig.isMockMode) {
      final workers = MockDataProvider.getMockWorkers();
      return workers.expand((w) => w.services).toList();
    }
    try {
      return await remoteDataSource.getServices(workerTypeId: workerTypeId);
    } catch (_) {
      final workers = MockDataProvider.getMockWorkers();
      return workers.expand((w) => w.services).toList();
    }
  }

  Future<List<WorkerProfile>> searchWorkers({
    String? query,
    String? workerTypeId,
    double? minRating,
    double? maxHourlyRate,
    String? city,
    bool? isAvailable,
    int page = 1,
    int pageSize = 20,
  }) async {
    if (AppConfig.isMockMode) {
      await Future.delayed(const Duration(milliseconds: 250));
      var list = MockDataProvider.getMockWorkers();

      if (query != null && query.trim().isNotEmpty) {
        final q = query.toLowerCase().trim();
        list = list.where((w) {
          return w.fullName.toLowerCase().contains(q) ||
              w.workerType.toLowerCase().contains(q) ||
              (w.city?.toLowerCase().contains(q) == true) ||
              w.services.any((s) => s.name.toLowerCase().contains(q));
        }).toList();
      }

      if (workerTypeId != null && workerTypeId.isNotEmpty && workerTypeId != 'All Trades') {
        list = list.where((w) => w.workerType.toLowerCase() == workerTypeId.toLowerCase()).toList();
      }

      if (minRating != null && minRating > 0) {
        list = list.where((w) => w.rating >= minRating).toList();
      }

      if (maxHourlyRate != null && maxHourlyRate > 0) {
        list = list.where((w) => w.hourlyRate <= maxHourlyRate).toList();
      }

      return list;
    }

    try {
      return await remoteDataSource.searchWorkers(
        query: query,
        workerTypeId: workerTypeId,
        minRating: minRating,
        maxHourlyRate: maxHourlyRate,
        city: city,
        isAvailable: isAvailable,
        page: page,
        pageSize: pageSize,
      );
    } catch (_) {
      return MockDataProvider.getMockWorkers();
    }
  }

  Future<WorkerProfile> getWorkerDetail(String workerId) async {
    if (AppConfig.isMockMode) {
      final workers = MockDataProvider.getMockWorkers();
      return workers.firstWhere(
        (w) => w.id == workerId,
        orElse: () => workers.first,
      );
    }
    try {
      return await remoteDataSource.getWorkerDetail(workerId);
    } catch (_) {
      final workers = MockDataProvider.getMockWorkers();
      return workers.firstWhere(
        (w) => w.id == workerId,
        orElse: () => workers.first,
      );
    }
  }
}
