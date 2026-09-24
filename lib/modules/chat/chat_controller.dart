import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/chat_model.dart';
import '../../data/repositories/chat_repository.dart';

class ChatController extends GetxController {
  final ChatRepository chatRepository = Get.find<ChatRepository>();

  // Observables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<NegotiationThread> threads = <NegotiationThread>[].obs;
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxDouble currentNegotiatedRate = 45.0.obs;

  final messageInputController = TextEditingController();
  final offerRateController = TextEditingController();
  final scrollController = ScrollController();
  StreamSubscription? _msgSubscription;

  @override
  void onInit() {
    super.onInit();
    fetchThreads();
    _listenToSignalRMessages();
  }

  @override
  void onClose() {
    _msgSubscription?.cancel();
    messageInputController.dispose();
    offerRateController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _listenToSignalRMessages() {
    _msgSubscription = chatRepository.messageStream.listen((data) {
      final newMsg = ChatMessage.fromJson(data);
      messages.add(newMsg);
      _scrollToBottom();
    });
  }

  Future<void> fetchThreads() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final list = await chatRepository.getThreads();
      threads.assignAll(list);
    } catch (e) {
      if (threads.isEmpty) {
        _populateFallbackThreads();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadThreadMessages(String threadId) async {
    isLoading.value = true;
    try {
      final list = await chatRepository.getMessages(threadId);
      messages.assignAll(list);
      _scrollToBottom();
    } catch (e) {
      if (messages.isEmpty) {
        _populateFallbackMessages(threadId);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage(String threadId) async {
    final text = messageInputController.text.trim();
    if (text.isEmpty) return;

    messageInputController.clear();
    final tempMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      threadId: threadId,
      senderId: 'current-user',
      senderName: 'You',
      message: text,
      createdAt: DateTime.now(),
      isMine: true,
    );

    messages.add(tempMsg);
    _scrollToBottom();

    try {
      await chatRepository.sendMessage(
        threadId: threadId,
        message: text,
      );
    } catch (_) {}
  }

  Future<void> proposeOffer(String threadId, double rate) async {
    try {
      currentNegotiatedRate.value = rate;
      final offerMsg = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        threadId: threadId,
        senderId: 'current-user',
        senderName: 'You',
        message: 'Proposed updated rate of \$$rate/hr',
        proposedRate: rate,
        rateStatus: 'Proposed',
        createdAt: DateTime.now(),
        isMine: true,
      );
      messages.add(offerMsg);
      _scrollToBottom();

      await chatRepository.proposeOffer(threadId: threadId, offeredRate: rate);
      Get.snackbar('Offer Sent', 'Counter offer of \$$rate/hr sent to worker.');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 60,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _populateFallbackThreads() {
    threads.assignAll([
      NegotiationThread(
        id: 't-1',
        customerId: 'c-1',
        customerName: 'You',
        workerId: 'w-1',
        workerName: 'Alex Reynolds (Electrician)',
        serviceName: 'Panel Upgrade & Wiring',
        currentOfferedRate: 45.0,
        lastMessage: 'I can come over at 10 AM tomorrow.',
        updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
        unreadCount: 1,
      ),
      NegotiationThread(
        id: 't-2',
        customerId: 'c-1',
        customerName: 'You',
        workerId: 'w-2',
        workerName: 'Marcus Vance (Plumbing)',
        serviceName: 'Emergency Pipe Repair',
        currentOfferedRate: 50.0,
        lastMessage: 'Rate of \$50/hr confirmed.',
        updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
        unreadCount: 0,
      ),
    ]);
  }

  void _populateFallbackMessages(String threadId) {
    messages.assignAll([
      ChatMessage(
        id: 'm-1',
        threadId: threadId,
        senderId: 'w-1',
        senderName: 'Alex Reynolds',
        message: 'Hello! I saw your service request for the main breaker upgrade.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        isMine: false,
      ),
      ChatMessage(
        id: 'm-2',
        threadId: threadId,
        senderId: 'current-user',
        senderName: 'You',
        message: 'Hi Alex! Yes, can you do \$45/hr for a 3-hour job?',
        proposedRate: 45.0,
        rateStatus: 'Proposed',
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
        isMine: true,
      ),
      ChatMessage(
        id: 'm-3',
        threadId: threadId,
        senderId: 'w-1',
        senderName: 'Alex Reynolds',
        message: 'I accept \$45/hr. I can come over at 10 AM tomorrow.',
        proposedRate: 45.0,
        rateStatus: 'Accepted',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        isMine: false,
      ),
    ]);
  }
}
