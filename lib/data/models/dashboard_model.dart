import 'booking_model.dart';

class CustomerDashboard {
  final int activeBookingsCount;
  final int completedBookingsCount;
  final double totalSpent;
  final List<Booking> upcomingBookings;

  CustomerDashboard({
    this.activeBookingsCount = 0,
    this.completedBookingsCount = 0,
    this.totalSpent = 0.0,
    this.upcomingBookings = const [],
  });

  factory CustomerDashboard.fromJson(Map<String, dynamic> json) {
    return CustomerDashboard(
      activeBookingsCount: json['activeBookingsCount'] is int ? json['activeBookingsCount'] : 0,
      completedBookingsCount: json['completedBookingsCount'] is int ? json['completedBookingsCount'] : 0,
      totalSpent: (json['totalSpent'] as num?)?.toDouble() ?? 0.0,
      upcomingBookings: (json['upcomingBookings'] as List<dynamic>?)
              ?.map((e) => Booking.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class WorkerDashboard {
  final double totalEarnings;
  final double monthlyEarnings;
  final int completedJobs;
  final int pendingRequestsCount;
  final double rating;
  final List<Booking> recentRequests;

  WorkerDashboard({
    this.totalEarnings = 0.0,
    this.monthlyEarnings = 0.0,
    this.completedJobs = 0,
    this.pendingRequestsCount = 0,
    this.rating = 5.0,
    this.recentRequests = const [],
  });

  factory WorkerDashboard.fromJson(Map<String, dynamic> json) {
    return WorkerDashboard(
      totalEarnings: (json['totalEarnings'] as num?)?.toDouble() ?? 0.0,
      monthlyEarnings: (json['monthlyEarnings'] as num?)?.toDouble() ?? 0.0,
      completedJobs: json['completedJobs'] is int ? json['completedJobs'] : 0,
      pendingRequestsCount: json['pendingRequestsCount'] is int ? json['pendingRequestsCount'] : 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      recentRequests: (json['recentRequests'] as List<dynamic>?)
              ?.map((e) => Booking.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
