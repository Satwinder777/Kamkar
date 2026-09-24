import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/worker_model.dart';

class MarketplaceRemoteDataSource {
  final ApiClient apiClient;

  MarketplaceRemoteDataSource({required this.apiClient});

  Future<List<WorkerType>> getWorkerTypes() async {
    final response = await apiClient.get(ApiConstants.workerTypes);
    if (response is List) {
      return response.map((e) => WorkerType.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<List<ServiceItem>> getServices({String? workerTypeId}) async {
    final response = await apiClient.get(
      ApiConstants.services,
      queryParameters: workerTypeId != null ? {'workerTypeId': workerTypeId} : null,
    );
    if (response is List) {
      return response.map((e) => ServiceItem.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<List<WorkerProfile>> searchWorkers({
    String? query,
    String? workerTypeId,
    double? minRating,
    double? maxHourlyRate,
    String? city,
    bool? isAvailable,
    int page = 1,
    int pageSize = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
    };
    if (query != null && query.isNotEmpty) queryParams['query'] = query;
    if (workerTypeId != null) queryParams['workerTypeId'] = workerTypeId;
    if (minRating != null) queryParams['minRating'] = minRating;
    if (maxHourlyRate != null) queryParams['maxHourlyRate'] = maxHourlyRate;
    if (city != null && city.isNotEmpty) queryParams['city'] = city;
    if (isAvailable != null) queryParams['isAvailable'] = isAvailable;

    final response = await apiClient.get(
      ApiConstants.workerSearch,
      queryParameters: queryParams,
    );

    if (response is List) {
      return response.map((e) => WorkerProfile.fromJson(e as Map<String, dynamic>)).toList();
    } else if (response is Map<String, dynamic> && response['items'] is List) {
      return (response['items'] as List)
          .map((e) => WorkerProfile.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<WorkerProfile> getWorkerDetail(String workerId) async {
    final response = await apiClient.get('${ApiConstants.workerDetail}/$workerId');
    return WorkerProfile.fromJson(response as Map<String, dynamic>);
  }
}
