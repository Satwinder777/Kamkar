import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/dashboard_model.dart';

class DashboardRemoteDataSource {
  final ApiClient apiClient;

  DashboardRemoteDataSource({required this.apiClient});

  Future<CustomerDashboard> getCustomerDashboard() async {
    final response = await apiClient.get(ApiConstants.customerDashboard);
    return CustomerDashboard.fromJson(response as Map<String, dynamic>);
  }

  Future<WorkerDashboard> getWorkerDashboard() async {
    final response = await apiClient.get(ApiConstants.workerDashboard);
    return WorkerDashboard.fromJson(response as Map<String, dynamic>);
  }
}
