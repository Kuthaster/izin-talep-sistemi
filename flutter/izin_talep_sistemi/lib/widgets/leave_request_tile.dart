import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:izin_talep_sistemi/models/status.dart';
import 'package:izin_talep_sistemi/providers/leave_balance_provider.dart';
import 'package:izin_talep_sistemi/providers/leave_request_service_provider.dart';
import 'package:izin_talep_sistemi/theme/theme_extensions.dart';
import 'package:izin_talep_sistemi/widgets/leave_request_detail_sheet.dart';

import '../models/leave_request.dart';
import '../providers/leave_request_provider.dart';
import 'create_request_form.dart';

class LeaveRequestTile extends ConsumerWidget {
  final LeaveRequest request;

  const LeaveRequestTile({super.key, required this.request});

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

  Future<void> _cancel(BuildContext context, WidgetRef ref) async {
    try {
      final leaveRequestService = ref.read(leaveRequestServiceProvider);
      await leaveRequestService.cancelLeaveRequest(request.id);
      ref.invalidate(leaveRequestsProvider);
      ref.invalidate(leaveBalancesProvider);
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
    final StatusType status = convertToStatusType(request.status);
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => LeaveRequestDetailSheet(request: request),
      ),
      child: Container(
        decoration: BoxDecoration(color: context.colors.surface),
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
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: getStatusBackgroundColor(status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      getStatusLabel(status),
                      style: TextStyle(
                        fontSize: 11,
                        color: getStatusTextColor(status),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '${_formatDateRange(request.startDate, request.endDate)} · ${request.requestedDays} iş günü',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
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
