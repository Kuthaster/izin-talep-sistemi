import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/leave_request_approval_provider.dart';
import '../../models/leave_request.dart';
import '../../models/leave_decision.dart';
import '../../models/leave_request_decision.dart';
import '../../services/leave_request_service.dart';
import '../admin_app_bar.dart';
import '../admin_data_table.dart';
import '../admin_status_chip.dart';

class ApprovalsSection extends ConsumerWidget {
  const ApprovalsSection({super.key});

  StatusType _statusType(String status) {
    switch (status) {
      case 'PENDING':
        return StatusType.pending;
      case 'APPROVED':
        return StatusType.approved;
      case 'REJECTED':
        return StatusType.rejected;
      default:
        return StatusType.cancelled;
    }
  }

  Future<void> _decide(
    BuildContext context,
    WidgetRef ref,
    LeaveRequest request,
    LeaveDecision decision,
  ) async {
    String? note;
    if (decision == LeaveDecision.REJECTED) {
      final controller = TextEditingController();
      note = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Red Nedeni'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Neden (opsiyonel)'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Vazgeç'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Reddet'),
            ),
          ],
        ),
      );
      if (note == null) return;
    }

    try {
      await LeaveRequestService().decide(
        request.id,
        LeaveRequestDecision(decision: decision, managerNote: note),
      );
      ref.invalidate(leaveRequestsForApprovalProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('İşlem başarısız: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRequests = ref.watch(leaveRequestsForApprovalProvider);

    return Column(
      children: [
        AdminAppBar(
          title: 'İzin Talepleri',
          additionalActions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(leaveRequestsForApprovalProvider),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: asyncRequests.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Hata: $err')),
              data: (requests) => AdminDataTable<LeaveRequest>(
                items: requests,
                columns: const [
                  DataColumn(label: Text('Çalışan')),
                  DataColumn(label: Text('İzin Türü')),
                  DataColumn(label: Text('Başlangıç')),
                  DataColumn(label: Text('Bitiş')),
                  DataColumn(label: Text('Seviye')),
                  DataColumn(label: Text('Durum')),
                  DataColumn(label: Text('')),
                ],
                buildRows: (items) => items.map((request) {
                  return DataRow(
                    cells: [
                      DataCell(Text(request.userName)),
                      DataCell(Text(request.leaveTypeName)),
                      DataCell(
                        Text(
                          '${request.startDate.year}-${request.startDate.month}-${request.startDate.day}',
                        ),
                      ),
                      DataCell(
                        Text(
                          '${request.endDate.year}-${request.endDate.month}-${request.endDate.day}',
                        ),
                      ),
                      DataCell(Text(request.currentLevel.toString())),
                      DataCell(
                        AdminStatusChip(status: _statusType(request.status)),
                      ),
                      DataCell(
                        request.status == 'PENDING'
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.check,
                                      size: 18,
                                      color: Colors.green,
                                    ),
                                    onPressed: () => _decide(
                                      context,
                                      ref,
                                      request,
                                      LeaveDecision.APPROVED,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _decide(
                                      context,
                                      ref,
                                      request,
                                      LeaveDecision.REJECTED,
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  );
                }).toList(),
                emptyStateTitle: 'İzin talebi yok',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
