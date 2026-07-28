import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:izin_talep_sistemi/models/leave_decision.dart';
import 'package:izin_talep_sistemi/models/leave_request_decision.dart';
import 'package:izin_talep_sistemi/providers/leave_request_approval_provider.dart';

import '../models/leave_request.dart';
import '../services/leave_request_service.dart';

class LeaveRequestForApprovalTile extends ConsumerWidget {
  final LeaveRequest request;

  const LeaveRequestForApprovalTile({super.key, required this.request});

  Color _statusBg(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange.shade100;
      case 'APPROVED':
        return Colors.green.shade100;
      case 'REJECTED':
        return Colors.red.shade100;
      case 'CANCELLED':
        return Colors.grey.shade300;
      default:
        return Colors.grey.shade200;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      case 'CANCELLED':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'PENDING':
        return 'Bekliyor · Sv $currentLevelPlaceholder';
      case 'APPROVED':
        return 'Onaylandı';
      case 'REJECTED':
        return 'Reddedildi';
      case 'CANCELLED':
        return 'İptal Edildi';
      default:
        return status;
    }
  }

  String get currentLevelPlaceholder => request.currentLevel.toString();

  String _initials(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  String _formatDateRange(DateTime start, DateTime end) {
    const months = [
      'Oca',
      'Şub',
      'Mar',
      'Nis',
      'May',
      'Haz',
      'Tem',
      'Ağu',
      'Eyl',
      'Eki',
      'Kas',
      'Ara',
    ];
    final startStr = '${start.day} ${months[start.month - 1]}';
    final endStr = '${end.day} ${months[end.month - 1]}';
    return '$startStr - $endStr';
  }

  int _dayCount(DateTime start, DateTime end) {
    return end.difference(start).inDays + 1;
  }

  Future<void> _decide(
    BuildContext context,
    WidgetRef ref,
    LeaveRequestDecision dto,
  ) async {
    try {
      await LeaveRequestService().decide(request.id, dto);
      ref.invalidate(leaveRequestsForApprovalProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Onay/Ret işlemi başarısız: $e')),
        );
      }
    }
  }

  Future<void> _approve(BuildContext context, WidgetRef ref) async {
    await _decide(
      context,
      ref,
      LeaveRequestDecision(decision: LeaveDecision.APPROVED, managerNote: null),
    );
  }

  Future<void> _reject(BuildContext context, WidgetRef ref) async {
    final note = await _showRejectReasonDialog(context);
    if (!context.mounted) return;

    if (note == null) return; // dialog cancelled
    await _decide(
      context,
      ref,
      LeaveRequestDecision(decision: LeaveDecision.REJECTED, managerNote: note),
    );
  }

  Widget _buildRow(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      child: Opacity(
        opacity: (request.status != 'PENDING') ? 1.0 : 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.deepPurple.shade100,
                  child: Text(
                    _initials(request.userName),
                    style: TextStyle(
                      color: Colors.deepPurple.shade900,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              request.userName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: _statusBg(request.status),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _statusLabel(request.status),
                              style: TextStyle(
                                fontSize: 11,
                                color: _statusColor(request.status),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${request.leaveTypeName} · ${_formatDateRange(request.startDate, request.endDate)} · ${_dayCount(request.startDate, request.endDate)} gün',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (request.status == 'PENDING') ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _approve(context, ref),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Onayla'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _reject(context, ref),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Reddet'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final row = _buildRow(context, ref);

    if (request.status != 'PENDING') return row;

    return Slidable(
      key: ValueKey(request.id),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => _approve(context, ref),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.check,
            label: 'Onayla',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => _reject(context, ref),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.close,
            label: 'Reddet',
          ),
        ],
      ),
      child: row,
    );
  }
}

Future<String?> _showRejectReasonDialog(BuildContext context) async {
  final controller = TextEditingController();
  return showDialog<String?>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Ret Nedeni'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: 'Neden (opsiyonel)'),
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Vazgeç'),
        ),
        TextButton(
          onPressed: () {
            final text = controller.text.trim();
            Navigator.pop(context, text.isEmpty ? '' : text);
          },
          child: const Text('Reddet'),
        ),
      ],
    ),
  );
}
