import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/leave_request_service_provider.dart';

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

  bool get _isEditing => widget.existingRequest != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingRequest;
    _reasonController = TextEditingController();
    _startDate = existing?.startDate;
    _endDate = existing?.endDate;
    // leaveTypeId isn't on LeaveRequest (only leaveTypeName is) — set once the dropdown data loads, see build()
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? DateTime.now()),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
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

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
              // On first build while editing, resolve the leaveTypeId from the request's leaveTypeName
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

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _pickDate(isStart: true),
                  child: Text(
                    _startDate == null
                        ? 'Başlangıç Tarihi'
                        : '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _pickDate(isStart: false),
                  child: Text(
                    _endDate == null
                        ? 'Bitiş Tarihi'
                        : '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _reasonController,
            decoration: const InputDecoration(labelText: 'Neden (opsiyonel)'),
            maxLines: 2,
          ),

          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
          ],

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      _isEditing ? 'Değişiklikleri Kaydet' : 'Talebi Gönder',
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
