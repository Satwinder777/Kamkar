import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/chat_model.dart';

class ChatRemoteDataSource {
  final ApiClient apiClient;

  ChatRemoteDataSource({required this.apiClient});

  Future<List<NegotiationThread>> getThreads() async {
    final response = await apiClient.get(ApiConstants.threads);
    if (response is List) {
      return response.map((e) => NegotiationThread.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<List<ChatMessage>> getMessages(String threadId) async {
    final response = await apiClient.get(
      ApiConstants.messages,
      queryParameters: {'threadId': threadId},
    );
    if (response is List) {
      return response.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<ChatMessage> sendMessage({
    required String threadId,
    required String message,
    double? proposedRate,
  }) async {
    final response = await apiClient.post(
      ApiConstants.messages,
      data: {
        'threadId': threadId,
        'message': message,
        'proposedRate': proposedRate,
      },
    );
    return ChatMessage.fromJson(response as Map<String, dynamic>);
  }

  Future<void> proposeOffer({
    required String threadId,
    required double offeredRate,
  }) async {
    await apiClient.post(
      ApiConstants.proposeOffer,
      data: {
        'threadId': threadId,
        'offeredRate': offeredRate,
      },
    );
  }
}
