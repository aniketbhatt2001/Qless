import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:canteen_mangement/core/constants/api_endpoints.dart';
import 'package:canteen_mangement/core/utils/alice_helper.dart';

class DioClient {
  final Dio _dio;

  // Set after AuthController is ready to break circular dependency
  void Function()? onUnauthorized;

  DioClient({required Future<String?> Function() getToken, required Future<bool> Function() isTokenValid})
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: const Duration(minutes: 2),
            receiveTimeout: const Duration(minutes: 2),
          ),
        ) {
    if (kDebugMode) {
      _dio.interceptors.add(AliceHelper.alice.getDioInterceptor());
    }
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          log(options.baseUrl);
          log(options.path);

          final valid = await isTokenValid();
          if (!valid) {
            onUnauthorized?.call();
            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'Token expired or invalid',
                type: DioExceptionType.cancel,
              ),
            );
          }

          final token = await getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
