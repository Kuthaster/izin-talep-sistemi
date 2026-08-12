import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/approver_gap.dart';
import 'package:izin_talep_sistemi/providers/admin_reports_service_provider.dart';

final approverGapsProvider = FutureProvider<List<ApproverGap>>((ref) async {
  final service = ref.watch(adminReportsServiceProvider);
  return service.getApproverGaps();
});
