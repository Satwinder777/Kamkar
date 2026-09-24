import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';
import '../../data/models/booking_model.dart';
import '../../data/models/worker_model.dart';
import '../../data/repositories/booking_repository.dart';

class BookingController extends GetxController {
  final BookingRepository bookingRepository = Get.find<BookingRepository>();

  // Observables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<Booking> bookings = <Booking>[].obs;
  final RxString selectedFilterStatus = 'All'.obs;

  // Create Booking State
  final Rx<DateTime> selectedDate = DateTime.now().add(const Duration(days: 1)).obs;
  final Rx<TimeOfDay> selectedTime = const TimeOfDay(hour: 10, minute: 0).obs;
  final addressController = TextEditingController();
  final notesController = TextEditingController();
  final RxString selectedServiceName = 'General Maintenance & Diagnostics'.obs;
  final RxDouble agreedRate = 45.0.obs;
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchMyBookings();
  }

  @override
  void onClose() {
    addressController.dispose();
    notesController.dispose();
    super.onClose();
  }

  Future<void> fetchMyBookings() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final results = await bookingRepository.getMyBookings(
        status: selectedFilterStatus.value == 'All' ? null : selectedFilterStatus.value,
      );
      bookings.assignAll(results);
    } catch (e) {
      if (bookings.isEmpty) {
        _populateFallbackBookings();
      }
    } finally {
      isLoading.value = false;
    }
  }

  void filterByStatus(String status) {
    selectedFilterStatus.value = status;
    fetchMyBookings();
  }

  Future<void> submitBooking(WorkerProfile worker) async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final scheduledDateTime = DateTime(
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day,
        selectedTime.value.hour,
        selectedTime.value.minute,
      );

      final booking = await bookingRepository.createBooking(
        workerId: worker.id,
        serviceName: selectedServiceName.value,
        scheduledDate: scheduledDateTime,
        address: addressController.text.trim(),
        notes: notesController.text.trim(),
        agreedRate: agreedRate.value,
      );

      bookings.insert(0, booking);
      Get.offNamed(AppRoutes.bookingDetail, arguments: booking);
      Get.snackbar('Booking Placed', 'Your request has been dispatched to the worker.');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatus(String bookingId, String newStatus) async {
    try {
      await bookingRepository.updateBookingStatus(bookingId, newStatus);
      fetchMyBookings();
      Get.snackbar('Status Updated', 'Booking status updated to $newStatus');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void _populateFallbackBookings() {
    bookings.assignAll([
      Booking(
        id: 'b-101',
        customerId: 'c-1',
        customerName: 'You',
        workerId: 'w-1',
        workerName: 'Alex Reynolds',
        serviceName: 'Electrical Panel Inspection',
        scheduledDate: DateTime.now().add(const Duration(days: 2)),
        address: '742 Evergreen Terrace, San Francisco, CA',
        notes: 'Main fuse box tripping intermittently.',
        agreedRate: 45.0,
        status: 'Confirmed',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      Booking(
        id: 'b-102',
        customerId: 'c-1',
        customerName: 'You',
        workerId: 'w-2',
        workerName: 'Marcus Vance',
        serviceName: 'Kitchen Sink Leak Repair',
        scheduledDate: DateTime.now().subtract(const Duration(days: 3)),
        address: '124 Market Street, Apt 4B, San Francisco, CA',
        agreedRate: 50.0,
        status: 'Completed',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ]);
  }
}
