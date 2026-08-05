import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/admin_appbar_provider.dart';
import 'package:izin_talep_sistemi/providers/leave_request_service_provider.dart';
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
  LeaveRequestService get _leaveRequestService =>
      ref.read(leaveRequestServiceProvider);

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
    final asyncRequests = ref.watch(leaveRequestsForApprovalProvider);
    final scheme = Theme.of(context).colorScheme;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(adminAppBarProvider.notifier)
          .updateAppBar(title: 'İzinler', hasSearch: true);
    });

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
                  leaveDayCount(request.startDate, request.endDate).toString(),
                ),
              ),
              DataCell(Text(request.currentLevel.toString())),
              DataCell(AdminStatusChip(status: _statusType(request.status))),
              DataCell(
                MenuAnchor(
                  consumeOutsideTap: true,
                  style: MenuStyle(
                    backgroundColor: WidgetStateProperty.all(scheme.primary),
                    minimumSize: WidgetStateProperty.all(const Size(80, 60)),
                    maximumSize: WidgetStateProperty.all(const Size(150, 120)),
                  ),
                  alignmentOffset: Offset(30, 0),
                  builder:
                      (
                        BuildContext context,
                        MenuController controller,
                        Widget? child,
                      ) {
                        return IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            controller.open();
                          },
                          tooltip: 'Eylemler',
                        );
                      },
                  menuChildren: [
                    MenuItemButton(
                      style: ButtonStyle(
                        alignment: AlignmentGeometry.center,
                        iconAlignment: IconAlignment.start,
                        foregroundColor: WidgetStateProperty.all(
                          scheme.onPrimary,
                        ),
                        minimumSize: WidgetStateProperty.all(Size(150, 30)),
                        maximumSize: WidgetStateProperty.all(Size(150, 40)),
                        textStyle: WidgetStateProperty.all(
                          TextStyle(
                            color: scheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      leadingIcon: const Icon(Icons.check, size: 12),
                      onPressed: () {
                        _decide(context, ref, request, LeaveDecision.APPROVED);
                        Navigator.of(context).pop();
                      },
                      child: Text("İzni Onayla"),
                    ),
                    MenuItemButton(
                      style: ButtonStyle(
                        alignment: AlignmentGeometry.center,

                        iconAlignment: IconAlignment.end,
                        backgroundColor: WidgetStateProperty.all(
                          scheme.tertiaryContainer,
                        ),
                        minimumSize: WidgetStateProperty.all(Size(150, 30)),
                        maximumSize: WidgetStateProperty.all(Size(150, 40)),
                      ),
                      leadingIcon: IconButton(
                        icon: const Icon(Icons.close, size: 12),
                        onPressed: () => _decide(
                          context,
                          ref,
                          request,
                          LeaveDecision.REJECTED,
                        ),
                      ),
                      child: Text("İzni Reddet"),
                    ),

                    MenuItemButton(
                      style: ButtonStyle(
                        iconAlignment: IconAlignment.start,
                        alignment: AlignmentGeometry.center,

                        backgroundColor: WidgetStateProperty.all(
                          scheme.tertiaryContainer,
                        ),
                        minimumSize: WidgetStateProperty.all(Size(180, 20)),
                        maximumSize: WidgetStateProperty.all(Size(180, 120)),
                      ),
                      leadingIcon: IconButton(
                        icon: const Icon(Icons.delete_forever, size: 12),
                        onPressed: () => _delete(
                          context,
                          ref,
                          request,
                        ), //BUNU TEST ETMEK LAZIM
                      ),
                      child: Text("İZNİ SİL"),
                    ),
                  ],
                ),
              ),
            ],
            emptyStateTitle: 'İzin talebi yok',
          ),
        ),
      ),
    );
  }
}
