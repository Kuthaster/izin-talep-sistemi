import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/status.dart';
import 'package:izin_talep_sistemi/theme/theme_extensions.dart';

class StatusSummaryTile extends StatelessWidget {
  final StatusType status;
  final int value;

  const StatusSummaryTile({
    super.key,
    required this.status,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: 90,
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 3))),
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                getStatusLabel(status),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: const TextStyle(
                  fontSize: 12,
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

class StatusChip extends StatelessWidget {
  final StatusType status;
  final int count;

  const StatusChip({super.key, required this.status, required this.count});

  @override
  Widget build(BuildContext context) {
    final bg = getStatusBackgroundColor(status);
    final fg = getStatusTextColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        "${getStatusLabel(status)}: $count",
        style: TextStyle(color: fg, fontWeight: FontWeight.w800, fontSize: 12),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class LeaveTypeCard extends StatelessWidget {
  final String leaveTypeName;
  final Map<StatusType, int> statusCounts;

  const LeaveTypeCard({
    super.key,
    required this.leaveTypeName,
    required this.statusCounts,
  });

  @override
  Widget build(BuildContext context) {
    final order = const [
      StatusType.pending,
      StatusType.approved,
      StatusType.rejected,
      StatusType.cancelled,
    ];

    final total = order.fold<int>(0, (sum, s) => sum + (statusCounts[s] ?? 0));

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(right: 10, bottom: 5),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            leaveTypeName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusChip(
                status: StatusType.pending,
                count: statusCounts[StatusType.pending] ?? 0,
              ),
              StatusChip(
                status: StatusType.approved,
                count: statusCounts[StatusType.approved] ?? 0,
              ),
              StatusChip(
                status: StatusType.rejected,
                count: statusCounts[StatusType.rejected] ?? 0,
              ),
              StatusChip(
                status: StatusType.cancelled,
                count: statusCounts[StatusType.cancelled] ?? 0,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Toplam: $total",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class LeaveTypeTilesScroller extends ConsumerStatefulWidget {
  final double availableHeight;
  final List<LeaveTypeTileModel> items;

  const LeaveTypeTilesScroller({
    super.key,
    required this.items,
    required this.availableHeight,
  });

  @override
  ConsumerState<LeaveTypeTilesScroller> createState() =>
      _LeaveTypeTilesScrollerState();
}

class _LeaveTypeTilesScrollerState
    extends ConsumerState<LeaveTypeTilesScroller> {
  @override
  Widget build(BuildContext context) {
    final expandedBudget = (widget.availableHeight * 0.5).clamp(120.0, 300.0);

    return ExpansionTile(
      title: const Text("Dashboard"),
      children: [
        SizedBox(
          height: expandedBudget,
          child: ListView.builder(
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final it = widget.items[index];
              return LeaveTypeCard(
                leaveTypeName: it.leaveTypeName,
                statusCounts: it.statusCounts,
              );
            },
          ),
        ),
      ],
    );
  }
}

class LeaveTypeTileModel {
  final String leaveTypeName;
  final Map<StatusType, int> statusCounts;

  const LeaveTypeTileModel({
    required this.leaveTypeName,
    required this.statusCounts,
  });
}
