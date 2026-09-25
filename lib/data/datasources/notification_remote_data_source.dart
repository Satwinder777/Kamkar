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

  Future<int> getUnreadCount() async {
    final response = await apiClient.get(ApiConstants.unreadNotificationsCount);
    if (response is Map<String, dynamic>) {
      return (response['unreadCount'] as num?)?.toInt() ?? 0;
    } else if (response is num) {
      return response.toInt();
    }
    return 0;
  }

  Future<void> markAsRead(String notificationId) async {
    await apiClient.post('${ApiConstants.notifications}/$notificationId/read');
  }

  Future<void> markAllAsRead() async {
    await apiClient.post(ApiConstants.markAllNotificationsRead);
  }
}
