import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/booking_model.dart';

class BookingRemoteDataSource {
  final ApiClient apiClient;

  BookingRemoteDataSource({required this.apiClient});

  Future<Booking> createBooking({
    required String workerId,
    required String serviceName,
    required DateTime scheduledDate,
    required String address,
    String? notes,
    required double agreedRate,
  }) async {
    final response = await apiClient.post(
      ApiConstants.bookings,
      data: {
        'workerId': workerId,
        'serviceName': serviceName,
        'scheduledDate': scheduledDate.toIso8601String(),
        'address': address,
        'notes': notes,
        'agreedRate': agreedRate,
      },
    );
    return Booking.fromJson(response as Map<String, dynamic>);
  }

  Future<List<Booking>> getMyBookings({String? status}) async {
    final response = await apiClient.get(
      ApiConstants.myBookings,
      queryParameters: status != null ? {'status': status} : null,
    );
    if (response is List) {
      return response.map((e) => Booking.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<Booking> getBookingDetail(String bookingId) async {
    final response = await apiClient.get('${ApiConstants.bookings}/$bookingId');
    return Booking.fromJson(response as Map<String, dynamic>);
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    await apiClient.put(
      '${ApiConstants.bookingStatus}/$bookingId/status',
      data: {'status': status},
    );
  }
}
