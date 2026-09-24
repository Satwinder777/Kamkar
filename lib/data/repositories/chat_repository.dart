import '../../core/config/app_config.dart';
import '../../core/network/signalr_service.dart';
import '../datasources/chat_remote_data_source.dart';
import '../mock/mock_data_provider.dart';
import '../models/chat_model.dart';

class ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final SignalRService signalRService;

  ChatRepository({
    required this.remoteDataSource,
    required this.signalRService,
  });

  Future<List<NegotiationThread>> getThreads() async {
    if (AppConfig.isMockMode) {
      await Future.delayed(const Duration(milliseconds: 200));
      return List<NegotiationThread>.from(MockDataProvider.mockThreads);
    }
    try {
      return await remoteDataSource.getThreads();
    } catch (_) {
      return List<NegotiationThread>.from(MockDataProvider.mockThreads);
    }
  }

  Future<List<ChatMessage>> getMessages(String threadId) async {
    if (AppConfig.isMockMode) {
      await Future.delayed(const Duration(milliseconds: 200));
      return List<ChatMessage>.from(MockDataProvider.mockMessages[threadId] ?? [
        ChatMessage(
          id: 'm_welcome',
          threadId: threadId,
          senderId: 'worker_pro',
          senderName: 'Verified Pro',
          message: 'Hello! Thanks for reaching out. How can I assist you with your trade request today?',
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
          isMine: false,
        ),
      ]);
    }

    try {
      return await remoteDataSource.getMessages(threadId);
    } catch (_) {
      return List<ChatMessage>.from(MockDataProvider.mockMessages[threadId] ?? [
        ChatMessage(
          id: 'm_welcome',
          threadId: threadId,
          senderId: 'worker_pro',
          senderName: 'Verified Pro',
          message: 'Hello! Thanks for reaching out. How can I assist you with your trade request today?',
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
          isMine: false,
        ),
      ]);
    }
  }

  Future<ChatMessage> sendMessage({
    required String threadId,
    required String message,
    double? proposedRate,
  }) async {
    if (AppConfig.isMockMode) {
      await Future.delayed(const Duration(milliseconds: 150));
      final newMsg = ChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        threadId: threadId,
        senderId: 'usr_mock_101',
        senderName: 'Satwinder Singh',
        message: message,
        createdAt: DateTime.now(),
        proposedRate: proposedRate,
        isMine: true,
      );

      final list = MockDataProvider.mockMessages.putIfAbsent(threadId, () => []);
      list.add(newMsg);
      return newMsg;
    }

    try {
      if (signalRService.isConnected) {
        await signalRService.sendMessage(threadId, message, proposedRate: proposedRate);
      }
      return await remoteDataSource.sendMessage(
        threadId: threadId,
        message: message,
        proposedRate: proposedRate,
      );
    } catch (_) {
      final newMsg = ChatMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        threadId: threadId,
        senderId: 'usr_mock_101',
        senderName: 'Satwinder Singh',
        message: message,
        createdAt: DateTime.now(),
        proposedRate: proposedRate,
        isMine: true,
      );

      final list = MockDataProvider.mockMessages.putIfAbsent(threadId, () => []);
      list.add(newMsg);
      return newMsg;
    }
  }

  Future<void> proposeOffer({
    required String threadId,
    required double offeredRate,
  }) async {
    if (AppConfig.isMockMode) {
      final idx = MockDataProvider.mockThreads.indexWhere((t) => t.id == threadId);
      if (idx != -1) {
        final t = MockDataProvider.mockThreads[idx];
        MockDataProvider.mockThreads[idx] = NegotiationThread(
          id: t.id,
          customerId: t.customerId,
          customerName: t.customerName,
          workerId: t.workerId,
          workerName: t.workerName,
          serviceName: t.serviceName,
          currentOfferedRate: offeredRate,
          lastMessage: 'Proposed new rate of \$$offeredRate/hr',
          updatedAt: DateTime.now(),
        );
      }
      return;
    }

    try {
      if (signalRService.isConnected) {
        await signalRService.acceptNegotiationRate(threadId, offeredRate);
      }
      await remoteDataSource.proposeOffer(
        threadId: threadId,
        offeredRate: offeredRate,
      );
    } catch (_) {}
  }

  Stream<Map<String, dynamic>> get messageStream => signalRService.messageStream;
  Stream<Map<String, dynamic>> get negotiationStream => signalRService.negotiationStream;
}
