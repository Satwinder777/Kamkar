import 'package:flutter_test/flutter_test.dart';
import 'package:kamkar/core/config/app_config.dart';
import 'package:kamkar/data/mock/mock_data_provider.dart';

void main() {
  group('MockDataProvider Tests', () {
    test('AppConfig isMockMode is enabled', () {
      expect(AppConfig.isMockMode, isTrue);
    });

    test('getMockUser returns valid role-based profiles', () {
      final customer = MockDataProvider.getMockUser(role: 'Customer');
      expect(customer.role, 'Customer');
      expect(customer.isProfileComplete, isTrue);

      final worker = MockDataProvider.getMockUser(email: 'worker@example.com');
      expect(worker.role, 'Worker');

      final admin = MockDataProvider.getMockUser(email: 'admin@kamkar.com');
      expect(admin.role, 'Admin');
    });

    test('getMockWorkerTypes returns comprehensive trade categories', () {
      final trades = MockDataProvider.getMockWorkerTypes();
      expect(trades.isNotEmpty, isTrue);
      expect(trades.any((t) => t.name == 'Electrician'), isTrue);
      expect(trades.any((t) => t.name == 'Plumbing'), isTrue);
    });

    test('getMockWorkers returns populated verified worker profiles with services', () {
      final workers = MockDataProvider.getMockWorkers();
      expect(workers.isNotEmpty, isTrue);
      for (final worker in workers) {
        expect(worker.id.isNotEmpty, isTrue);
        expect(worker.fullName.isNotEmpty, isTrue);
        expect(worker.hourlyRate, greaterThan(0));
        expect(worker.services.isNotEmpty, isTrue);
        expect(worker.portfolioPhotos.isNotEmpty, isTrue);
      }
    });

    test('mockBookings contains realistic sample bookings', () {
      final bookings = MockDataProvider.mockBookings;
      expect(bookings.isNotEmpty, isTrue);
      expect(bookings.any((b) => b.status == 'Confirmed'), isTrue);
    });

    test('mockThreads and mockMessages contain negotiation data', () {
      final threads = MockDataProvider.mockThreads;
      expect(threads.isNotEmpty, isTrue);
      final messages = MockDataProvider.mockMessages['th_301'];
      expect(messages != null && messages.isNotEmpty, isTrue);
      expect(messages!.any((m) => m.proposedRate != null), isTrue);
    });

    test('mockNotifications has valid notification items', () {
      final notifs = MockDataProvider.mockNotifications;
      expect(notifs.isNotEmpty, isTrue);
      expect(notifs.first.targetId, isNotNull);
    });

    test('mockAdminRequests has pending verification profiles', () {
      final adminReqs = MockDataProvider.mockAdminRequests;
      expect(adminReqs.isNotEmpty, isTrue);
      expect(adminReqs.first.status, 'Pending');
    });
  });
}
