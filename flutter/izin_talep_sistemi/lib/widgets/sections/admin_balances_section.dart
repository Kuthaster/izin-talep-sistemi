import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/admin_appbar_provider.dart';
import 'package:izin_talep_sistemi/providers/leave_balance_service_provider.dart';
import 'package:izin_talep_sistemi/providers/admin_user_balances_provider.dart';
import 'package:izin_talep_sistemi/models/leave_balance.dart';
import 'package:izin_talep_sistemi/models/leave_balance_update.dart';

import '../admin_data_table.dart';

class AdminBalanceSection extends ConsumerStatefulWidget {
  const AdminBalanceSection({super.key});

  @override
  ConsumerState<AdminBalanceSection> createState() =>
      _AdminBalanceSectionState();
}

class _AdminBalanceSectionState extends ConsumerState<AdminBalanceSection> {
  Future<void> _editBalance(LeaveBalance balance) async {
    final totalController = TextEditingController(
      text: balance.totalDays.toString(),
    );
    final reasonController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '${balance.userName} — ${balance.leaveTypeName} (${balance.year})',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: totalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Yeni Toplam Gün'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(labelText: 'Neden'),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final newTotal = int.tryParse(totalController.text.trim());
    final reason = reasonController.text.trim();
    if (newTotal == null || reason.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Geçerli bir gün sayısı ve neden girin'),
          ),
        );
      }
      return;
    }

    try {
      final service = ref.read(leaveBalanceServiceProvider);
      await service.updateBalance(
        balance.id,
        LeaveBalanceUpdate(newTotalDays: newTotal, reason: reason),
      );
      ref.invalidate(adminUserBalancesProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Güncellenemedi: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncBalances = ref.watch(adminUserBalancesProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(adminAppBarProvider.notifier)
          .updateAppBar(title: 'Bakiyeler', hasSearch: true);
    });

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: asyncBalances.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Hata: $err')),
          data: (balances) => AdminDataTable<LeaveBalance>(
            items: balances,
            searchLabel: (balance, query) =>
                balance.userName.toLowerCase().contains(query.toLowerCase()),
            columnLabels: const [
              'Çalışan',
              'İzin Türü',
              'Yıl',
              'Toplam',
              'Kullanılan',
              'Rezerve',
              'Kalan',
              '',
            ],
            sortComparators: [
              (a, b) => a.userName.compareTo(b.userName),
              (a, b) => a.leaveTypeName.compareTo(b.leaveTypeName),
              (a, b) => a.year.compareTo(b.year),
              (a, b) => a.totalDays.compareTo(b.totalDays),
              (a, b) => a.usedDays.compareTo(b.usedDays),
              (a, b) => a.reservedDays.compareTo(b.reservedDays),
              (a, b) => a.availableDays.compareTo(b.availableDays),
              (a, b) => 0,
            ],
            buildCells: (balance) => [
              DataCell(Text(balance.userName)),
              DataCell(Text(balance.leaveTypeName)),
              DataCell(Text(balance.year.toString())),
              DataCell(Text(balance.totalDays.toString())),
              DataCell(Text(balance.usedDays.toString())),
              DataCell(Text(balance.reservedDays.toString())),
              DataCell(Text(balance.availableDays.toString())),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () => _editBalance(balance),
                  tooltip: 'Düzenle',
                ),
              ),
            ],
            emptyStateTitle: 'Bakiye kaydı yok',
          ),
        ),
      ),
    );
  }
}
