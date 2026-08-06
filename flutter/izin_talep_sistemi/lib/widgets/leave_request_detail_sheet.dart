import 'package:flutter/material.dart';
import 'package:izin_talep_sistemi/models/leave_request.dart';
import 'package:izin_talep_sistemi/models/leave_request_approval.dart';
import 'package:izin_talep_sistemi/models/leave_decision.dart';

class LeaveRequestDetailSheet extends StatelessWidget {
  final LeaveRequest request;

  const LeaveRequestDetailSheet({super.key, required this.request});

  static const _months = [
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

  String _fmtDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

  String _fmtDateTime(DateTime d) =>
      '${_fmtDate(d)} · ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  int get _dayCount => request.endDate.difference(request.startDate).inDays + 1;

  Color _statusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange.shade900;
      case 'APPROVED':
        return Colors.green.shade900;
      case 'REJECTED':
        return Colors.red.shade900;
      case 'CANCELLED':
        return Colors.grey.shade900;
      case 'EXPIRED':
        return Colors.white;
      default:
        return Colors.white;
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
      case 'EXPIRED':
        return 'Süresi Doldu';
      default:
        return status;
    }
  }

  Color _decisionColor(LeaveDecision decision) {
    switch (decision) {
      case LeaveDecision.APPROVED:
        return Colors.green;
      case LeaveDecision.REJECTED:
        return Colors.red;
    }
  }

  IconData _decisionIcon(LeaveDecision decision) {
    switch (decision) {
      case LeaveDecision.APPROVED:
        return Icons.check_circle;
      case LeaveDecision.REJECTED:
        return Icons.cancel;
    }
  }

  String _decisionLabel(LeaveDecision decision) {
    switch (decision) {
      case LeaveDecision.APPROVED:
        return 'Onayladı';
      case LeaveDecision.REJECTED:
        return 'Reddetti';
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedApprovals = [...request.approvals]
      ..sort((a, b) => a.level.compareTo(b.level));

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              controller: scrollController,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        request.leaveTypeName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor(
                          request.status,
                        ).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        request.status,
                        style: TextStyle(
                          color: _statusColor(_statusLabel(request.status)),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _DetailRow(
                  icon: Icons.calendar_today,
                  label: 'Tarih Aralığı',
                  value:
                      '${_fmtDate(request.startDate)} — ${_fmtDate(request.endDate)}',
                ),
                _DetailRow(
                  icon: Icons.timelapse,
                  label: 'Gün Sayısı',
                  value: '$_dayCount gün',
                ),
                _DetailRow(
                  icon: Icons.layers,
                  label: 'Mevcut Seviye',
                  value: 'Seviye ${request.currentLevel}',
                ),
                _DetailRow(
                  icon: Icons.event_available,
                  label: 'Oluşturulma',
                  value: _fmtDateTime(request.createdAt),
                ),
                if (request.reason != null && request.reason!.isNotEmpty)
                  _DetailRow(
                    icon: Icons.notes,
                    label: 'Neden',
                    value: request.reason!,
                  ),

                const SizedBox(height: 24),
                const Text(
                  'Onay Geçmişi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                if (sortedApprovals.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Henüz bir karar verilmedi.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
                else
                  ...sortedApprovals.map(
                    (approval) => _ApprovalTile(
                      approval: approval,
                      color: _decisionColor(approval.decision),
                      icon: _decisionIcon(approval.decision),
                      label: _decisionLabel(approval.decision),
                      fmtDateTime: _fmtDateTime,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,

      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 10),
            Text(
              '$label: ',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApprovalTile extends StatelessWidget {
  final LeaveRequestApproval approval;
  final Color color;
  final IconData icon;
  final String label;
  final String Function(DateTime) fmtDateTime;

  const _ApprovalTile({
    required this.approval,
    required this.color,
    required this.icon,
    required this.label,
    required this.fmtDateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,

      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seviye ${approval.level} · ${approval.approverName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '$label · ${fmtDateTime(approval.decidedAt)}',
                    style: TextStyle(fontSize: 12, color: color),
                  ),
                  if (approval.note != null && approval.note!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      '"${approval.note}"',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
