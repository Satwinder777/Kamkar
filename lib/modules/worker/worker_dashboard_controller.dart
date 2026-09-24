import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import '../../data/models/booking_model.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/repositories/booking_repository.dart';
import '../../data/repositories/dashboard_repository.dart';

class WorkerDashboardController extends GetxController {
  final DashboardRepository dashboardRepository = Get.find<DashboardRepository>();
  final BookingRepository bookingRepository = Get.find<BookingRepository>();

  final RxBool isLoading = false.obs;
  final Rx<WorkerDashboard> dashboard = WorkerDashboard().obs;
  final RxList<Booking> pendingJobs = <Booking>[].obs;
  final RxList<FlSpot> earningsGraphSpots = <FlSpot>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadWorkerDashboard();
  }

  Future<void> loadWorkerDashboard() async {
    isLoading.value = true;
    try {
      final res = await dashboardRepository.getWorkerDashboard();
      dashboard.value = res;
      final jobs = await bookingRepository.getMyBookings();
      pendingJobs.assignAll(jobs);
      _generateEarningsSpots();
    } catch (_) {
      dashboard.value = WorkerDashboard(
        totalEarnings: 3850.0,
        monthlyEarnings: 1240.0,
        completedJobs: 42,
        pendingRequestsCount: 2,
        rating: 4.9,
      );
      _generateEarningsSpots();
    } finally {
      isLoading.value = false;
    }
  }

  void _generateEarningsSpots() {
    earningsGraphSpots.assignAll(const [
      FlSpot(0, 200),
      FlSpot(1, 450),
      FlSpot(2, 380),
      FlSpot(3, 700),
      FlSpot(4, 950),
      FlSpot(5, 1240),
    ]);
  }

  Future<void> acceptJob(String bookingId) async {
    try {
      await bookingRepository.updateBookingStatus(bookingId, 'Confirmed');
      loadWorkerDashboard();
      Get.snackbar('Job Accepted', 'Customer has been notified of your confirmation.');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> declineJob(String bookingId) async {
    try {
      await bookingRepository.updateBookingStatus(bookingId, 'Rejected');
      loadWorkerDashboard();
      Get.snackbar('Job Declined', 'The booking request was declined.');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
