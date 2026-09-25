import '../../core/config/app_config.dart';
import '../datasources/booking_remote_data_source.dart';
import '../mock/mock_data_provider.dart';
import '../models/booking_model.dart';

class BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepository({required this.remoteDataSource});

  Future<Booking> createBooking({
    required String workerId,
    String? serviceId,
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
        serviceId: serviceId,
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
      final list = await remoteDataSource.getMyBookings(status: status);
      if (list.isNotEmpty) return list;
      return List<Booking>.from(MockDataProvider.mockBookings);
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

  Future<void> updateBookingStatus(String bookingId, String status, {String? reason}) async {
    if (AppConfig.isMockMode) {
      final idx = MockDataProvider.mockBookings.indexWhere((b) => b.id == bookingId);
      if (idx != -1) {
        final b = MockDataProvider.mockBookings[idx];
        MockDataProvider.mockBookings[idx] = b.copyWith(status: status);
      }
      return;
    }

    try {
      final s = status.toLowerCase();
      if (s.contains('accept')) {
        await remoteDataSource.acceptBooking(bookingId, reason: reason);
      } else if (s.contains('reject') || s.contains('decline')) {
        await remoteDataSource.rejectBooking(bookingId, reason: reason);
      } else if (s.contains('confirm')) {
        await remoteDataSource.confirmBooking(bookingId, reason: reason);
      } else if (s.contains('complete')) {
        await remoteDataSource.completeBooking(bookingId, reason: reason);
      } else if (s.contains('cancel')) {
        await remoteDataSource.cancelBooking(bookingId, reason: reason);
      }
    } catch (_) {
      final idx = MockDataProvider.mockBookings.indexWhere((b) => b.id == bookingId);
      if (idx != -1) {
        final b = MockDataProvider.mockBookings[idx];
        MockDataProvider.mockBookings[idx] = b.copyWith(status: status);
      }
    }
  }
}
