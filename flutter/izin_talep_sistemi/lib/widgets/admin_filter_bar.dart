import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/leave_request_filter.dart';
import 'package:izin_talep_sistemi/providers/leave_type_provider.dart';
import 'package:izin_talep_sistemi/theme/theme_extensions.dart';

class AdminApprovalFilterBar extends ConsumerWidget {
  final LeaveRequestFilter filter;
  final ValueChanged<LeaveRequestFilter> onChanged;

  const AdminApprovalFilterBar({
    super.key,
    required this.filter,
    required this.onChanged,
  });

  static const _statusOptions = [
    'PENDING',
    'APPROVED',
    'REJECTED',
    'CANCELLED',
    'EXPIRED',
  ];
  static const _statusLabels = {
    'PENDING': 'Bekliyor',
    'APPROVED': 'Onaylandı',
    'REJECTED': 'Reddedildi',
    'CANCELLED': 'İptal Edildi',
    'EXPIRED': 'Süresi Doldu',
  };

  Future<void> _pickDate(BuildContext context, {required bool isFrom}) async {
    final picked = await showDatePicker(
      barrierDismissible: true,
      context: context,
      initialDate:
          (isFrom ? filter.startDateFrom : filter.startDateTo) ??
          DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    onChanged(
      LeaveRequestFilter(
        status: filter.status,
        reason: filter.reason,
        leaveTypeId: filter.leaveTypeId,
        startDateFrom: isFrom ? picked : filter.startDateFrom,
        startDateTo: isFrom ? filter.startDateTo : picked,
        approverId: filter.approverId,
        currentLevel: filter.currentLevel,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLeaveTypes = ref.watch(leaveTypesProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 160,
            child: DropdownButtonFormField<String>(
              iconDisabledColor: context.colors.tertiaryFixedDim,
              iconEnabledColor: context.colors.primary,
              initialValue: filter.status,
              decoration: const InputDecoration(
                labelText: 'Durum',
                isDense: true,
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('Tümü')),
                ..._statusOptions.map(
                  (s) => DropdownMenuItem(
                    value: s,
                    child: Text(_statusLabels[s]!),
                  ),
                ),
              ],
              onChanged: (value) => onChanged(
                LeaveRequestFilter(
                  status: value,
                  reason: filter.reason,
                  leaveTypeId: filter.leaveTypeId,
                  startDateFrom: filter.startDateFrom,
                  startDateTo: filter.startDateTo,
                  approverId: filter.approverId,
                  currentLevel: filter.currentLevel,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 200,
            child: asyncLeaveTypes.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => const Text('İzin türleri yüklenemedi'),
              data: (leaveTypes) => DropdownButtonFormField<int>(
                initialValue: filter.leaveTypeId,
                iconDisabledColor: Theme.of(
                  context,
                ).colorScheme.tertiaryFixedDim,
                iconEnabledColor: context.colors.primary,
                decoration: const InputDecoration(
                  labelText: 'İzin Türü',
                  isDense: true,
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Tümü')),
                  ...leaveTypes.map(
                    (lt) =>
                        DropdownMenuItem(value: lt.id, child: Text(lt.name)),
                  ),
                ],
                onChanged: (value) => onChanged(
                  LeaveRequestFilter(
                    status: filter.status,
                    reason: filter.reason,
                    leaveTypeId: value,
                    startDateFrom: filter.startDateFrom,
                    startDateTo: filter.startDateTo,
                    approverId: filter.approverId,
                    currentLevel: filter.currentLevel,
                  ),
                ),
              ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: () => _pickDate(context, isFrom: true),
            icon: const Icon(Icons.date_range, size: 16),
            label: Text(
              filter.startDateFrom == null
                  ? 'Başlangıç Tarihi'
                  : filter.startDateFrom!.toIso8601String().split('T').first,
            ),
          ),
          OutlinedButton.icon(
            onPressed: () => _pickDate(context, isFrom: false),
            icon: const Icon(Icons.date_range, size: 16),
            label: Text(
              filter.startDateTo == null
                  ? 'Bitiş Tarihi'
                  : filter.startDateTo!.toIso8601String().split('T').first,
            ),
          ),
          if (!filter.isEmpty)
            TextButton.icon(
              onPressed: () => onChanged(const LeaveRequestFilter()),
              icon: const Icon(Icons.clear, size: 16),
              label: const Text('Filtreleri Temizle'),
            ),
        ],
      ),
    );
  }
}
