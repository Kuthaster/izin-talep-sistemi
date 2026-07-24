import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum StatusType { pending, approved, rejected, cancelled, active, inactive }

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

  Color _getBackgroundColor() {
    switch (status) {
      case StatusType.pending:
        return Colors.orange[100]!;
      case StatusType.approved:
        return Colors.green[100]!;
      case StatusType.rejected:
        return Colors.red[100]!;
      case StatusType.cancelled:
        return Colors.grey[300]!;
      case StatusType.active:
        return Colors.blue[100]!;
      case StatusType.inactive:
        return Colors.grey[300]!;
    }
  }

  Color _getTextColor() {
    switch (status) {
      case StatusType.pending:
        return Colors.orange[900]!;
      case StatusType.approved:
        return Colors.green[900]!;
      case StatusType.rejected:
        return Colors.red[900]!;
      case StatusType.cancelled:
        return Colors.grey[700]!;
      case StatusType.active:
        return Colors.blue[900]!;
      case StatusType.inactive:
        return Colors.grey[700]!;
    }
  }

  String _getDefaultLabel() {
    switch (status) {
      case StatusType.pending:
        return 'Pending';
      case StatusType.approved:
        return 'Approved';
      case StatusType.rejected:
        return 'Rejected';
      case StatusType.cancelled:
        return 'Cancelled';
      case StatusType.active:
        return 'Active';
      case StatusType.inactive:
        return 'Inactive';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final radius = BorderRadius.only(
      bottomRight: const Radius.elliptical(25, 40),
      topLeft: const Radius.elliptical(25, 40),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: radius,
      splashColor: Colors.pinkAccent.withValues(alpha: 100),
      highlightColor: Colors.purpleAccent.withValues(alpha: 100),
      focusColor: Colors.amber.withValues(alpha: 100),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: radius,
        ),
        child: Text(
          label ?? _getDefaultLabel(),
          style: TextStyle(
            color: _getTextColor(),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
