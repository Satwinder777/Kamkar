class WorkerType {
  final String id;
  final String name;
  final String? code;
  final String? icon;
  final String? description;

  WorkerType({
    required this.id,
    required this.name,
    this.code,
    this.icon,
    this.description,
  });

  factory WorkerType.fromJson(Map<String, dynamic> json) {
    return WorkerType(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString(),
      icon: json['icon']?.toString(),
      description: json['description']?.toString(),
    );
  }
}

class ServiceItem {
  final String id;
  final String workerTypeId;
  final String name;
  final String? code;
  final String? description;
  final double basePrice;

  ServiceItem({
    required this.id,
    required this.workerTypeId,
    required this.name,
    this.code,
    this.description,
    required this.basePrice,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    final priceRaw = json['defaultHourlyRate'] ?? json['basePrice'] ?? json['price'];
    return ServiceItem(
      id: json['id']?.toString() ?? '',
      workerTypeId: json['workerTypeId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString(),
      description: json['description']?.toString(),
      basePrice: (priceRaw as num?)?.toDouble() ?? 35.0,
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
  final double? distanceKm;
  final int? etaMinutes;
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
    this.distanceKm,
    this.etaMinutes,
    this.portfolioPhotos = const [],
    this.services = const [],
  });

  factory WorkerProfile.fromJson(Map<String, dynamic> json) {
    final name = json['fullName']?.toString() ??
        json['headline']?.toString() ??
        json['name']?.toString() ??
        'Craftsman';

    final photo = json['profileImageUrl']?.toString() ??
        json['profilePhotoUrl']?.toString() ??
        json['photoUrl']?.toString();

    final rateRaw = json['hourlyRate'] ?? json['defaultHourlyRate'];
    final ratingRaw = json['rating'] ?? json['averageRating'];
    final reviewsRaw = json['reviewsCount'] ?? json['reviewCount'];

    final wType = json['workerTypeName']?.toString() ??
        json['workerType']?.toString() ??
        'General Tradesman';

    final dist = (json['distanceKm'] as num?)?.toDouble();
    final eta = (json['etaMinutes'] as num?)?.toInt();

    final servicesJson = json['services'];
    List<ServiceItem> parsedServices = [];
    if (servicesJson is List) {
      parsedServices = servicesJson
          .map((e) => ServiceItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final photosJson = json['portfolioPhotos'] ?? json['portfolio'];
    List<String> parsedPhotos = [];
    if (photosJson is List) {
      for (final p in photosJson) {
        if (p is String) {
          parsedPhotos.add(p);
        } else if (p is Map && p['imageUrl'] != null) {
          parsedPhotos.add(p['imageUrl'].toString());
        }
      }
    }

    return WorkerProfile(
      id: json['id']?.toString() ?? json['workerProfileId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      fullName: name,
      workerType: wType,
      workerTypeId: json['workerTypeId']?.toString(),
      bio: json['bio']?.toString(),
      profileImageUrl: photo,
      hourlyRate: (rateRaw as num?)?.toDouble() ?? 45.0,
      rating: (ratingRaw as num?)?.toDouble() ?? 4.9,
      reviewsCount: (reviewsRaw as num?)?.toInt() ?? 12,
      jobsCompleted: (json['jobsCompleted'] as num?)?.toInt() ?? 38,
      isVerified: json['isVerified'] == true || json['verificationStatus'] == 'Approved',
      isAvailable: json['isAvailable'] != false,
      city: json['city']?.toString() ?? 'Dubai Marina',
      distanceKm: dist,
      etaMinutes: eta,
      portfolioPhotos: parsedPhotos,
      services: parsedServices,
    );
  }
}
