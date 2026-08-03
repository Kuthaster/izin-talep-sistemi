import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:izin_talep_sistemi/services/api_client.dart';

final dioProvider = Provider<Dio>((ref) {
  return ApiClient().dio;
});
