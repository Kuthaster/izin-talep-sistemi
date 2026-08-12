import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/dio_provider.dart';
import 'package:izin_talep_sistemi/services/reports_service.dart';

final reportsServiceProvider = Provider<ReportsService>((ref) {
  return ReportsService(dio: ref.watch(dioProvider));
});
