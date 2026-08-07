import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:izin_talep_sistemi/models/leave_request_filter.dart';
import 'package:izin_talep_sistemi/providers/leave_type_provider.dart';

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

  static const _statusOptions = [
    'PENDING',
    'APPROVED',
    'REJECTED',
    'CANCELLED',
    'EXPIRED',
  ];
  static const _statusLabels = {
    'PENDING': 'Bekliyor',
    'APPROVED': 'Onaylandı',
    'REJECTED': 'Reddedildi',
    'CANCELLED': 'İptal Edildi',
    'EXPIRED': 'Süresi Doldu',
  };

  Color _statusBg(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange.shade100;
      case 'APPROVED':
        return Colors.green.shade100;
      case 'REJECTED':
        return Colors.red.shade100;
      case 'CANCELLED':
        return Colors.grey.shade400;
      case 'EXPIRED':
        return Colors.blueGrey;
      default:
        return Colors.black;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'PENDING':
        return Colors.orange;
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      case 'CANCELLED':
        return Colors.grey.shade900;
      case 'EXPIRED':
        return Colors.white;
      default:
        return Colors.black;
    }
  }

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
      textStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),

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
                  const Text(
                    'Filtrele',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: () =>
                        setState(() => _draft = const LeaveRequestFilter()),
                    child: const Text('Temizle'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Durum',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: _statusOptions.map((s) {
                  final selected = _draft.status == s;
                  return ChoiceChip(
                    labelStyle: TextStyle(color: _statusColor(s)),
                    selectedColor: Theme.of(
                      context,
                    ).colorScheme.primaryFixedDim,
                    backgroundColor: _statusBg(s),
                    label: Text(_statusLabels[s]!),
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
              const Text(
                'İzin Türü',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
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
                error: (_, __) => const Text(
                  'İzin türleri yüklenemedi',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
                data: (leaveTypes) => Wrap(
                  spacing: 8,
                  children: leaveTypes.map((lt) {
                    final selected = _draft.leaveTypeId == lt.id;
                    return ChoiceChip(
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onInverseSurface,
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
              const Text(
                'Başlangıç Tarihi Aralığı',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
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
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  onPressed: () {
                    ref.read(widget.targetProvider.notifier).state = _draft;
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Uygula',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                    ),
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
