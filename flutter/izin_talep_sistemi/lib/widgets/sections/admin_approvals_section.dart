import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/status.dart';
import 'package:izin_talep_sistemi/providers/admin_appbar_provider.dart';
import 'package:izin_talep_sistemi/providers/admin_approval_filter_provider.dart';
import 'package:izin_talep_sistemi/providers/leave_request_service_provider.dart';
import 'package:izin_talep_sistemi/ultilities/date_utilities.dart';
import 'package:izin_talep_sistemi/widgets/admin_filter_bar.dart';

import '../../models/leave_decision.dart';
import '../../models/leave_request.dart';
import '../../models/leave_request_decision.dart';
import '../../providers/leave_request_approval_provider.dart';
import '../../services/leave_request_service.dart';
import '../admin_data_table.dart';
import '../admin_status_chip.dart';

class AdminApprovalsSection extends ConsumerStatefulWidget {
  const AdminApprovalsSection({super.key});

  @override
  ConsumerState<AdminApprovalsSection> createState() =>
      _AdminApprovalsSectionState();
}

class _AdminApprovalsSectionState extends ConsumerState<AdminApprovalsSection> {
  LeaveRequestService get _leaveRequestService =>
      ref.read(leaveRequestServiceProvider);

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
      await _leaveRequestService.decide(
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

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    LeaveRequest request,
  ) async {
    final id = request.id;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final start = request.startDate;
        final end = request.endDate;
        final created = request.createdAt;

        String fmt(DateTime d) =>
            "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

        return AlertDialog(
          title: const Text("Talep Silme Onayı"),
          content: Text(
            "ID: ${request.id} • Kullanıcı: ${request.userName} • Tip: ${request.leaveTypeName}\n"
            "İzin Tarih Aralığı: ${fmt(start)} → ${fmt(end)} • Durum: ${request.status}\n"
            "Oluşturulma Tarihi: ${fmt(created)} • Seviye: ${request.currentLevel}\n\n"
            "İzni Silmek İstediğinizden Emin Misiniz?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('İPTAL ET'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context, true);
              },
              child: const Text('TALEBİ SİL'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    try {
      await _leaveRequestService.deleteLeaveRequest(id);
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
    final asyncRequests = ref.watch(adminApprovalsProvider);
    final currentFilter = ref.watch(approvalFilterProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(adminAppBarProvider.notifier)
          .updateAppBar(
            title: 'İzinler',
            hasSearch: true,
            onPrimaryAction: null,
          );
    });

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminApprovalFilterBar(
              filter: currentFilter,
              onChanged: (newFilter) =>
                  ref.read(adminApprovalFilterProvider.notifier).state =
                      newFilter,
            ),
            Expanded(
              child: asyncRequests.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Hata: $err')),
                data: (requests) => AdminDataTable<LeaveRequest>(
                  dataSpacing: 92,
                  items: requests,

                  searchLabel: (request, query) => request.userName
                      .toLowerCase()
                      .contains(query.toLowerCase()),
                  columnLabels: const [
                    'Çalışan',
                    'İzin Türü',
                    'Başlangıç',
                    'Bitiş',
                    'Gün',
                    'Seviye',
                    'Durum',
                    '',
                    // 'Onayla/Reddet',
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
                        leaveDayCount(
                          request.startDate,
                          request.endDate,
                        ).toString(),
                      ),
                    ),
                    DataCell(Text(request.currentLevel.toString())),
                    DataCell(
                      AdminStatusChip(
                        status: convertToStatusType(request.status),
                      ),
                    ),
                    DataCell(
                      MenuAnchor(
                        consumeOutsideTap: true,
                        alignmentOffset: const Offset(-50, 0),
                        builder:
                            (
                              BuildContext context,
                              MenuController controller,
                              Widget? child,
                            ) {
                              return IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: controller.open,
                                tooltip: 'Eylemler',
                              );
                            },
                        menuChildren: [
                          if (request.status == "PENDING")
                            MenuItemButton(
                              onPressed: () {
                                _decide(
                                  context,
                                  ref,
                                  request,
                                  LeaveDecision.APPROVED,
                                );
                                Navigator.of(context).pop();
                              },
                              leadingIcon: const Icon(Icons.check, size: 16),
                              child: const Text("İzni Onayla"),
                            ),
                          if (request.status == "PENDING")
                            MenuItemButton(
                              onPressed: () => _decide(
                                context,
                                ref,
                                request,
                                LeaveDecision.REJECTED,
                              ),
                              leadingIcon: const Icon(Icons.close, size: 16),
                              child: const Text("İzni Reddet"),
                            ),
                          MenuItemButton(
                            onPressed: () => _delete(context, ref, request),
                            leadingIcon: const Icon(
                              Icons.delete_forever,
                              size: 16,
                            ),
                            child: const Text("İzni Sil"),
                          ),
                        ],
                      ),
                    ),
                  ],
                  emptyStateTitle: 'İzin talebi yok',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
