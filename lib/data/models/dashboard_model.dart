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
    final active = (json['activeBookings'] is List)
        ? (json['activeBookings'] as List).length
        : (json['activeBookingsCount'] is int ? json['activeBookingsCount'] : 0);

    final completed = (json['completedBookings'] is List)
        ? (json['completedBookings'] as List).length
        : (json['completedBookingsCount'] is int ? json['completedBookingsCount'] : 0);

    final spent = (json['totalSpent'] as num?)?.toDouble() ?? 0.0;

    List<Booking> upBookings = [];
    final upList = json['upcomingBookings'] ?? json['activeBookings'];
    if (upList is List) {
      upBookings = upList
          .map((e) => Booking.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return CustomerDashboard(
      activeBookingsCount: active,
      completedBookingsCount: completed,
      totalSpent: spent,
      upcomingBookings: upBookings,
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
    final totEarn = (json['totalEarnings'] ?? json['netEarnings'] as num?)?.toDouble() ?? 0.0;
    final pendRequests = (json['pendingRequests'] is List)
        ? (json['pendingRequests'] as List).length
        : ((json['pendingRequestsCount'] ?? json['upcomingJobs']) as num?)?.toInt() ?? 0;

    final compJobs = ((json['completedJobs'] ?? json['reviewCount']) as num?)?.toInt() ?? 0;
    final avgRating = (json['averageRating'] ?? json['rating'] as num?)?.toDouble() ?? 5.0;

    List<Booking> reqs = [];
    final reqsList = json['recentRequests'] ?? json['upcomingJobs'];
    if (reqsList is List) {
      reqs = reqsList
          .whereType<Map<String, dynamic>>()
          .map((e) => Booking.fromJson(e))
          .toList();
    }

    return WorkerDashboard(
      totalEarnings: totEarn,
      monthlyEarnings: (json['monthlyEarnings'] as num?)?.toDouble() ?? (totEarn * 0.4),
      completedJobs: compJobs,
      pendingRequestsCount: pendRequests,
      rating: avgRating,
      recentRequests: reqs,
    );
  }
}
