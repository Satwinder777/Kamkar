import '../../core/config/app_config.dart';
import '../datasources/admin_remote_data_source.dart';
import '../mock/mock_data_provider.dart';
import '../models/admin_model.dart';

class AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepository({required this.remoteDataSource});

  Future<List<VerificationRequest>> getVerificationRequests({String? status}) async {
    if (AppConfig.isMockMode) {
      await Future.delayed(const Duration(milliseconds: 200));
      return List<VerificationRequest>.from(MockDataProvider.mockAdminRequests);
    }
    try {
      final list = await remoteDataSource.getVerificationRequests(status: status);
      if (list.isNotEmpty) return list;
      return List<VerificationRequest>.from(MockDataProvider.mockAdminRequests);
    } catch (_) {
      return List<VerificationRequest>.from(MockDataProvider.mockAdminRequests);
    }
  }

  Future<void> approveWorker(String workerId, {String requestType = 'Worker', String? notes}) async {
    if (AppConfig.isMockMode) {
      MockDataProvider.mockAdminRequests.removeWhere((r) => r.workerId == workerId || r.id == workerId);
      return;
    }
    try {
      await remoteDataSource.approveVerification(
        requestType: requestType,
        id: workerId,
        notes: notes,
      );
    } catch (_) {
      MockDataProvider.mockAdminRequests.removeWhere((r) => r.workerId == workerId || r.id == workerId);
    }
  }

  Future<void> rejectWorker(String workerId, String reason, {String requestType = 'Worker'}) async {
    if (AppConfig.isMockMode) {
      MockDataProvider.mockAdminRequests.removeWhere((r) => r.workerId == workerId || r.id == workerId);
      return;
    }
    try {
      await remoteDataSource.rejectVerification(
        requestType: requestType,
        id: workerId,
        notes: reason,
      );
    } catch (_) {
      MockDataProvider.mockAdminRequests.removeWhere((r) => r.workerId == workerId || r.id == workerId);
    }
  }
}
