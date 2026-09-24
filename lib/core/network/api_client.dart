import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../constants/api_constants.dart';
import '../errors/app_exceptions.dart';
import '../storage/secure_storage_service.dart';

class ApiClient {
  final Dio dio;
  final SecureStorageService storageService;
  bool _isRefreshing = false;
  final List<Completer<String?>> _refreshQueue = [];

  ApiClient({Dio? dio, required this.storageService})
      : dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: AppConfig.baseUrl,
                connectTimeout: AppConfig.connectTimeout,
                receiveTimeout: AppConfig.receiveTimeout,
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storageService.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            // Attempt token refresh
            final newAccessToken = await _handleTokenRefresh();
            if (newAccessToken != null) {
              final reqOptions = error.requestOptions;
              reqOptions.headers['Authorization'] = 'Bearer $newAccessToken';
              try {
                final response = await dio.fetch(reqOptions);
                return handler.resolve(response);
              } catch (retryError) {
                return handler.next(error);
              }
            } else {
              await storageService.clearSession();
            }
          }
          return handler.next(error);
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestHeader: false,
          responseHeader: false,
          requestBody: true,
          responseBody: true,
        ),
      );
    }
  }

  Future<String?> _handleTokenRefresh() async {
    if (_isRefreshing) {
      final completer = Completer<String?>();
      _refreshQueue.add(completer);
      return completer.future;
    }

    _isRefreshing = true;
    final refreshToken = await storageService.getRefreshToken();
    if (refreshToken == null) {
      _isRefreshing = false;
      return null;
    }

    try {
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: AppConfig.baseUrl,
          connectTimeout: AppConfig.connectTimeout,
        ),
      );
      final response = await refreshDio.post(
        ApiConstants.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final newAccess = response.data['accessToken'] as String;
        final newRefresh = response.data['refreshToken'] as String? ?? refreshToken;
        await storageService.saveTokens(
          accessToken: newAccess,
          refreshToken: newRefresh,
        );

        for (final comp in _refreshQueue) {
          comp.complete(newAccess);
        }
        _refreshQueue.clear();
        _isRefreshing = false;
        return newAccess;
      }
    } catch (_) {
      for (final comp in _refreshQueue) {
        comp.complete(null);
      }
      _refreshQueue.clear();
      _isRefreshing = false;
    }

    _isRefreshing = false;
    return null;
  }

  // Generic HTTP wrappers
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters, options: options);
      return response.data;
    } on DioException catch (e) {
      throw _parseDioError(e);
    }
  }

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.post(path, data: data, queryParameters: queryParameters, options: options);
      return response.data;
    } on DioException catch (e) {
      throw _parseDioError(e);
    }
  }

  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.put(path, data: data, queryParameters: queryParameters, options: options);
      return response.data;
    } on DioException catch (e) {
      throw _parseDioError(e);
    }
  }

  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.delete(path, data: data, queryParameters: queryParameters, options: options);
      return response.data;
    } on DioException catch (e) {
      throw _parseDioError(e);
    }
  }

  AppException _parseDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return NetworkException('Unable to reach server. Please verify your internet connection.');
    }

    final code = e.response?.statusCode;
    final data = e.response?.data;
    String message = 'Something went wrong. Please try again.';

    if (data is Map<String, dynamic>) {
      if (data['message'] != null) {
        message = data['message'].toString();
      } else if (data['title'] != null) {
        message = data['title'].toString();
      }
    } else if (data is String && data.isNotEmpty) {
      message = data;
    }

    switch (code) {
      case 401:
        return UnauthorizedException(message);
      case 403:
        return ForbiddenException(message);
      case 404:
        return NotFoundException(message);
      case 422:
      case 400:
        return ValidationException(message);
      default:
        return ServerException(message);
    }
  }
}
