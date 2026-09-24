import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/admin_model.dart';

class AdminRemoteDataSource {
  final ApiClient apiClient;

  AdminRemoteDataSource({required this.apiClient});

  Future<List<VerificationRequest>> getVerificationRequests({String? status}) async {
    final response = await apiClient.get(
      ApiConstants.adminVerifications,
      queryParameters: status != null ? {'status': status} : null,
    );
    if (response is List) {
      return response.map((e) => VerificationRequest.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<void> submitVerificationDecision({
    required String workerId,
    required bool isApproved,
    String? rejectionReason,
  }) async {
    await apiClient.post(
      '${ApiConstants.adminVerificationDecision}/$workerId/decision',
      data: {
        'isApproved': isApproved,
        'rejectionReason': rejectionReason,
      },
    );
  }
}
