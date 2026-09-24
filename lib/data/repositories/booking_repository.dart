import '../../core/config/app_config.dart';
import '../datasources/booking_remote_data_source.dart';
import '../mock/mock_data_provider.dart';
import '../models/booking_model.dart';

class BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepository({required this.remoteDataSource});

  Future<Booking> createBooking({
    required String workerId,
    required String serviceName,
    required DateTime scheduledDate,
    required String address,
    String? notes,
    required double agreedRate,
  }) async {
    if (AppConfig.isMockMode) {
      await Future.delayed(const Duration(milliseconds: 350));
      final newBooking = Booking(
        id: 'b_${DateTime.now().millisecondsSinceEpoch}',
        customerId: 'usr_mock_101',
        customerName: 'Satwinder Singh',
        workerId: workerId,
        workerName: 'Verified Pro',
        serviceName: serviceName,
        status: 'Confirmed',
        scheduledDate: scheduledDate,
        address: address,
        notes: notes,
        agreedRate: agreedRate,
        createdAt: DateTime.now(),
      );
      MockDataProvider.mockBookings.insert(0, newBooking);
      return newBooking;
    }

    try {
      return await remoteDataSource.createBooking(
        workerId: workerId,
        serviceName: serviceName,
        scheduledDate: scheduledDate,
        address: address,
        notes: notes,
        agreedRate: agreedRate,
      );
    } catch (_) {
      final newBooking = Booking(
        id: 'b_${DateTime.now().millisecondsSinceEpoch}',
        customerId: 'usr_mock_101',
        customerName: 'Satwinder Singh',
        workerId: workerId,
        workerName: 'Verified Pro',
        serviceName: serviceName,
        status: 'Confirmed',
        scheduledDate: scheduledDate,
        address: address,
        notes: notes,
        agreedRate: agreedRate,
        createdAt: DateTime.now(),
      );
      MockDataProvider.mockBookings.insert(0, newBooking);
      return newBooking;
    }
  }

  Future<List<Booking>> getMyBookings({String? status}) async {
    if (AppConfig.isMockMode) {
      await Future.delayed(const Duration(milliseconds: 250));
      if (status != null && status != 'All' && status.isNotEmpty) {
        return MockDataProvider.mockBookings
            .where((b) => b.status.toLowerCase() == status.toLowerCase())
            .toList();
      }
      return List<Booking>.from(MockDataProvider.mockBookings);
    }

    try {
      return await remoteDataSource.getMyBookings(status: status);
    } catch (_) {
      if (status != null && status != 'All' && status.isNotEmpty) {
        return MockDataProvider.mockBookings
            .where((b) => b.status.toLowerCase() == status.toLowerCase())
            .toList();
      }
      return List<Booking>.from(MockDataProvider.mockBookings);
    }
  }

  Future<Booking> getBookingDetail(String bookingId) async {
    if (AppConfig.isMockMode) {
      return MockDataProvider.mockBookings.firstWhere(
        (b) => b.id == bookingId,
        orElse: () => MockDataProvider.mockBookings.first,
      );
    }

    try {
      return await remoteDataSource.getBookingDetail(bookingId);
    } catch (_) {
      return MockDataProvider.mockBookings.firstWhere(
        (b) => b.id == bookingId,
        orElse: () => MockDataProvider.mockBookings.first,
      );
    }
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    if (AppConfig.isMockMode) {
      final idx = MockDataProvider.mockBookings.indexWhere((b) => b.id == bookingId);
      if (idx != -1) {
        final b = MockDataProvider.mockBookings[idx];
        MockDataProvider.mockBookings[idx] = Booking(
          id: b.id,
          customerId: b.customerId,
          customerName: b.customerName,
          workerId: b.workerId,
          workerName: b.workerName,
          serviceName: b.serviceName,
          status: status,
          scheduledDate: b.scheduledDate,
          address: b.address,
          agreedRate: b.agreedRate,
          notes: b.notes,
          createdAt: b.createdAt,
        );
      }
      return;
    }

    try {
      await remoteDataSource.updateBookingStatus(bookingId, status);
    } catch (_) {}
  }
}
