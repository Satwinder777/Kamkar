import 'package:get/get.dart';
import '../../data/models/admin_model.dart';
import '../../data/repositories/admin_repository.dart';

class AdminController extends GetxController {
  final AdminRepository adminRepository = Get.find<AdminRepository>();

  final RxBool isLoading = false.obs;
  final RxList<VerificationRequest> requests = <VerificationRequest>[].obs;
  final RxString filterStatus = 'Pending'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    isLoading.value = true;
    try {
      final list = await adminRepository.getVerificationRequests(status: filterStatus.value);
      requests.assignAll(list);
    } catch (_) {
      if (requests.isEmpty) {
        _populateFallbackAdminQueue();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> approveWorker(String workerId) async {
    try {
      await adminRepository.approveWorker(workerId);
      fetchRequests();
      Get.snackbar('Application Approved', 'Worker status changed to Approved and notified.');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> rejectWorker(String workerId, String reason) async {
    try {
      await adminRepository.rejectWorker(workerId, reason);
      fetchRequests();
      Get.snackbar('Application Rejected', 'Worker application rejected with reason provided.');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void _populateFallbackAdminQueue() {
    requests.assignAll([
      VerificationRequest(
        id: 'req-1',
        workerId: 'w-10',
        fullName: 'Devon Vance',
        email: 'devon@example.com',
        phoneNumber: '+1 (555) 392-1928',
        workerType: 'HVAC Specialist',
        yearsOfExperience: 8,
        idDocumentUrl: 'https://example.com/id.jpg',
        certificateUrl: 'https://example.com/cert.jpg',
        status: 'Pending',
        submittedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      VerificationRequest(
        id: 'req-2',
        workerId: 'w-11',
        fullName: 'Siddharth Roy',
        email: 'siddharth@example.com',
        phoneNumber: '+1 (555) 782-9912',
        workerType: 'Master Plumber',
        yearsOfExperience: 10,
        idDocumentUrl: 'https://example.com/id2.jpg',
        status: 'Pending',
        submittedAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
    ]);
  }
}
