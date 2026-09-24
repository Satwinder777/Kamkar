class WorkerType {
  final String id;
  final String name;
  final String? icon;
  final String? description;

  WorkerType({
    required this.id,
    required this.name,
    this.icon,
    this.description,
  });

  factory WorkerType.fromJson(Map<String, dynamic> json) {
    return WorkerType(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      icon: json['icon']?.toString(),
      description: json['description']?.toString(),
    );
  }
}

class ServiceItem {
  final String id;
  final String workerTypeId;
  final String name;
  final String? description;
  final double basePrice;

  ServiceItem({
    required this.id,
    required this.workerTypeId,
    required this.name,
    this.description,
    required this.basePrice,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: json['id']?.toString() ?? '',
      workerTypeId: json['workerTypeId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      basePrice: (json['basePrice'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class WorkerProfile {
  final String id;
  final String userId;
  final String fullName;
  final String workerType;
  final String? workerTypeId;
  final String? bio;
  final String? profileImageUrl;
  final double hourlyRate;
  final double rating;
  final int reviewsCount;
  final int jobsCompleted;
  final bool isVerified;
  final bool isAvailable;
  final String? city;
  final List<String> portfolioPhotos;
  final List<ServiceItem> services;

  WorkerProfile({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.workerType,
    this.workerTypeId,
    this.bio,
    this.profileImageUrl,
    required this.hourlyRate,
    required this.rating,
    this.reviewsCount = 0,
    this.jobsCompleted = 0,
    this.isVerified = true,
    this.isAvailable = true,
    this.city,
    this.portfolioPhotos = const [],
    this.services = const [],
  });

  factory WorkerProfile.fromJson(Map<String, dynamic> json) {
    return WorkerProfile(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      workerType: json['workerType']?.toString() ?? 'General Worker',
      workerTypeId: json['workerTypeId']?.toString(),
      bio: json['bio']?.toString(),
      profileImageUrl: json['profileImageUrl']?.toString(),
      hourlyRate: (json['hourlyRate'] as num?)?.toDouble() ?? 25.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      reviewsCount: json['reviewsCount'] is int ? json['reviewsCount'] : 0,
      jobsCompleted: json['jobsCompleted'] is int ? json['jobsCompleted'] : 0,
      isVerified: json['isVerified'] == true,
      isAvailable: json['isAvailable'] != false,
      city: json['city']?.toString(),
      portfolioPhotos: (json['portfolioPhotos'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => ServiceItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
