import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/notification_model.dart';

class NotificationRemoteDataSource {
  final ApiClient apiClient;

  NotificationRemoteDataSource({required this.apiClient});

  Future<List<AppNotification>> getNotifications() async {
    final response = await apiClient.get(ApiConstants.notifications);
    if (response is List) {
      return response.map((e) => AppNotification.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<void> markAsRead(String notificationId) async {
    await apiClient.put('${ApiConstants.markNotificationRead}/$notificationId/read');
  }
}
