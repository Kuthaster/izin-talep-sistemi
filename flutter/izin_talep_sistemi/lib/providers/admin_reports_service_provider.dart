import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/dio_provider.dart';
import 'package:izin_talep_sistemi/services/admin_reports_service.dart';

final adminReportsServiceProvider = Provider<AdminReportsService>((ref) {
  return AdminReportsService(dio: ref.watch(dioProvider));
});
