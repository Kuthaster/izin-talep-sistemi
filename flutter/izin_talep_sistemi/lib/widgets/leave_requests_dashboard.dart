import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/leave_request_provider.dart';

class LeaveRequestsDashboard extends ConsumerWidget {
  const LeaveRequestsDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRequests = ref.watch(leaveRequestsProvider);

    return asyncRequests.when(
      loading: () => const SizedBox(
        height: 85,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) =>
          SizedBox(height: 85, child: Center(child: Text('Hata: $err'))),
      data: (requests) {
        final pending = requests.where((r) => r.status == 'PENDING').length;
        final approved = requests.where((r) => r.status == 'APPROVED').length;
        final rejected = requests.where((r) => r.status == 'REJECTED').length;
        final cancelled = requests.where((r) => r.status == 'CANCELLED').length;
        final expired = requests.where((r) => r.status == 'EXPIRED').length;

        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NumberCard(value: pending, label: 'Bekleyen'),
                _NumberCard(value: approved, label: 'Onaylanan'),
                _NumberCard(value: rejected, label: 'Reddedilen'),
                _NumberCard(value: cancelled, label: 'İptal edilen'),
                _NumberCard(value: expired, label: 'Süresi dolan'),
                _NumberCard(value: requests.length, label: 'Toplam'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NumberCard extends StatelessWidget {
  final String label;
  final int value;

  const _NumberCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      width: 70,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: Color.fromRGBO(9, 138, 188, 0.929), width: 3),
          bottom: BorderSide(
            color: Color.fromRGBO(9, 138, 188, 0.929),
            width: 3,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 233, 215, 13),
              ),
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.visible,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 233, 215, 13),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
