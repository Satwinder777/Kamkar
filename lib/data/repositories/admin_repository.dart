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
      return await remoteDataSource.getVerificationRequests(status: status);
    } catch (_) {
      return List<VerificationRequest>.from(MockDataProvider.mockAdminRequests);
    }
  }

  Future<void> approveWorker(String workerId) async {
    if (AppConfig.isMockMode) {
      MockDataProvider.mockAdminRequests.removeWhere((r) => r.workerId == workerId);
      return;
    }
    try {
      await remoteDataSource.submitVerificationDecision(
        workerId: workerId,
        isApproved: true,
      );
    } catch (_) {
      MockDataProvider.mockAdminRequests.removeWhere((r) => r.workerId == workerId);
    }
  }

  Future<void> rejectWorker(String workerId, String reason) async {
    if (AppConfig.isMockMode) {
      MockDataProvider.mockAdminRequests.removeWhere((r) => r.workerId == workerId);
      return;
    }
    try {
      await remoteDataSource.submitVerificationDecision(
        workerId: workerId,
        isApproved: false,
        rejectionReason: reason,
      );
    } catch (_) {
      MockDataProvider.mockAdminRequests.removeWhere((r) => r.workerId == workerId);
    }
  }
}
