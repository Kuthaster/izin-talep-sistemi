import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/admin_appbar_provider.dart';
import 'package:izin_talep_sistemi/providers/balance_audits_provider.dart';
import 'package:izin_talep_sistemi/models/leave_balance_audit.dart';

import '../admin_data_table.dart';

class AdminBalanceAuditsSection extends ConsumerWidget {
  const AdminBalanceAuditsSection({super.key});

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year} '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAudits = ref.watch(balanceAuditsProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(adminAppBarProvider.notifier)
          .updateAppBar(
            title: 'Denetim Kayıtları',
            hasSearch: true,
            primaryActionLabel: null,
            onPrimaryAction: null,
          );
    });

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: asyncAudits.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Hata: $err')),
          data: (audits) => AdminDataTable<LeaveBalanceAudit>(
            dataSpacing: 100,
            items: audits,
            searchLabel: (audit, query) =>
                audit.userName.toLowerCase().contains(query.toLowerCase()) ||
                audit.adminName.toLowerCase().contains(query.toLowerCase()),
            columnLabels: const [
              'Çalışan',
              'İzin Türü',
              'Eski Toplam',
              'Yeni Toplam',
              'Neden',
              'Admin',
              'Tarih',
            ],
            sortComparators: [
              (a, b) => a.userName.compareTo(b.userName),
              (a, b) => a.leaveTypeName.compareTo(b.leaveTypeName),
              (a, b) => a.oldTotalDays.compareTo(b.oldTotalDays),
              (a, b) => a.newTotalDays.compareTo(b.newTotalDays),
              (a, b) => a.reason.compareTo(b.reason),
              (a, b) => a.adminName.compareTo(b.adminName),
              (a, b) => a.changedAt.compareTo(b.changedAt),
            ],
            buildCells: (audit) => [
              DataCell(Text(audit.userName)),
              DataCell(Text(audit.leaveTypeName)),
              DataCell(Text(audit.oldTotalDays.toString())),
              DataCell(Text(audit.newTotalDays.toString())),
              DataCell(Text(audit.reason)),
              DataCell(Text(audit.adminName)),
              DataCell(Text(_fmt(audit.changedAt))),
            ],
            emptyStateTitle: 'Henüz bir bakiye değişikliği yapılmamış',
          ),
        ),
      ),
    );
  }
}
