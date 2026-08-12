import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/status.dart';

class AdminStatusChip extends ConsumerWidget {
  final StatusType status;
  final String? label;
  final VoidCallback? onTap;

  const AdminStatusChip({
    super.key,
    required this.status,
    this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final radius = BorderRadius.circular(10);

    return Container(
      height: 30,
      alignment: AlignmentGeometry.center,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: getStatusBackgroundColor(status),
        borderRadius: radius,
      ),
      child: Text(
        label ?? getStatusLabel(status),
        style: TextStyle(
          color: getStatusTextColor(status),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
