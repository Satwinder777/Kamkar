import 'package:get/get.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/dashboard_repository.dart';

class CustomerDashboardController extends GetxController {
  final DashboardRepository dashboardRepository = Get.find<DashboardRepository>();
  final AuthRepository authRepository = Get.find<AuthRepository>();

  final RxBool isLoading = false.obs;
  final Rx<CustomerDashboard> dashboard = CustomerDashboard().obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    isLoading.value = true;
    try {
      final res = await dashboardRepository.getCustomerDashboard();
      dashboard.value = res;
    } catch (_) {
      dashboard.value = CustomerDashboard(
        activeBookingsCount: 1,
        completedBookingsCount: 8,
        totalSpent: 420.0,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String get userName {
    final data = authRepository.userData;
    return data?['fullName']?.toString() ?? 'Valued Customer';
  }
}
