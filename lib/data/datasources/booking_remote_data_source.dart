import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/booking_model.dart';

class BookingRemoteDataSource {
  final ApiClient apiClient;

  BookingRemoteDataSource({required this.apiClient});

  Future<Booking> createBooking({
    required String workerId,
    String? serviceId,
    required String serviceName,
    required DateTime scheduledDate,
    required String address,
    String? notes,
    required double agreedRate,
  }) async {
    final response = await apiClient.post(
      ApiConstants.bookings,
      data: {
        'workerProfileId': workerId,
        'serviceId': serviceId,
        'scheduledStartUtc': scheduledDate.toIso8601String(),
        'scheduledEndUtc': scheduledDate.add(const Duration(hours: 2)).toIso8601String(),
        'addressLine': address,
        'city': 'Dubai',
        'state': 'Dubai',
        'country': 'United Arab Emirates',
        'latitude': 25.0772,
        'longitude': 55.1378,
        'notes': notes ?? 'Service requested via Kamkar App',
      },
    );
    return Booking.fromJson(response as Map<String, dynamic>);
  }

  Future<List<Booking>> getMyBookings({String? status}) async {
    final response = await apiClient.get(
      ApiConstants.bookings,
      queryParameters: status != null ? {'status': status} : null,
    );
    if (response is List) {
      return response.map((e) => Booking.fromJson(e as Map<String, dynamic>)).toList();
    } else if (response is Map<String, dynamic> && response['items'] is List) {
      return (response['items'] as List)
          .map((e) => Booking.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<Booking> getBookingDetail(String bookingId) async {
    final response = await apiClient.get('${ApiConstants.bookings}/$bookingId');
    return Booking.fromJson(response as Map<String, dynamic>);
  }

  Future<void> acceptBooking(String bookingId, {String? reason}) async {
    await apiClient.post(
      '${ApiConstants.bookings}/$bookingId/accept',
      data: {'reason': reason ?? 'Accepted by craftsman'},
    );
  }

  Future<void> rejectBooking(String bookingId, {String? reason}) async {
    await apiClient.post(
      '${ApiConstants.bookings}/$bookingId/reject',
      data: {'reason': reason ?? 'Declined by craftsman'},
    );
  }

  Future<void> confirmBooking(String bookingId, {String? reason}) async {
    await apiClient.post(
      '${ApiConstants.bookings}/$bookingId/confirm',
      data: {'reason': reason ?? 'Confirmed by customer'},
    );
  }

  Future<void> completeBooking(String bookingId, {String? reason}) async {
    await apiClient.post(
      '${ApiConstants.bookings}/$bookingId/complete',
      data: {'reason': reason ?? 'Work completed successfully'},
    );
  }

  Future<void> cancelBooking(String bookingId, {String? reason}) async {
    await apiClient.post(
      '${ApiConstants.bookings}/$bookingId/cancel',
      data: {'reason': reason ?? 'Cancelled by user'},
    );
  }
}
