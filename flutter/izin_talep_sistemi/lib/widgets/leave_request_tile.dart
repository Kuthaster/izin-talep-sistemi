import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/leave_request.dart';
import '../providers/leave_request_provider.dart';
import '../services/leave_request_service.dart';
import 'create_request_form.dart';

class LeaveRequestTile extends ConsumerWidget {
  final LeaveRequest request;

  const LeaveRequestTile({super.key, required this.request});

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
        return 'Bekliyor · Sv ${request.currentLevel.toString()}';
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

  Future<void> _cancel(BuildContext context, WidgetRef ref) async {
    try {
      await LeaveRequestService().cancelLeaveRequest(request.id);
      ref.invalidate(leaveRequestsProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('İptal edilemedi: $e')));
      }
    }
  }

  void _edit(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CreateRequestForm(existingRequest: request),
    );
  }

  Widget _buildRow(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 243, 8, 8)),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(request.leaveTypeName),
        subtitle: Text(
          '${_statusLabel(request.status)} — Kademe ${request.currentLevel}',
        ),
        trailing: request.status == 'PENDING'
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () => _edit(context, ref),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => _cancel(context, ref),
                  ),
                ],
              )
            : Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _statusColor(request.status),
                  shape: BoxShape.circle,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final row = _buildRow(context, ref);

    if (request.status != 'PENDING') {
      return row;
    }

    return Slidable(
      key: ValueKey(request.id),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => _edit(context, ref),
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
