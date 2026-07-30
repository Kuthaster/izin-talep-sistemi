import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/admin_appbar_provider.dart';
import 'package:izin_talep_sistemi/ultilities/date_utilities.dart';

import '../../models/leave_decision.dart';
import '../../models/leave_request.dart';
import '../../models/leave_request_decision.dart';
import '../../providers/leave_request_approval_provider.dart';
import '../../services/leave_request_service.dart';
import '../admin_data_table.dart';
import '../admin_status_chip.dart';

class ApprovalsSection extends ConsumerStatefulWidget {
  const ApprovalsSection({super.key});

  @override
  ConsumerState<ApprovalsSection> createState() => _ApprovalsSectionState();
}

class _ApprovalsSectionState extends ConsumerState<ApprovalsSection> {
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
  Widget build(BuildContext context) {
    final asyncRequests = ref.watch(leaveRequestsForApprovalProvider);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: asyncRequests.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Hata: $err')),
          data: (requests) => AdminDataTable<LeaveRequest>(
            dataSpacing: 75,
            items: requests,

            searchLabel: (request, query) =>
                request.userName.toLowerCase().contains(query.toLowerCase()),
            columnLabels: const [
              'Çalışan',
              'İzin Türü',
              'Başlangıç',
              'Bitiş',
              'Gün',
              'Seviye',
              'Durum',
              'Onayla/Reddet',
            ],
            sortComparators: [
              (a, b) => a.userName.compareTo(b.userName),
              (a, b) => a.leaveTypeName.compareTo(b.leaveTypeName),
              (a, b) => a.startDate.compareTo(b.startDate),
              (a, b) => a.endDate.compareTo(b.endDate),
              (a, b) => leaveDayCount(
                a.startDate,
                a.endDate,
              ).compareTo(leaveDayCount(b.startDate, b.endDate)),
              (a, b) => a.currentLevel.compareTo(b.currentLevel),
              (a, b) => a.status.compareTo(b.status),
              (a, b) => 0,
            ],
            buildCells: (request) => [
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
              DataCell(
                Text(
                  leaveDayCount(request.startDate, request.endDate).toString(),
                ),
              ),
              DataCell(Text(request.currentLevel.toString())),
              DataCell(AdminStatusChip(status: _statusType(request.status))),
              DataCell(
                request.status == 'PENDING'
                    ? Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
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
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
            emptyStateTitle: 'İzin talebi yok',
          ),
        ),
      ),
    );
  }
}
