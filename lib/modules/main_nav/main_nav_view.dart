import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../core/widgets/floating_nav_bar.dart';
import '../admin/admin_verification_list_view.dart';
import '../booking/booking_list_view.dart';
import '../chat/conversation_list_view.dart';
import '../customer/customer_dashboard_view.dart';
import '../customer/customer_profile_view.dart';
import '../marketplace/explore_view.dart';
import '../settings/user_settings_view.dart';
import '../worker/worker_dashboard_view.dart';
import 'main_nav_controller.dart';

class MainNavView extends GetView<MainNavController> {
  const MainNavView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isWorker) {
        return _buildWorkerNav();
      } else if (controller.isAdmin) {
        return _buildAdminNav();
      } else {
        return _buildCustomerNav();
      }
    });
  }

  Widget _buildCustomerNav() {
    final pages = [
      const ExploreView(),
      const CustomerDashboardView(),
      const BookingListView(),
      const ConversationListView(),
      const CustomerProfileView(),
    ];

    final tabs = const [
      GButton(icon: Icons.explore_rounded, text: 'Explore'),
      GButton(icon: Icons.dashboard_rounded, text: 'Hub'),
      GButton(icon: Icons.calendar_today_rounded, text: 'Bookings'),
      GButton(icon: Icons.chat_bubble_rounded, text: 'Chats'),
      GButton(icon: Icons.person_rounded, text: 'Profile'),
    ];

    return Scaffold(
      body: IndexedStack(
        index: controller.currentIndex.value,
        children: pages,
      ),
      bottomNavigationBar: FloatingNavBar(
        selectedIndex: controller.currentIndex.value,
        onTabChange: controller.changeTab,
        tabs: tabs,
      ),
    );
  }

  Widget _buildWorkerNav() {
    final pages = [
      const WorkerDashboardView(),
      const BookingListView(),
      const ConversationListView(),
      const UserSettingsView(),
    ];

    final tabs = const [
      GButton(icon: Icons.speed_rounded, text: 'Hub'),
      GButton(icon: Icons.assignment_rounded, text: 'Jobs'),
      GButton(icon: Icons.chat_bubble_rounded, text: 'Chats'),
      GButton(icon: Icons.settings_rounded, text: 'Settings'),
    ];

    return Scaffold(
      body: IndexedStack(
        index: controller.currentIndex.value.clamp(0, pages.length - 1),
        children: pages,
      ),
      bottomNavigationBar: FloatingNavBar(
        selectedIndex: controller.currentIndex.value.clamp(0, pages.length - 1),
        onTabChange: controller.changeTab,
        tabs: tabs,
      ),
    );
  }

  Widget _buildAdminNav() {
    final pages = [
      const AdminVerificationListView(),
      const ExploreView(),
      const UserSettingsView(),
    ];

    final tabs = const [
      GButton(icon: Icons.verified_user_rounded, text: 'Queue'),
      GButton(icon: Icons.explore_rounded, text: 'Directory'),
      GButton(icon: Icons.settings_rounded, text: 'Settings'),
    ];

    return Scaffold(
      body: IndexedStack(
        index: controller.currentIndex.value.clamp(0, pages.length - 1),
        children: pages,
      ),
      bottomNavigationBar: FloatingNavBar(
        selectedIndex: controller.currentIndex.value.clamp(0, pages.length - 1),
        onTabChange: controller.changeTab,
        tabs: tabs,
      ),
    );
  }
}
