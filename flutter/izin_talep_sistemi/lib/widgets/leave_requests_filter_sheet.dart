import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:izin_talep_sistemi/models/leave_request_filter.dart';
import 'package:izin_talep_sistemi/models/status.dart';
import 'package:izin_talep_sistemi/providers/leave_type_provider.dart';
import 'package:izin_talep_sistemi/theme/theme_extensions.dart';

class LeaveRequestFilterSheet extends ConsumerStatefulWidget {
  final LeaveRequestFilter initial;
  final StateProvider<LeaveRequestFilter> targetProvider;

  const LeaveRequestFilterSheet({
    super.key,
    required this.initial,
    required this.targetProvider,
  });

  @override
  ConsumerState<LeaveRequestFilterSheet> createState() =>
      _LeaveRequestFilterSheetState();
}

class _LeaveRequestFilterSheetState
    extends ConsumerState<LeaveRequestFilterSheet> {
  late LeaveRequestFilter _draft;

  @override
  void initState() {
    super.initState();
    _draft = widget.initial;
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          (isFrom ? _draft.startDateFrom : _draft.startDateTo) ??
          DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      _draft = isFrom
          ? _draft.copyWith(startDateFrom: picked)
          : _draft.copyWith(startDateTo: picked);
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncLeaveTypes = ref.watch(leaveTypesProvider);

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      textStyle: TextStyle(color: context.colors.onSurface),

      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Filtrele', style: TextStyle(fontSize: 18)),
                  TextButton(
                    onPressed: () =>
                        setState(() => _draft = const LeaveRequestFilter()),
                    child: const Text('Temizle'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Durum', style: TextStyle()),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: statusOptions.map((s) {
                  final selected = _draft.status == s;
                  return ChoiceChip(
                    labelStyle: TextStyle(
                      color: getStatusTextColor(convertToStatusType(s)),
                    ),
                    selectedColor: Theme.of(
                      context,
                    ).colorScheme.primaryFixedDim,
                    backgroundColor: getStatusBackgroundColor(
                      convertToStatusType(s),
                    ),
                    label: Text(getStatusLabel(convertToStatusType(s))),
                    selected: selected,
                    onSelected: (_) => setState(() {
                      _draft = selected
                          ? _draft.copyWith(clearStatus: true)
                          : _draft.copyWith(status: s);
                    }),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text('İzin Türü', style: TextStyle()),
              const SizedBox(height: 6),
              asyncLeaveTypes.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                error: (_, _) => const Text(
                  'İzin türleri yüklenemedi',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
                data: (leaveTypes) => Wrap(
                  spacing: 8,
                  children: leaveTypes.map((lt) {
                    final selected = _draft.leaveTypeId == lt.id;
                    return ChoiceChip(
                      labelStyle: TextStyle(
                        color: context.colors.onInverseSurface,
                      ),
                      selectedColor: Theme.of(
                        context,
                      ).colorScheme.secondaryFixedDim,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.inverseSurface,
                      label: Text(lt.name),
                      selected: selected,
                      onSelected: (_) => setState(() {
                        _draft = selected
                            ? _draft.copyWith(clearLeaveType: true)
                            : _draft.copyWith(leaveTypeId: lt.id);
                      }),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Başlangıç Tarihi Aralığı', style: TextStyle()),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pickDate(isFrom: true),
                      child: Text(
                        _draft.startDateFrom == null
                            ? 'Başlangıç'
                            : _draft.startDateFrom!
                                  .toIso8601String()
                                  .split('T')
                                  .first,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _pickDate(isFrom: false),
                      child: Text(
                        _draft.startDateTo == null
                            ? 'Bitiş'
                            : _draft.startDateTo!
                                  .toIso8601String()
                                  .split('T')
                                  .first,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      context.colors.tertiary,
                    ),
                  ),
                  onPressed: () {
                    ref.read(widget.targetProvider.notifier).state = _draft;
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Uygula',
                    style: TextStyle(color: context.colors.onInverseSurface),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
