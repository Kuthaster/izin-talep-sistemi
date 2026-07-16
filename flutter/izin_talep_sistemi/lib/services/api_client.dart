import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'auth_interceptor.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  late final Dio dio;
  

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
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

    // Add the AuthInterceptor
    dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

}
  String getBaseUrl(){ 
   if (kIsWeb){
      return "http://localhost:8080";
    }
      else if(Platform.isAndroid){
        return "http://10.0.2.2:8080";
      }
        else {
          return "http://localhost:8080";
        }
  }