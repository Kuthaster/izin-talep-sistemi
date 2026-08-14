import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/leave_balance_provider.dart';
import 'package:izin_talep_sistemi/theme/theme_extensions.dart';
import 'package:izin_talep_sistemi/widgets/dashboard_ring.dart';

class MainBalanceSection extends ConsumerWidget {
  const MainBalanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBalances = ref.watch(leaveBalancesProvider);

    return asyncBalances.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Hata: $err')),
      data: (balances) => RefreshIndicator(
        onRefresh: () => ref.refresh(leaveBalancesProvider.future),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: balances.length,
          itemBuilder: (context, i) {
            final b = balances[i];
            return _BalanceCard(
              leaveTypeName: b.leaveTypeName,
              totalDays: b.totalDays,
              usedDays: b.usedDays,
              reservedDays: b.reservedDays,
              availableDays: b.availableDays,
            );
          },
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final String leaveTypeName;
  final int totalDays;
  final int usedDays;
  final int reservedDays;
  final int availableDays;

  const _BalanceCard({
    required this.leaveTypeName,
    required this.totalDays,
    required this.usedDays,
    required this.reservedDays,
    required this.availableDays,
  });
  Color _colorForRatio(double ratio) {
    if (ratio > 0.5) return Colors.green;
    if (ratio > 0.2) return Colors.amber;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final ratio = totalDays == 0 ? 0.0 : availableDays / totalDays;
    final ringColor = _colorForRatio(ratio);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          DashboardRing(
            ratio: ratio,
            color: ringColor,
            center: Text(
              '$availableDays',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(leaveTypeName, style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      'Kullanılan: $usedDays',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.colors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'Rezerve: $reservedDays',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.colors.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
