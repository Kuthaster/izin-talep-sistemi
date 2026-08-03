import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'auth_interceptor.dart';
import 'error_interceptor.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: getBaseUrl(),
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(ErrorInterceptor());
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }
}

String getBaseUrl() {
  if (kIsWeb) {
    return "http://localhost:8080";
  } else if (Platform.isAndroid) {
    return "http://10.0.2.2:8080";
  } else {
    return "http://localhost:8080";
  }
}

final Dio dioClient = ApiClient().dio;
