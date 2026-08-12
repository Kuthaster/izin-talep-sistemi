import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/leave_request_approval_provider.dart';
import 'package:izin_talep_sistemi/widgets/leave_request_for_approval_list.dart';
import 'package:izin_talep_sistemi/widgets/approval_count_dashboard.dart';

class ApprovalsScreen extends ConsumerWidget {
  const ApprovalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, //başlık merkezleme
        title: const Text('Çalışan Talepleri'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(leaveRequestsForApprovalProvider),
          ), //sayfa yenileme appbarda
        ],
      ),
      body: Column(
        children: const [
          ApprovalCountDashboard(),
          Expanded(child: LeaveRequestForApprovalList()), //liste
        ],
      ),
    );
  }
}
