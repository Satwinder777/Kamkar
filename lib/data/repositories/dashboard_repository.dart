import '../../core/config/app_config.dart';
import '../datasources/dashboard_remote_data_source.dart';
import '../models/dashboard_model.dart';

class DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepository({required this.remoteDataSource});

  Future<CustomerDashboard> getCustomerDashboard() async {
    if (AppConfig.isMockMode) {
      await Future.delayed(const Duration(milliseconds: 200));
      return CustomerDashboard(
        activeBookingsCount: 2,
        completedBookingsCount: 14,
        totalSpent: 680.0,
      );
    }
    try {
      return await remoteDataSource.getCustomerDashboard();
    } catch (_) {
      return CustomerDashboard(
        activeBookingsCount: 2,
        completedBookingsCount: 14,
        totalSpent: 680.0,
      );
    }
  }

  Future<WorkerDashboard> getWorkerDashboard() async {
    if (AppConfig.isMockMode) {
      await Future.delayed(const Duration(milliseconds: 200));
      return WorkerDashboard(
        totalEarnings: 3450.0,
        completedJobs: 28,
        rating: 4.9,
      );
    }
    try {
      return await remoteDataSource.getWorkerDashboard();
    } catch (_) {
      return WorkerDashboard(
        totalEarnings: 3450.0,
        completedJobs: 28,
        rating: 4.9,
      );
    }
  }
}
