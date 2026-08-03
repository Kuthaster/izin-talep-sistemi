import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/leave_request_count.dart';
import 'package:izin_talep_sistemi/providers/leave_request_service_provider.dart';

class RequestCountDashboard extends ConsumerWidget {
  const RequestCountDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.read(leaveRequestServiceProvider);

    return FutureBuilder<LeaveRequestCount>(
      future: service.getLeaveRequestCount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text("Veri yok"));
        }

        final data = snapshot.data!;

        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NumberCard(value: data.pending, label: "Bekleyen"),
                _NumberCard(value: data.approved, label: "Onaylanan"),
                _NumberCard(value: data.rejected, label: "Reddedilen"),
                _NumberCard(value: data.cancelled, label: "İptal edilen"),
                _NumberCard(value: data.total, label: "Toplam"),
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
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Color.fromRGBO(9, 138, 188, 0.929), width: 3),
          bottom: BorderSide(
            color: Color.fromRGBO(9, 138, 188, 0.929),
            width: 3,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 15),
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
