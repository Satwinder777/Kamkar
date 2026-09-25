class ApiConstants {
  // Auth
  static const String register = '/auth/register';
  static const String verifyOtp = '/auth/verify-email';
  static const String resendOtp = '/auth/resend-otp';
  static const String login = '/auth/login';
  static const String googleLogin = '/auth/google';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String onboardingStatus = '/auth/onboarding-status';
  static const String completeProfile = '/onboarding/complete-profile';

  // Catalog
  static const String workerTypes = '/catalog/worker-types';
  static const String services = '/catalog/services';

  // Workers
  static const String workerRegister = '/workers/register';
  static const String workerSearch = '/workers/search';
  static const String workerDetail = '/workers'; // /workers/{id}
  static const String workerMe = '/workers/me';
  static const String workerAvailability = '/workers/me/availability';
  static const String workerPortfolio = '/workers/me/portfolio';
  static const String workerPhoto = '/workers/me/photo';

  // Customers
  static const String customerMe = '/customers/me';
  static const String customerAddresses = '/customers/me/addresses';

  // Bookings
  static const String bookings = '/bookings'; // POST /bookings, GET /bookings/{id}
  static const String myBookings = '/bookings'; // in Swagger bookings list is fetched by filters/user
  static const String acceptBooking = '/bookings'; // /bookings/{id}/accept
  static const String rejectBooking = '/bookings'; // /bookings/{id}/reject
  static const String confirmBooking = '/bookings'; // /bookings/{id}/confirm
  static const String completeBooking = '/bookings'; // /bookings/{id}/complete
  static const String cancelBooking = '/bookings'; // /bookings/{id}/cancel

  // Negotiation & Chat
  static const String threads = '/negotiate/threads'; // POST /negotiate/threads, GET /negotiate/threads
  static const String threadMessages = '/negotiate/threads'; // GET/POST /negotiate/threads/{threadId}/messages

  // Notifications
  static const String notifications = '/notifications';
  static const String unreadNotificationsCount = '/notifications/unread-count';
  static const String markNotificationRead = '/notifications'; // /notifications/{id}/read
  static const String markAllNotificationsRead = '/notifications/read-all';

  // Dashboards
  static const String customerDashboard = '/dashboards/customer';
  static const String workerDashboard = '/dashboards/worker';
  static const String organisationDashboard = '/dashboards/organisation';

  // Organisations
  static const String registerOrganisation = '/organisations/register';
  static const String organisationWorkers = '/organisations/me/workers';
  static const String organisationInvitations = '/organisations/me/invitations';
  static const String organisationJoinRequests = '/organisations/me/join-requests';

  // Reviews
  static const String reviews = '/reviews'; // POST /reviews/{bookingId}

  // User Settings
  static const String userSettings = '/users/me/settings';

  // Admin Verification
  static const String adminVerifications = '/admin/verification-requests';
}
