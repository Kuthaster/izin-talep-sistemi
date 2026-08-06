import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/leave_balance_provider.dart';

class MainBalanceSection extends ConsumerWidget {
  const MainBalanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBalances = ref.watch(leaveBalancesProvider);

    return asyncBalances.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Hata: $err')),
      data: (balances) => ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: balances.length,
        itemBuilder: (context, i) {
          final b = balances[i];
          final usedRatio = b.totalDays == 0 ? 0.0 : b.usedDays / b.totalDays;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  b.leaveTypeName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: usedRatio.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kullanılan: ${b.usedDays}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Rezerve: ${b.reservedDays}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Kalan: ${b.availableDays}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
