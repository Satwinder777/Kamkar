import '../../core/config/app_config.dart';
import '../../core/network/signalr_service.dart';
import '../datasources/notification_remote_data_source.dart';
import '../mock/mock_data_provider.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;
  final SignalRService signalRService;

  NotificationRepository({
    required this.remoteDataSource,
    required this.signalRService,
  });

  Future<List<AppNotification>> getNotifications() async {
    if (AppConfig.isMockMode) {
      await Future.delayed(const Duration(milliseconds: 200));
      return List<AppNotification>.from(MockDataProvider.mockNotifications);
    }
    try {
      return await remoteDataSource.getNotifications();
    } catch (_) {
      return List<AppNotification>.from(MockDataProvider.mockNotifications);
    }
  }

  Future<void> markAsRead(String notificationId) async {
    if (AppConfig.isMockMode) {
      final idx = MockDataProvider.mockNotifications.indexWhere((n) => n.id == notificationId);
      if (idx != -1) {
        final n = MockDataProvider.mockNotifications[idx];
        MockDataProvider.mockNotifications[idx] = AppNotification(
          id: n.id,
          title: n.title,
          message: n.message,
          type: n.type,
          createdAt: n.createdAt,
          isRead: true,
          targetId: n.targetId,
        );
      }
      return;
    }
    try {
      await remoteDataSource.markAsRead(notificationId);
    } catch (_) {}
  }

  Stream<Map<String, dynamic>> get liveNotifications => signalRService.notificationStream;
}
