import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/leave_request_count.dart';
import 'package:izin_talep_sistemi/models/leave_type_count.dart';
import 'package:izin_talep_sistemi/models/status.dart';
import 'package:izin_talep_sistemi/providers/reports_service_provider.dart';
import 'package:izin_talep_sistemi/widgets/status_donut_chart.dart';
import 'package:izin_talep_sistemi/widgets/status_summary_tile.dart';

class ApprovalCountDashboard extends ConsumerWidget {
  const ApprovalCountDashboard({super.key});

  Map<StatusType, int> _toStatusMap(LeaveRequestCount data) => {
    StatusType.pending: data.pending,
    StatusType.approved: data.approved,
    StatusType.rejected: data.rejected,
    StatusType.cancelled: data.cancelled,
  };

  Map<StatusType, int> _typeToStatusMap(LeaveTypeCount t) => {
    StatusType.pending: t.pending,
    StatusType.approved: t.approved,
    StatusType.rejected: t.rejected,
    StatusType.cancelled: t.cancelled,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.read(reportsServiceProvider);

    return FutureBuilder(
      future: Future.wait([
        report.getLeaveRequestCount(),
        report.getLeaveRequestCountByLeaveType(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Hata: ${snapshot.error}"));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text("Veri yok"));
        }

        final overall = snapshot.data![0] as LeaveRequestCount;
        final byType = snapshot.data![1] as List<LeaveTypeCount>;

        return LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 700;

            final donut = Padding(
              padding: const EdgeInsets.all(12),
              child: StatusDonutChart(statusCounts: _toStatusMap(overall)),
            );

            final cards = LeaveTypeTilesScroller(
              items: byType
                  .map(
                    (t) => LeaveTypeTileModel(
                      leaveTypeName: t.leaveTypeName,
                      statusCounts: _typeToStatusMap(t),
                    ),
                  )
                  .toList(),
              availableHeight: constraints.maxHeight,
            );

            if (isNarrow) {
              return Column(
                children: [donut, const SizedBox(height: 12), cards],
              );
            }

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: donut),
                  Expanded(flex: 3, child: cards),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
