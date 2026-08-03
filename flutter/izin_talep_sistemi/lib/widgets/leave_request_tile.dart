import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:izin_talep_sistemi/providers/leave_request_service_provider.dart';

import '../models/leave_request.dart';
import '../providers/leave_request_provider.dart';
import 'create_request_form.dart';

class LeaveRequestTile extends ConsumerWidget {
  final LeaveRequest request;

  const LeaveRequestTile({super.key, required this.request});

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
        return 'Bekliyor · Sv ${request.currentLevel}';
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
    return '${start.day} ${months[start.month - 1]} - ${end.day} ${months[end.month - 1]}';
  }

  int _dayCount(DateTime start, DateTime end) =>
      end.difference(start).inDays + 1;

  Future<void> _cancel(BuildContext context, WidgetRef ref) async {
    try {
      final leaveRequestService = ref.read(leaveRequestServiceProvider);
      await leaveRequestService.cancelLeaveRequest(request.id);
      ref.invalidate(leaveRequestsProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('İptal edilemedi: $e')));
      }
    }
  }

  void _edit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CreateRequestForm(existingRequest: request),
    );
  }

  Widget _buildRow(BuildContext context, WidgetRef ref) {
    final isPending = request.status == 'PENDING';

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      child: Opacity(
        opacity: isPending ? 1.0 : 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    request.leaveTypeName,
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
              '${_formatDateRange(request.startDate, request.endDate)} · ${_dayCount(request.startDate, request.endDate)} gün',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            if (isPending) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _edit(context),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Düzenle'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _cancel(context, ref),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('İptal Et'),
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
            onPressed: (_) => _edit(context),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Düzenle',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => _cancel(context, ref),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.close,
            label: 'İptal Et',
          ),
        ],
      ),
      child: row,
    );
  }
}
