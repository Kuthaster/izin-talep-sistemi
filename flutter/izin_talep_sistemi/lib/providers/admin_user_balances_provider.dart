import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/leave_balance_service_provider.dart';

import '/models/leave_balance.dart';

final adminUserBalancesProvider = FutureProvider<List<LeaveBalance>>((
  ref,
) async {
  final leaveBalanceService = ref.watch(leaveBalanceServiceProvider);
  return leaveBalanceService.getUserBalances();
});
