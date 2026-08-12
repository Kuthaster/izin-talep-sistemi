import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/leave_balance_audit.dart';
import 'package:izin_talep_sistemi/providers/admin_reports_service_provider.dart';

final balanceAuditsProvider = FutureProvider<List<LeaveBalanceAudit>>((
  ref,
) async {
  final service = ref.watch(adminReportsServiceProvider);
  return service.getBalanceAudits();
});
