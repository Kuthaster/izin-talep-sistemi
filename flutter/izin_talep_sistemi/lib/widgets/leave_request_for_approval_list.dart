import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/leave_request_approval_provider.dart';
import 'package:izin_talep_sistemi/widgets/leave_request_for_approval_tile.dart';

class LeaveRequestForApprovalList extends ConsumerWidget {
  const LeaveRequestForApprovalList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRequests = ref.watch(leaveRequestsForApprovalProvider);

    return asyncRequests.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Hata: $err')),
      data: (requests) {  
      final sorted = [...requests]
    ..sort((a, b) {
      if (a.status == 'PENDING' && b.status != 'PENDING') return -1;
      if (a.status != 'PENDING' && b.status == 'PENDING') return 1;
      return 0;
    });

    return RefreshIndicator(
    onRefresh: () => ref.refresh(leaveRequestsForApprovalProvider.future),
    child: ListView.builder(
      itemCount: sorted.length,
      itemBuilder: (context, index) => LeaveRequestForApprovalTile(request: sorted[index]),
    ),
    );
    },
   );
  }
}