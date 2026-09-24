import 'package:flutter_test/flutter_test.dart';
import 'package:kamkar/data/models/user_model.dart';
import 'package:kamkar/data/models/worker_model.dart';
import 'package:kamkar/data/models/booking_model.dart';
import 'package:kamkar/data/models/chat_model.dart';
import 'package:kamkar/data/models/notification_model.dart';

void main() {
  group('Model Serialization Tests', () {
    test('UserModel fromJson and toJson serialization', () {
      final json = {
        'id': 'u-101',
        'email': 'satwinder@example.com',
        'fullName': 'Satwinder Singh',
        'phoneNumber': '+1234567890',
        'role': 'Worker',
        'isProfileComplete': true,
        'verificationStatus': 'Approved',
      };

      final user = UserModel.fromJson(json);
      expect(user.id, 'u-101');
      expect(user.email, 'satwinder@example.com');
      expect(user.fullName, 'Satwinder Singh');
      expect(user.role, 'Worker');
      expect(user.isProfileComplete, true);
      expect(user.verificationStatus, 'Approved');

      final outputJson = user.toJson();
      expect(outputJson['email'], 'satwinder@example.com');
      expect(outputJson['role'], 'Worker');
    });

    test('WorkerProfile fromJson parsing', () {
      final json = {
        'id': 'w-1',
        'userId': 'u-1',
        'fullName': 'Alex Reynolds',
        'workerType': 'Electrician',
        'hourlyRate': 45.0,
        'rating': 4.9,
        'reviewsCount': 120,
        'jobsCompleted': 300,
        'isVerified': true,
        'isAvailable': true,
      };

      final worker = WorkerProfile.fromJson(json);
      expect(worker.id, 'w-1');
      expect(worker.fullName, 'Alex Reynolds');
      expect(worker.hourlyRate, 45.0);
      expect(worker.rating, 4.9);
      expect(worker.isVerified, true);
    });

    test('Booking fromJson parsing and state mapping', () {
      final json = {
        'id': 'b-1',
        'customerId': 'c-1',
        'customerName': 'John',
        'workerId': 'w-1',
        'workerName': 'Alex',
        'serviceName': 'Panel Replacement',
        'scheduledDate': '2026-09-30T10:00:00.000Z',
        'address': '123 Main St',
        'agreedRate': 50.0,
        'status': 'Confirmed',
        'createdAt': '2026-09-24T12:00:00.000Z',
      };

      final booking = Booking.fromJson(json);
      expect(booking.id, 'b-1');
      expect(booking.serviceName, 'Panel Replacement');
      expect(booking.agreedRate, 50.0);
      expect(booking.status, 'Confirmed');
    });

    test('ChatMessage parsing with sender matching', () {
      final json = {
        'id': 'msg-1',
        'threadId': 't-1',
        'senderId': 'user-1',
        'senderName': 'John',
        'message': 'Offer \$40/hr',
        'proposedRate': 40.0,
        'rateStatus': 'Proposed',
        'createdAt': '2026-09-24T12:00:00.000Z',
      };

      final msg = ChatMessage.fromJson(json, currentUserId: 'user-1');
      expect(msg.isMine, true);
      expect(msg.proposedRate, 40.0);
      expect(msg.rateStatus, 'Proposed');
    });

    test('AppNotification fromJson parsing', () {
      final json = {
        'id': 'notif-1',
        'title': 'New Message',
        'message': 'You have a counter offer',
        'type': 'ChatOffer',
        'isRead': false,
        'createdAt': '2026-09-24T12:00:00.000Z',
      };

      final notif = AppNotification.fromJson(json);
      expect(notif.title, 'New Message');
      expect(notif.type, 'ChatOffer');
      expect(notif.isRead, false);
    });
  });
}
