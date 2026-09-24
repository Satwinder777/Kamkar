import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:signalr_netcore/signalr_client.dart';
import '../config/app_config.dart';
import '../storage/secure_storage_service.dart';

class SignalRService {
  final SecureStorageService storageService;
  HubConnection? _hubConnection;
  bool _isConnected = false;

  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _negotiationController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _notificationController =
      StreamController<Map<String, dynamic>>.broadcast();

  SignalRService({required this.storageService});

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  Stream<Map<String, dynamic>> get negotiationStream => _negotiationController.stream;
  Stream<Map<String, dynamic>> get notificationStream => _notificationController.stream;
  bool get isConnected => _isConnected;

  Future<void> initConnection() async {
    if (_hubConnection != null && _hubConnection!.state == HubConnectionState.Connected) {
      return;
    }

    try {
      final token = await storageService.getAccessToken();
      final hubUrl = AppConfig.signalRHubUrl;

      _hubConnection = HubConnectionBuilder()
          .withUrl(
            hubUrl,
            options: HttpConnectionOptions(
              accessTokenFactory: () async => token ?? '',
            ),
          )
          .withAutomaticReconnect()
          .build();

      _hubConnection!.onclose(({error}) {
        _isConnected = false;
        if (kDebugMode) {
          debugPrint('SignalR Hub connection closed: $error');
        }
      });

      _hubConnection!.onreconnected(({connectionId}) {
        _isConnected = true;
        if (kDebugMode) {
          debugPrint('SignalR Hub reconnected with ID: $connectionId');
        }
      });

      _registerHubEvents();

      await _hubConnection!.start();
      _isConnected = true;
      if (kDebugMode) {
        debugPrint('SignalR Connected to $hubUrl');
      }
    } catch (e) {
      _isConnected = false;
      if (kDebugMode) {
        debugPrint('SignalR connection error (Backend may be offline): $e');
      }
    }
  }

  void _registerHubEvents() {
    _hubConnection?.on('MessageReceived', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final data = arguments[0];
        if (data is Map<String, dynamic>) {
          _messageController.add(data);
        }
      }
    });

    _hubConnection?.on('NegotiationRateUpdated', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final data = arguments[0];
        if (data is Map<String, dynamic>) {
          _negotiationController.add(data);
        }
      }
    });

    _hubConnection?.on('NotificationReceived', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final data = arguments[0];
        if (data is Map<String, dynamic>) {
          _notificationController.add(data);
        }
      }
    });
  }

  Future<void> joinThread(String threadId) async {
    if (_hubConnection?.state == HubConnectionState.Connected) {
      await _hubConnection?.invoke('JoinThread', args: [threadId]);
    }
  }

  Future<void> sendMessage(String threadId, String message, {double? proposedRate}) async {
    if (_hubConnection?.state == HubConnectionState.Connected) {
      final List<Object> args = [threadId, message];
      if (proposedRate != null) {
        args.add(proposedRate);
      }
      await _hubConnection?.invoke('SendMessage', args: args);
    }
  }

  Future<void> acceptNegotiationRate(String threadId, double rate) async {
    if (_hubConnection?.state == HubConnectionState.Connected) {
      await _hubConnection?.invoke('AcceptNegotiationRate', args: [threadId, rate]);
    }
  }

  Future<void> disconnect() async {
    try {
      if (_hubConnection != null) {
        await _hubConnection?.stop();
        _isConnected = false;
      }
    } catch (_) {}
  }

  void dispose() {
    disconnect();
    _messageController.close();
    _negotiationController.close();
    _notificationController.close();
  }
}
