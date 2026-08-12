import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/widgets/leave_request_for_approval_list.dart';
import 'package:izin_talep_sistemi/widgets/approval_count_dashboard.dart';

class MainApprovalsSection extends ConsumerWidget {
  const MainApprovalsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      children: [
        ApprovalCountDashboard(),
        Expanded(child: LeaveRequestForApprovalList()),
      ],
    );
  }
}
