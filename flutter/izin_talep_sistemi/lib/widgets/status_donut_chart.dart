import 'dart:math';
import 'package:flutter/material.dart';
import 'package:izin_talep_sistemi/models/status.dart';
import 'package:izin_talep_sistemi/theme/theme_extensions.dart';

class StatusDonutChart extends StatefulWidget {
  final Map<StatusType, int> statusCounts;

  const StatusDonutChart({super.key, required this.statusCounts});

  @override
  State<StatusDonutChart> createState() => _StatusDonutChartState();
}

class _StatusDonutChartState extends State<StatusDonutChart> {
  StatusType? _hovered;

  static const _order = [
    StatusType.pending,
    StatusType.approved,
    StatusType.rejected,
    StatusType.cancelled,
  ];

  @override
  Widget build(BuildContext context) {
    final total = _order.fold<int>(
      0,
      (sum, s) => sum + (widget.statusCounts[s] ?? 0),
    );
    final displayed = _hovered ?? StatusType.pending;
    final displayedValue = widget.statusCounts[displayed] ?? 0;

    return Column(
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) {
              _onHover(details.localPosition);
            },
            onTapUp: (_) => setState(() => _hovered = null),
            onTapCancel: () => setState(() => _hovered = null),
            onPanDown: (details) {
              _onHover(details.localPosition);
            },
            onPanUpdate: (details) {
              _onHover(details.localPosition);
            },
            onPanEnd: (_) => setState(() => _hovered = null),
            child: CustomPaint(
              size: const Size(180, 180),
              painter: _DonutPainter(
                statusCounts: widget.statusCounts,
                order: _order,
                total: total,
                hovered: _hovered,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$displayedValue',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: getStatusTextColor(displayed),
                      ),
                    ),
                    Text(
                      getStatusLabel(displayed),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,

                        color: getStatusTextColor(displayed),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 7,
          alignment: WrapAlignment.center,
          children: _order.map((s) {
            final count = widget.statusCounts[s] ?? 0;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: getStatusTextColor(s),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${getStatusLabel(s)} ($count)',
                  style: TextStyle(fontSize: 12, color: context.colors.primary),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  void _onHover(Offset localPosition) {
    const center = Offset(90, 90);
    final dx = localPosition.dx - center.dx;
    final dy = localPosition.dy - center.dy;
    final distance = sqrt(dx * dx + dy * dy);

    if (distance < 55 || distance > 90) {
      if (_hovered != null) setState(() => _hovered = null);
      return;
    }

    var angle = atan2(dy, dx) * 180 / pi;
    angle =
        (angle + 90 + 360) %
        360; // rotate so 0° starts at top, matching the painter

    final total = _order.fold<int>(
      0,
      (sum, s) => sum + (widget.statusCounts[s] ?? 0),
    );
    if (total == 0) return;

    double cursor = 0;
    for (final s in _order) {
      final sweep = ((widget.statusCounts[s] ?? 0) / total) * 360;
      if (angle >= cursor && angle < cursor + sweep) {
        if (_hovered != s) setState(() => _hovered = s);
        return;
      }
      cursor += sweep;
    }
  }
}

class _DonutPainter extends CustomPainter {
  final Map<StatusType, int> statusCounts;
  final List<StatusType> order;
  final int total;
  final StatusType? hovered;

  _DonutPainter({
    required this.statusCounts,
    required this.order,
    required this.total,
    required this.hovered,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 28.0;

    if (total == 0) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawCircle(center, radius, paint);
      return;
    }

    double startAngle = -pi / 2;
    for (final s in order) {
      final value = statusCounts[s] ?? 0;
      if (value == 0) continue;
      final sweep = (value / total) * 2 * pi;
      final isHovered = hovered == s;

      final paint = Paint()
        ..color = getStatusTextColor(s)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isHovered ? strokeWidth + 6 : strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        false,
        paint,
      );
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter oldDelegate) =>
      oldDelegate.hovered != hovered ||
      oldDelegate.statusCounts != statusCounts;
}
