import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/dio_provider.dart';
import 'package:izin_talep_sistemi/services/leave_balance_service.dart';

final leaveBalanceServiceProvider = Provider<LeaveBalanceService>((ref) {
  return LeaveBalanceService(dio: ref.watch(dioProvider));
});
