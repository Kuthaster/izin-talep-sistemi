import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:izin_talep_sistemi/models/leave_decision.dart';
import 'package:izin_talep_sistemi/models/leave_request_decision.dart';
import 'package:izin_talep_sistemi/models/status.dart';
import 'package:izin_talep_sistemi/providers/auth_provider.dart';
import 'package:izin_talep_sistemi/providers/leave_request_approval_provider.dart';
import 'package:izin_talep_sistemi/providers/leave_request_service_provider.dart';
import 'package:izin_talep_sistemi/theme/theme_extensions.dart';
import 'package:izin_talep_sistemi/widgets/leave_request_detail_sheet.dart';

import '../models/leave_request.dart';

class LeaveRequestForApprovalTile extends ConsumerWidget {
  final LeaveRequest request;

  const LeaveRequestForApprovalTile({super.key, required this.request});

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
      final leaveRequestService = ref.read(leaveRequestServiceProvider);
      await leaveRequestService.decide(request.id, dto);
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

    await _decide(
      context,
      ref,
      LeaveRequestDecision(decision: LeaveDecision.REJECTED, managerNote: note),
    );
  }

  Widget _buildRow(BuildContext context, WidgetRef ref, bool canAct) {
    final StatusType status = convertToStatusType(request.status);
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => LeaveRequestDetailSheet(request: request),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLow,
          border: Border.all(
            width: 0.5, //TODO approval divider thickness bak buna
            color: context.colors.outline,
          ), //TODO approval tile background değiştir
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
                        color: context.colors.primary,
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
                          '${request.leaveTypeName} · ${_formatDateRange(request.startDate, request.endDate)} · ${_dayCount(request.startDate, request.endDate)} iş günü',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (request.status == 'PENDING') ...[
                const SizedBox(height: 10),
                if (canAct)
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _approve(context, ref),
                          style: FilledButton.styleFrom(
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
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Bu talep Seviye ${request.currentLevel} onayı bekliyor, sizin seviyenizde değil.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authProvider).value;
    final myLevel = currentUser != null
        ? _levelForRole(currentUser.roleAuthority.name)
        : null;
    final isAdmin = currentUser?.roleAuthority.name == 'ADMIN';
    final canAct =
        isAdmin || (myLevel != null && myLevel == request.currentLevel);
    final row = _buildRow(context, ref, canAct);
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

int? _levelForRole(String roleAuthority) {
  switch (roleAuthority) {
    case 'MANAGER_LEVEL_1':
      return 1;
    case 'MANAGER_LEVEL_2':
      return 2;
    case 'MANAGER_LEVEL_3':
      return 3;
    default:
      return null;
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
