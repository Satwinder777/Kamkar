import 'package:get/get.dart';
import '../network/api_client.dart';
import '../network/signalr_service.dart';
import '../storage/secure_storage_service.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/datasources/marketplace_remote_data_source.dart';
import '../../data/datasources/booking_remote_data_source.dart';
import '../../data/datasources/chat_remote_data_source.dart';
import '../../data/datasources/notification_remote_data_source.dart';
import '../../data/datasources/dashboard_remote_data_source.dart';
import '../../data/datasources/admin_remote_data_source.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/marketplace_repository.dart';
import '../../data/repositories/booking_repository.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../data/repositories/admin_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Storage
    final storageService = Get.isRegistered<SecureStorageService>()
        ? Get.find<SecureStorageService>()
        : Get.put<SecureStorageService>(SecureStorageService(), permanent: true);

    // Network & Realtime
    final apiClient = Get.put<ApiClient>(ApiClient(storageService: storageService), permanent: true);
    final signalRService = Get.put<SignalRService>(SignalRService(storageService: storageService), permanent: true);

    // DataSources
    Get.lazyPut<AuthRemoteDataSource>(() => AuthRemoteDataSource(apiClient: apiClient), fenix: true);
    Get.lazyPut<MarketplaceRemoteDataSource>(() => MarketplaceRemoteDataSource(apiClient: apiClient), fenix: true);
    Get.lazyPut<BookingRemoteDataSource>(() => BookingRemoteDataSource(apiClient: apiClient), fenix: true);
    Get.lazyPut<ChatRemoteDataSource>(() => ChatRemoteDataSource(apiClient: apiClient), fenix: true);
    Get.lazyPut<NotificationRemoteDataSource>(() => NotificationRemoteDataSource(apiClient: apiClient), fenix: true);
    Get.lazyPut<DashboardRemoteDataSource>(() => DashboardRemoteDataSource(apiClient: apiClient), fenix: true);
    Get.lazyPut<AdminRemoteDataSource>(() => AdminRemoteDataSource(apiClient: apiClient), fenix: true);

    // Repositories
    Get.lazyPut<AuthRepository>(
      () => AuthRepository(
        remoteDataSource: Get.find<AuthRemoteDataSource>(),
        storageService: storageService,
      ),
      fenix: true,
    );
    Get.lazyPut<MarketplaceRepository>(
      () => MarketplaceRepository(
        remoteDataSource: Get.find<MarketplaceRemoteDataSource>(),
      ),
      fenix: true,
    );
    Get.lazyPut<BookingRepository>(
      () => BookingRepository(
        remoteDataSource: Get.find<BookingRemoteDataSource>(),
      ),
      fenix: true,
    );
    Get.lazyPut<ChatRepository>(
      () => ChatRepository(
        remoteDataSource: Get.find<ChatRemoteDataSource>(),
        signalRService: signalRService,
      ),
      fenix: true,
    );
    Get.lazyPut<NotificationRepository>(
      () => NotificationRepository(
        remoteDataSource: Get.find<NotificationRemoteDataSource>(),
        signalRService: signalRService,
      ),
      fenix: true,
    );
    Get.lazyPut<DashboardRepository>(
      () => DashboardRepository(
        remoteDataSource: Get.find<DashboardRemoteDataSource>(),
      ),
      fenix: true,
    );
    Get.lazyPut<AdminRepository>(
      () => AdminRepository(
        remoteDataSource: Get.find<AdminRemoteDataSource>(),
      ),
      fenix: true,
    );
  }
}
