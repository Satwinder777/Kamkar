import '../models/admin_model.dart';
import '../models/booking_model.dart';
import '../models/chat_model.dart';
import '../models/notification_model.dart';
import '../models/user_model.dart';
import '../models/worker_model.dart';

class MockDataProvider {
  // Mock Current User
  static UserModel getMockUser({String? email, String? role, String? fullName}) {
    final effectiveRole = role ?? (email?.contains('worker') == true
        ? 'Worker'
        : email?.contains('admin') == true
            ? 'Admin'
            : email?.contains('org') == true
                ? 'Organisation'
                : 'Customer');

    return UserModel(
      id: 'usr_mock_101',
      email: email ?? 'satwinder@example.com',
      fullName: fullName ?? (effectiveRole == 'Worker' ? 'Rajesh Sharma (Pro)' : 'Satwinder Singh'),
      phoneNumber: '+1 (555) 234-5678',
      role: effectiveRole,
      isProfileComplete: true,
      verificationStatus: 'Approved',
      profileImageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
    );
  }

  // Mock Worker Types
  static List<WorkerType> getMockWorkerTypes() {
    return [
      WorkerType(id: 't_all', name: 'All Trades', description: 'All available verified trades'),
      WorkerType(id: 't_elec', name: 'Electrician', description: 'Wiring, circuit repairs & installations'),
      WorkerType(id: 't_plumb', name: 'Plumbing', description: 'Pipe leaks, fittings & sanitary ware'),
      WorkerType(id: 't_hvac', name: 'HVAC', description: 'AC repair, heating & ventilation systems'),
      WorkerType(id: 't_carp', name: 'Carpentry', description: 'Furniture making, wood fitting & locks'),
      WorkerType(id: 't_paint', name: 'Painting', description: 'Interior/exterior wall painting & polish'),
    ];
  }

  // Mock Workers
  static List<WorkerProfile> getMockWorkers() {
    return [
      WorkerProfile(
        id: 'w_101',
        userId: 'u_101',
        fullName: 'Rajesh Sharma',
        workerType: 'Electrician',
        workerTypeId: 't_elec',
        hourlyRate: 45.0,
        rating: 4.9,
        reviewsCount: 124,
        jobsCompleted: 180,
        city: 'Dubai / Downtown',
        bio: 'Licensed Master Electrician with 8+ years of residential & commercial wiring experience. Fast fault detection and smart home automation setup.',
        isVerified: true,
        isAvailable: true,
        services: [
          ServiceItem(id: 's_1', workerTypeId: 't_elec', name: 'Short Circuit Diagnosis', basePrice: 45.0, description: 'Troubleshoot tripping breakers & wiring faults'),
          ServiceItem(id: 's_2', workerTypeId: 't_elec', name: 'Light & Chandelier Fitting', basePrice: 35.0, description: 'Ceiling fans, chandeliers & LED spotlights'),
          ServiceItem(id: 's_3', workerTypeId: 't_elec', name: 'Full DB Box Upgrade', basePrice: 120.0, description: 'Main distribution board overhaul & safety testing'),
        ],
        portfolioPhotos: [
          'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=600',
          'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=600',
        ],
      ),
      WorkerProfile(
        id: 'w_102',
        userId: 'u_102',
        fullName: 'Mohammed Al-Hashmi',
        workerType: 'Plumbing',
        workerTypeId: 't_plumb',
        hourlyRate: 40.0,
        rating: 4.8,
        reviewsCount: 89,
        jobsCompleted: 110,
        city: 'Dubai / Marina',
        bio: 'Expert plumbing contractor. Specialised in emergency leak repair, bathroom sanitary installations, and high-pressure water pumps.',
        isVerified: true,
        isAvailable: true,
        services: [
          ServiceItem(id: 's_4', workerTypeId: 't_plumb', name: 'Leak Fixing & Pipe Replacement', basePrice: 40.0, description: 'Under-sink & concealed wall leaks'),
          ServiceItem(id: 's_5', workerTypeId: 't_plumb', name: 'Water Heater Repair', basePrice: 55.0, description: 'Element replacement & pressure valve check'),
        ],
        portfolioPhotos: [
          'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=600',
          'https://images.unsplash.com/photo-1541888946425-d0fbb18086f6?w=600',
        ],
      ),
      WorkerProfile(
        id: 'w_103',
        userId: 'u_103',
        fullName: 'Vikram Patel',
        workerType: 'HVAC',
        workerTypeId: 't_hvac',
        hourlyRate: 60.0,
        rating: 5.0,
        reviewsCount: 156,
        jobsCompleted: 230,
        city: 'Dubai / Business Bay',
        bio: 'Certified HVAC & Air Conditioning Specialist. Gas top-up, deep coil jet cleaning, compressor diagnostics and duct sanitation.',
        isVerified: true,
        isAvailable: true,
        services: [
          ServiceItem(id: 's_6', workerTypeId: 't_hvac', name: 'AC Deep Jet Chemical Clean', basePrice: 60.0, description: 'Indoor & outdoor unit flush with antibacterial wash'),
          ServiceItem(id: 's_7', workerTypeId: 't_hvac', name: 'Gas Refrigerant Refill', basePrice: 75.0, description: 'R410A / R22 gas top-up with pressure test'),
        ],
        portfolioPhotos: [
          'https://images.unsplash.com/photo-1581092335397-9583fe92d232?w=600',
        ],
      ),
      WorkerProfile(
        id: 'w_104',
        userId: 'u_104',
        fullName: 'Ahmed Farooq',
        workerType: 'Carpentry',
        workerTypeId: 't_carp',
        hourlyRate: 38.0,
        rating: 4.7,
        reviewsCount: 64,
        jobsCompleted: 75,
        city: 'Dubai / JLT',
        bio: 'Precision furniture assembler, door lock repairer, custom wardrobe builder and wooden kitchen cabinetry installer.',
        isVerified: true,
        isAvailable: true,
        services: [
          ServiceItem(id: 's_8', workerTypeId: 't_carp', name: 'IKEA & Modular Assembly', basePrice: 38.0, description: 'Wardrobes, beds, tables and shelving units'),
          ServiceItem(id: 's_9', workerTypeId: 't_carp', name: 'Door Lock & Hinge Repair', basePrice: 30.0, description: 'Smart lock installation & alignment'),
        ],
        portfolioPhotos: [
          'https://images.unsplash.com/photo-1538688525198-9b88f6f53126?w=600',
        ],
      ),
      WorkerProfile(
        id: 'w_105',
        userId: 'u_105',
        fullName: 'Suresh Kumar',
        workerType: 'Painting',
        workerTypeId: 't_paint',
        hourlyRate: 32.0,
        rating: 4.8,
        reviewsCount: 92,
        jobsCompleted: 140,
        city: 'Dubai / Deira',
        bio: 'Professional residential & studio painter. Odourless paint, surface primer preparation, wallpaper removal and protective floor covers included.',
        isVerified: true,
        isAvailable: true,
        services: [
          ServiceItem(id: 's_10', workerTypeId: 't_paint', name: 'Single Room Accent Wall', basePrice: 35.0, description: '2 coats premium matte finish'),
          ServiceItem(id: 's_11', workerTypeId: 't_paint', name: 'Full Apartment Paint', basePrice: 180.0, description: 'Complete wall & ceiling paint with touchup'),
        ],
        portfolioPhotos: [
          'https://images.unsplash.com/photo-1589939705384-5185137a7f0f?w=600',
        ],
      ),
    ];
  }

  // Mock Bookings
  static final List<Booking> mockBookings = [
    Booking(
      id: 'b_201',
      customerId: 'usr_mock_101',
      customerName: 'Satwinder Singh',
      workerId: 'w_101',
      workerName: 'Rajesh Sharma',
      workerImageUrl: 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=600',
      serviceName: 'Short Circuit Diagnosis & Fix',
      status: 'Confirmed',
      scheduledDate: DateTime.now().add(const Duration(hours: 4)),
      address: 'Villa 14B, Palm Jumeirah, Dubai',
      agreedRate: 45.0,
      notes: 'Main living room sockets keep tripping the circuit breaker.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Booking(
      id: 'b_202',
      customerId: 'usr_mock_101',
      customerName: 'Satwinder Singh',
      workerId: 'w_103',
      workerName: 'Vikram Patel',
      workerImageUrl: 'https://images.unsplash.com/photo-1581092335397-9583fe92d232?w=600',
      serviceName: 'AC Deep Jet Chemical Clean',
      status: 'InProgress',
      scheduledDate: DateTime.now().subtract(const Duration(hours: 1)),
      address: 'Apt 1204, Marina Heights, Dubai',
      agreedRate: 60.0,
      notes: 'Master bedroom unit cooling very slowly.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Booking(
      id: 'b_203',
      customerId: 'usr_mock_101',
      customerName: 'Satwinder Singh',
      workerId: 'w_102',
      workerName: 'Mohammed Al-Hashmi',
      workerImageUrl: 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=600',
      serviceName: 'Water Heater Repair & Valve Check',
      status: 'Completed',
      scheduledDate: DateTime.now().subtract(const Duration(days: 2)),
      address: 'Townhouse 8, Arabian Ranches',
      agreedRate: 40.0,
      notes: 'Water heater replaced successfully.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  // Mock Threads
  static final List<NegotiationThread> mockThreads = [
    NegotiationThread(
      id: 'th_301',
      customerId: 'usr_mock_101',
      customerName: 'Satwinder Singh',
      workerId: 'w_101',
      workerName: 'Rajesh Sharma',
      workerImageUrl: 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=600',
      serviceName: 'Short Circuit Diagnosis & Fix',
      currentOfferedRate: 42.0,
      lastMessage: 'I can be at your location in 30 minutes with the voltage tester.',
      updatedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      unreadCount: 1,
    ),
    NegotiationThread(
      id: 'th_302',
      customerId: 'usr_mock_101',
      customerName: 'Satwinder Singh',
      workerId: 'w_103',
      workerName: 'Vikram Patel',
      workerImageUrl: 'https://images.unsplash.com/photo-1581092335397-9583fe92d232?w=600',
      serviceName: 'AC Deep Jet Chemical Clean',
      currentOfferedRate: 55.0,
      lastMessage: 'Rate of \$55/hr agreed! Please proceed with booking.',
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 0,
    ),
  ];

  // Mock Messages for Thread
  static final Map<String, List<ChatMessage>> mockMessages = {
    'th_301': [
      ChatMessage(
        id: 'm_1',
        threadId: 'th_301',
        senderId: 'w_101',
        senderName: 'Rajesh Sharma',
        message: 'Hello! I saw your request for circuit breaker diagnosis.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
        isMine: false,
      ),
      ChatMessage(
        id: 'm_2',
        threadId: 'th_301',
        senderId: 'usr_mock_101',
        senderName: 'Satwinder Singh',
        message: 'Hi Rajesh! Can you do \$42/hr if it takes around 2 hours?',
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
        proposedRate: 42.0,
        isMine: true,
      ),
      ChatMessage(
        id: 'm_3',
        threadId: 'th_301',
        senderId: 'w_101',
        senderName: 'Rajesh Sharma',
        message: 'Yes, \$42/hr works for me. I can be at your location in 30 minutes with the voltage tester.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        proposedRate: 42.0,
        isMine: false,
      ),
    ],
  };

  // Mock Notifications
  static final List<AppNotification> mockNotifications = [
    AppNotification(
      id: 'notif_1',
      title: 'Booking Confirmed 🎉',
      message: 'Rajesh Sharma accepted your booking for Short Circuit Diagnosis today at 02:00 PM.',
      type: 'BookingUpdate',
      createdAt: DateTime.now().subtract(const Duration(minutes: 35)),
      isRead: false,
      targetId: 'b_201',
    ),
    AppNotification(
      id: 'notif_2',
      title: 'Negotiation Rate Accepted 🤝',
      message: 'Vikram Patel accepted your counter-offer of \$55/hr for AC Cleaning.',
      type: 'ChatOffer',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      targetId: 'th_302',
    ),
    AppNotification(
      id: 'notif_3',
      title: 'Worker Dispatched 🚗',
      message: 'Mohammed Al-Hashmi is on the way to your location with tools.',
      type: 'BookingUpdate',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      targetId: 'b_203',
    ),
  ];

  // Mock Admin Verification Requests
  static final List<VerificationRequest> mockAdminRequests = [
    VerificationRequest(
      id: 'req_501',
      workerId: 'w_101',
      fullName: 'Sunil Verma',
      email: 'sunil.verma@example.com',
      phoneNumber: '+971 50 123 4567',
      workerType: 'Electrician',
      yearsOfExperience: 6,
      idDocumentUrl: 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=600',
      certificateUrl: 'https://images.unsplash.com/photo-1589330694653-ded6df03f754?w=600',
      status: 'Pending',
      submittedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    VerificationRequest(
      id: 'req_502',
      workerId: 'w_102',
      fullName: 'Tariq Mansoor',
      email: 'tariq.mansoor@example.com',
      phoneNumber: '+971 55 987 6543',
      workerType: 'Plumber',
      yearsOfExperience: 4,
      idDocumentUrl: 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?w=600',
      status: 'Pending',
      submittedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
  ];
}
