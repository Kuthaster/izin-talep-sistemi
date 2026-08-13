import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/password_reset_request.dart';
import 'package:izin_talep_sistemi/providers/admin_reports_service_provider.dart';

final passwordResetRequestsProvider =
    FutureProvider<List<PasswordResetRequest>>((ref) async {
      final service = ref.watch(adminReportsServiceProvider);
      return service.getPasswordResetRequests();
    });
