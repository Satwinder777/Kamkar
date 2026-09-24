import 'package:get/get.dart';
import '../../modules/admin/admin_controller.dart';
import '../../modules/admin/admin_verification_detail_view.dart';
import '../../modules/admin/admin_verification_list_view.dart';
import '../../modules/auth/auth_controller.dart';
import '../../modules/auth/login_view.dart';
import '../../modules/auth/otp_verification_view.dart';
import '../../modules/auth/register_view.dart';
import '../../modules/auth/splash_view.dart';
import '../../modules/onboarding/onboarding_controller.dart';
import '../../modules/onboarding/onboarding_view.dart';
import '../../modules/booking/booking_controller.dart';
import '../../modules/booking/booking_detail_view.dart';
import '../../modules/booking/booking_list_view.dart';
import '../../modules/booking/create_booking_view.dart';
import '../../modules/chat/chat_controller.dart';
import '../../modules/chat/chat_detail_view.dart';
import '../../modules/chat/conversation_list_view.dart';
import '../../modules/customer/customer_dashboard_controller.dart';
import '../../modules/customer/customer_dashboard_view.dart';
import '../../modules/customer/customer_profile_view.dart';
import '../../modules/main_nav/main_nav_controller.dart';
import '../../modules/main_nav/main_nav_view.dart';
import '../../modules/marketplace/explore_view.dart';
import '../../modules/marketplace/marketplace_controller.dart';
import '../../modules/marketplace/worker_detail_view.dart';
import '../../modules/notifications/notification_controller.dart';
import '../../modules/notifications/notification_list_view.dart';
import '../../modules/settings/settings_controller.dart';
import '../../modules/settings/user_settings_view.dart';
import '../../modules/worker/pending_approval_view.dart';
import '../../modules/worker/worker_dashboard_controller.dart';
import '../../modules/worker/worker_dashboard_view.dart';
import '../../modules/worker/worker_onboarding_view.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<OnboardingController>(() => OnboardingController());
      }),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.otpVerification,
      page: () => const OtpVerificationView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthController>(() => AuthController());
      }),
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainNavView(),
      bindings: [
        BindingsBuilder(() {
          Get.lazyPut<MainNavController>(() => MainNavController());
          Get.lazyPut<MarketplaceController>(() => MarketplaceController());
          Get.lazyPut<CustomerDashboardController>(() => CustomerDashboardController());
          Get.lazyPut<BookingController>(() => BookingController());
          Get.lazyPut<ChatController>(() => ChatController());
          Get.lazyPut<NotificationController>(() => NotificationController());
          Get.lazyPut<WorkerDashboardController>(() => WorkerDashboardController());
          Get.lazyPut<AdminController>(() => AdminController());
          Get.lazyPut<SettingsController>(() => SettingsController());
        }),
      ],
    ),
    GetPage(
      name: AppRoutes.marketplace,
      page: () => const ExploreView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<MarketplaceController>(() => MarketplaceController());
      }),
    ),
    GetPage(
      name: AppRoutes.workerDetail,
      page: () => const WorkerDetailView(),
    ),
    GetPage(
      name: AppRoutes.createBooking,
      page: () => const CreateBookingView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<BookingController>(() => BookingController());
      }),
    ),
    GetPage(
      name: AppRoutes.bookingList,
      page: () => const BookingListView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<BookingController>(() => BookingController());
      }),
    ),
    GetPage(
      name: AppRoutes.bookingDetail,
      page: () => const BookingDetailView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<BookingController>(() => BookingController());
      }),
    ),
    GetPage(
      name: AppRoutes.conversationList,
      page: () => const ConversationListView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ChatController>(() => ChatController());
      }),
    ),
    GetPage(
      name: AppRoutes.chatDetail,
      page: () => const ChatDetailView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ChatController>(() => ChatController());
      }),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationListView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<NotificationController>(() => NotificationController());
      }),
    ),
    GetPage(
      name: AppRoutes.customerDashboard,
      page: () => const CustomerDashboardView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<CustomerDashboardController>(() => CustomerDashboardController());
      }),
    ),
    GetPage(
      name: AppRoutes.customerProfile,
      page: () => const CustomerProfileView(),
    ),
    GetPage(
      name: AppRoutes.workerDashboard,
      page: () => const WorkerDashboardView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<WorkerDashboardController>(() => WorkerDashboardController());
      }),
    ),
    GetPage(
      name: AppRoutes.workerOnboarding,
      page: () => const WorkerOnboardingView(),
    ),
    GetPage(
      name: AppRoutes.workerPendingApproval,
      page: () => const PendingApprovalView(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const UserSettingsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SettingsController>(() => SettingsController());
      }),
    ),
    GetPage(
      name: AppRoutes.adminVerifications,
      page: () => const AdminVerificationListView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AdminController>(() => AdminController());
      }),
    ),
    GetPage(
      name: AppRoutes.adminVerificationDetail,
      page: () => const AdminVerificationDetailView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AdminController>(() => AdminController());
      }),
    ),
  ];
}
