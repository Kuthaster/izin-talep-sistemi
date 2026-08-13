import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/widgets/leave_request_for_approval_list.dart';
import 'package:izin_talep_sistemi/widgets/approval_count_dashboard.dart';

class MainApprovalsSection extends ConsumerWidget {
  const MainApprovalsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = (constraints.maxHeight * 0.5).clamp(500.0, 800.0);

        return SingleChildScrollView(
          child: Column(
            children: [
              ApprovalCountDashboard(),
              SizedBox(
                height: h,
                child: LeaveRequestForApprovalList(availableHeight: h),
              ),
            ],
          ),
        );
      },
    );
  }
}
