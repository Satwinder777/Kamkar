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
      final list = await remoteDataSource.getNotifications();
      if (list.isNotEmpty) return list;
      return List<AppNotification>.from(MockDataProvider.mockNotifications);
    } catch (_) {
      return List<AppNotification>.from(MockDataProvider.mockNotifications);
    }
  }

  Future<int> getUnreadCount() async {
    if (AppConfig.isMockMode) {
      return MockDataProvider.mockNotifications.where((n) => !n.isRead).length;
    }
    try {
      return await remoteDataSource.getUnreadCount();
    } catch (_) {
      return MockDataProvider.mockNotifications.where((n) => !n.isRead).length;
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

  Future<void> markAllAsRead() async {
    if (AppConfig.isMockMode) {
      for (int i = 0; i < MockDataProvider.mockNotifications.length; i++) {
        final n = MockDataProvider.mockNotifications[i];
        MockDataProvider.mockNotifications[i] = AppNotification(
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
      await remoteDataSource.markAllAsRead();
    } catch (_) {}
  }

  Stream<Map<String, dynamic>> get liveNotifications => signalRService.notificationStream;
}
