import 'package:flutter/material.dart';
import 'package:izin_talep_sistemi/theme/compact_dialog_date_range_picker_theme.dart';

class CompactDialogDateRangePicker extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTimeRange? initialDateRange;

  const CompactDialogDateRangePicker({
    super.key,
    required this.firstDate,
    required this.lastDate,
    this.initialDateRange,
  });

  @override
  State<CompactDialogDateRangePicker> createState() =>
      _CompactDialogDateRangePickerState();
}

class _CompactDialogDateRangePickerState
    extends State<CompactDialogDateRangePicker> {
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    _rangeStart = widget.initialDateRange?.start;
    _rangeEnd = widget.initialDateRange?.end;
    _displayedMonth = DateTime(
      (_rangeStart ?? DateTime.now()).year,
      (_rangeStart ?? DateTime.now()).month,
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _inRange(DateTime day) {
    if (_rangeStart == null || _rangeEnd == null) return false;
    return day.isAfter(_rangeStart!.subtract(const Duration(days: 1))) &&
        day.isBefore(_rangeEnd!.add(const Duration(days: 1)));
  }

  void _onDayTap(DateTime day) {
    setState(() {
      if (_rangeStart == null || (_rangeStart != null && _rangeEnd != null)) {
        _rangeStart = day;
        _rangeEnd = null;
      } else if (day.isBefore(_rangeStart!)) {
        _rangeEnd = _rangeStart;
        _rangeStart = day;
      } else {
        _rangeEnd = day;
      }
    });
  }

  void _changeMonth(int delta) {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + delta,
      );
    });
  }

  List<DateTime?> _daysInMonth() {
    final first = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final daysBefore = first.weekday % 7; // Sunday-first grid
    final daysInMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      0,
    ).day;

    return [
      ...List.filled(daysBefore, null),
      ...List.generate(
        daysInMonth,
        (i) => DateTime(_displayedMonth.year, _displayedMonth.month, i + 1),
      ),
    ];
  }

  static const _weekdayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  static const _monthNames = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık',
  ];

  @override
  Widget build(BuildContext context) {
    final pickerTheme = Theme.of(
      context,
    ).extension<CompactDialogDateRangePickerTheme>()!;
    final days = _daysInMonth();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 340,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: pickerTheme.dialogBackground),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              (_rangeStart == null)
                  ? 'Tarih Aralığı Seçin'
                  : (_rangeEnd == null)
                  ? '${_rangeStart!.day}/${_rangeStart!.month}/${_rangeStart!.year} — ...'
                  : '${_rangeStart!.day}/${_rangeStart!.month} — ${_rangeEnd!.day}/${_rangeEnd!.month}/${_rangeEnd!.year}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: pickerTheme.headerTextColor,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _changeMonth(-1),
                ),
                Text(
                  '${_monthNames[_displayedMonth.month - 1]} ${_displayedMonth.year}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: pickerTheme.monthLabelColor,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _changeMonth(1),
                ),
              ],
            ),
            Row(
              children: _weekdayLabels
                  .map(
                    (d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: TextStyle(
                            fontSize: 12,
                            color: pickerTheme.weekdayLabelColor,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 4),
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: days.map((day) {
                if (day == null) return const SizedBox();

                final isStart =
                    _rangeStart != null && _isSameDay(day, _rangeStart!);
                final isEnd = _rangeEnd != null && _isSameDay(day, _rangeEnd!);
                final isInRange = _inRange(day);
                final isDisabled =
                    day.isBefore(widget.firstDate) ||
                    day.isAfter(widget.lastDate);

                return Padding(
                  padding: const EdgeInsets.all(2),
                  child: Material(
                    color: (isStart || isEnd)
                        ? pickerTheme.selectedDayBackground
                        : isInRange
                        ? pickerTheme.inRangeBackground
                        : Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: isDisabled ? null : () => _onDayTap(day),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color: isDisabled
                                ? pickerTheme.disabledDayTextColor
                                : (isStart || isEnd)
                                ? pickerTheme.selectedDayTextColor
                                : pickerTheme.dayTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('İptal Et'),
                ),
                TextButton(
                  onPressed: (_rangeStart != null && _rangeEnd != null)
                      ? () => Navigator.pop(
                          context,
                          DateTimeRange(start: _rangeStart!, end: _rangeEnd!),
                        )
                      : null,
                  child: const Text('Onayla'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
