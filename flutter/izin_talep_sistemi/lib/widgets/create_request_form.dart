import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/leave_balance_provider.dart';
import 'package:izin_talep_sistemi/providers/leave_request_service_provider.dart';
import 'package:izin_talep_sistemi/widgets/compact_dialog_date_range_picker.dart';

import '../models/leave_request.dart';
import '../models/leave_request_create.dart';
import '../providers/leave_type_provider.dart';
import '../providers/leave_request_provider.dart';

class CreateRequestForm extends ConsumerStatefulWidget {
  final LeaveRequest? existingRequest;

  const CreateRequestForm({super.key, this.existingRequest});

  @override
  ConsumerState<CreateRequestForm> createState() => _CreateRequestFormState();
}

class _CreateRequestFormState extends ConsumerState<CreateRequestForm> {
  late final TextEditingController _reasonController;
  int? _selectedLeaveTypeId;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isSubmitting = false;
  String? _errorMessage;
  int? get _availableForSelectedType {
    if (_selectedLeaveTypeId == null) return null;
    final balances = ref.read(leaveBalancesProvider).value;
    if (balances == null) return null;
    final leaveTypeName = ref
        .read(leaveTypesProvider)
        .value
        ?.firstWhere(
          (t) => t.id == _selectedLeaveTypeId,
          orElse: () => throw StateError('not found'),
        )
        .name;
    final match = balances.where((b) => b.leaveTypeName == leaveTypeName);
    return match.isEmpty ? null : match.first.availableDays;
  }

  int? get _requestedDayCount {
    if (_startDate == null || _endDate == null) return null;
    return _endDate!.difference(_startDate!).inDays + 1;
  }

  bool get _isEditing => widget.existingRequest != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingRequest;
    _reasonController = TextEditingController();
    _startDate = existing?.startDate;
    _endDate = existing?.endDate;
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    /* final picked = await showDateRangePicker(
      context: Navigator.of(context, rootNavigator: true).context,
      helpText: "Tarih Aralığı Seçin",
      cancelText: "İptal Et",
      confirmText: "Onayla",
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: (_startDate != null && _endDate != null)
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            datePickerTheme: Theme.of(ctx).datePickerTheme.copyWith(),
            colorScheme: Theme.of(ctx).colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;
    setState(() {
      _startDate = picked.start;
      _endDate = picked.end;
    }); */

    final picked = await showDialog<DateTimeRange>(
      context: context,
      builder: (context) => CompactDialogDateRangePicker(
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        initialDateRange: (_startDate != null && _endDate != null)
            ? DateTimeRange(start: _startDate!, end: _endDate!)
            : null,
      ),
    );
    if (picked == null) return;
    setState(() {
      _startDate = picked.start;
      _endDate = picked.end;
    });
  }

  Future<void> _submit() async {
    if (_selectedLeaveTypeId == null ||
        _startDate == null ||
        _endDate == null) {
      setState(() => _errorMessage = 'Lütfen tüm alanları doldurun.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final dto = LeaveRequestCreate(
        leaveTypeId: _selectedLeaveTypeId!,
        startDate: _startDate!,
        endDate: _endDate!,
        reason: _reasonController.text.isEmpty ? null : _reasonController.text,
      );

      final leaveRequestService = ref.read(leaveRequestServiceProvider);
      if (_isEditing) {
        await leaveRequestService.updateLeaveRequest(
          widget.existingRequest!.id,
          dto,
        );
      } else {
        await leaveRequestService.createLeaveRequest(dto);
      }
      ref.invalidate(leaveRequestsProvider);
      ref.invalidate(leaveBalancesProvider);

      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(
        () => _errorMessage =
            '${_isEditing ? "Güncellenemedi" : "Oluşturulamadı"}: $e',
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncLeaveTypes = ref.watch(leaveTypesProvider);

    return Material(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _isEditing ? 'Talebi Düzenle' : 'Yeni İzin Talebi',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            const SizedBox(height: 16),

            asyncLeaveTypes.when(
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('İzin türleri yüklenemedi: $err'),
              data: (leaveTypes) {
                if (_isEditing && _selectedLeaveTypeId == null) {
                  final match = leaveTypes.where(
                    (t) => t.name == widget.existingRequest!.leaveTypeName,
                  );
                  if (match.isNotEmpty) _selectedLeaveTypeId = match.first.id;
                }
                return DropdownButtonFormField<int>(
                  initialValue: _selectedLeaveTypeId,
                  decoration: const InputDecoration(labelText: 'İzin Türü'),
                  items: leaveTypes
                      .map(
                        (type) => DropdownMenuItem(
                          value: type.id,
                          child: Text(type.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _selectedLeaveTypeId = value),
                );
              },
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              style: ButtonStyle(),
              onPressed: _pickDateRange,
              icon: const Icon(Icons.date_range, size: 18),
              label: Text(
                (_startDate == null || _endDate == null)
                    ? 'Tarih Aralığı Seç'
                    : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year} — '
                          '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
              ),
            ),
            if (_requestedDayCount != null &&
                _availableForSelectedType != null &&
                _requestedDayCount! > _availableForSelectedType!) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                child: Text(
                  'Bu izin türünde $_availableForSelectedType gün kullanılabilir, '
                  '$_requestedDayCount gün talep ediyorsunuz.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onError,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),

            TextField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Neden (opsiyonel)',
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                isCollapsed: true,
              ),
              maxLines: 2,
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        _isEditing ? 'Değişiklikleri Kaydet' : 'Talebi Gönder',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onInverseSurface,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
