import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/widgets/floating_nav_bar.dart';
import '../admin/admin_verification_list_view.dart';
import '../booking/booking_list_view.dart';
import '../chat/conversation_list_view.dart';
import '../customer/customer_dashboard_view.dart';
import '../customer/customer_profile_view.dart';
import '../marketplace/explore_view.dart';
import '../settings/user_settings_view.dart';
import '../worker/worker_dashboard_view.dart';
import '../worker/worker_profile_view.dart';
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

    const items = [
      NavItem(icon: Icons.explore_outlined, activeIcon: Icons.explore_rounded, label: 'Explore'),
      NavItem(icon: Icons.grid_view_outlined, activeIcon: Icons.grid_view_rounded, label: 'Hub'),
      NavItem(icon: Icons.calendar_today_outlined, activeIcon: Icons.calendar_month_rounded, label: 'Bookings'),
      NavItem(icon: Icons.chat_bubble_outline_rounded, activeIcon: Icons.chat_bubble_rounded, label: 'Chats'),
      NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profile'),
    ];

    return Scaffold(
      body: IndexedStack(
        index: controller.currentIndex.value,
        children: pages,
      ),
      bottomNavigationBar: FloatingNavBar(
        selectedIndex: controller.currentIndex.value,
        onTabChange: controller.changeTab,
        items: items,
      ),
    );
  }

  Widget _buildWorkerNav() {
    final pages = [
      const WorkerDashboardView(),
      const BookingListView(),
      const ConversationListView(),
      const WorkerProfileView(),
    ];

    const items = [
      NavItem(icon: Icons.speed_outlined, activeIcon: Icons.speed_rounded, label: 'Hub'),
      NavItem(icon: Icons.assignment_outlined, activeIcon: Icons.assignment_rounded, label: 'Jobs'),
      NavItem(icon: Icons.chat_bubble_outline_rounded, activeIcon: Icons.chat_bubble_rounded, label: 'Chats'),
      NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profile'),
    ];

    return Scaffold(
      body: IndexedStack(
        index: controller.currentIndex.value.clamp(0, pages.length - 1),
        children: pages,
      ),
      bottomNavigationBar: FloatingNavBar(
        selectedIndex: controller.currentIndex.value.clamp(0, pages.length - 1),
        onTabChange: controller.changeTab,
        items: items,
      ),
    );
  }

  Widget _buildAdminNav() {
    final pages = [
      const AdminVerificationListView(),
      const ExploreView(),
      const UserSettingsView(),
    ];

    const items = [
      NavItem(icon: Icons.verified_user_outlined, activeIcon: Icons.verified_user_rounded, label: 'Queue'),
      NavItem(icon: Icons.explore_outlined, activeIcon: Icons.explore_rounded, label: 'Directory'),
      NavItem(icon: Icons.settings_outlined, activeIcon: Icons.settings_rounded, label: 'Settings'),
    ];

    return Scaffold(
      body: IndexedStack(
        index: controller.currentIndex.value.clamp(0, pages.length - 1),
        children: pages,
      ),
      bottomNavigationBar: FloatingNavBar(
        selectedIndex: controller.currentIndex.value.clamp(0, pages.length - 1),
        onTabChange: controller.changeTab,
        items: items,
      ),
    );
  }
}

