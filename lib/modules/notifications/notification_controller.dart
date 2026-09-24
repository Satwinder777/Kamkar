import 'dart:async';
import 'package:get/get.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';

class NotificationController extends GetxController {
  final NotificationRepository notificationRepository = Get.find<NotificationRepository>();

  final RxBool isLoading = false.obs;
  final RxList<AppNotification> notifications = <AppNotification>[].obs;
  StreamSubscription? _notifSubscription;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    _listenToLiveNotifications();
  }

  @override
  void onClose() {
    _notifSubscription?.cancel();
    super.onClose();
  }

  void _listenToLiveNotifications() {
    _notifSubscription = notificationRepository.liveNotifications.listen((data) {
      final notif = AppNotification.fromJson(data);
      notifications.insert(0, notif);
      Get.snackbar(notif.title, notif.message, snackPosition: SnackPosition.TOP);
    });
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final list = await notificationRepository.getNotifications();
      notifications.assignAll(list);
    } catch (e) {
      if (notifications.isEmpty) {
        _populateFallbackNotifications();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String notifId) async {
    try {
      await notificationRepository.markAsRead(notifId);
      final idx = notifications.indexWhere((n) => n.id == notifId);
      if (idx != -1) {
        final current = notifications[idx];
        notifications[idx] = AppNotification(
          id: current.id,
          title: current.title,
          message: current.message,
          type: current.type,
          targetId: current.targetId,
          isRead: true,
          createdAt: current.createdAt,
        );
      }
    } catch (_) {}
  }

  void _populateFallbackNotifications() {
    notifications.assignAll([
      AppNotification(
        id: 'n-1',
        title: 'Rate Offer Accepted',
        message: 'Alex Reynolds agreed to your offer of \$45/hr for Panel Inspection.',
        type: 'ChatOffer',
        targetId: 't-1',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      AppNotification(
        id: 'n-2',
        title: 'Booking Confirmed',
        message: 'Your electrical service booking for Friday at 10:00 AM has been scheduled.',
        type: 'BookingUpdate',
        targetId: 'b-101',
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      AppNotification(
        id: 'n-3',
        title: 'Identity Verification Approved',
        message: 'Your trade credentials have been verified by compliance.',
        type: 'Verification',
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ]);
  }
}
