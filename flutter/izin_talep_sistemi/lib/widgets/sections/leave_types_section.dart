import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/leave_type.dart';
import 'package:izin_talep_sistemi/models/leave_type_create.dart';
import 'package:izin_talep_sistemi/models/leave_type_update.dart';
import 'package:izin_talep_sistemi/providers/admin_leave_type_provider.dart';
import 'package:izin_talep_sistemi/services/leave_type_service.dart';
import 'package:izin_talep_sistemi/widgets/admin_app_bar.dart';
import 'package:izin_talep_sistemi/widgets/admin_data_table.dart';
import 'package:izin_talep_sistemi/widgets/admin_status_chip.dart';

class LeaveTypesSection extends ConsumerWidget {
  const LeaveTypesSection({super.key});

  Future<void> _createLeaveType(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();
    final daysController = TextEditingController();
    final levelsController = TextEditingController(text: '1');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni İzin Türü'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Ad'),
            ),
            TextField(
              controller: daysController,
              decoration: const InputDecoration(
                labelText: 'Varsayılan Gün Sayısı',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: levelsController,
              decoration: const InputDecoration(
                labelText: 'Gerekli Onay Seviyesi (1-3)',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Oluştur'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final days = int.tryParse(daysController.text);
    final levels = int.tryParse(levelsController.text);
    if (nameController.text.trim().isEmpty || days == null) return;

    try {
      await LeaveTypesService().createLeaveType(
        LeaveTypeCreate(
          name: nameController.text.trim(),
          defaultDays: days,
          requiredLevels: levels,
        ),
      );
      ref.invalidate(adminLeaveTypesProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Oluşturulamadı: $e')));
      }
    }
  }

  Future<void> _activation(
    BuildContext context,
    WidgetRef ref,
    LeaveType leaveType,
  ) async {
    bool active = !leaveType.active;
    try {
      await LeaveTypesService().updateLeaveType(
        leaveType.id,
        LeaveTypeUpdate(
          defaultDays: null,
          active: active,
          requiredLevels: null,
        ),
      );
      ref.invalidate(adminLeaveTypesProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Güncellenemedi: $e')));
      }
    }
  }

  Future<void> _editLeaveType(
    BuildContext context,
    WidgetRef ref,
    LeaveType leaveType,
  ) async {
    final daysController = TextEditingController(
      text: leaveType.defaultDays.toString(),
    );
    final levelsController = TextEditingController(
      text: leaveType.requiredLevels.toString(),
    );
    bool active = leaveType.active;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('${leaveType.name} Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: daysController,
                decoration: const InputDecoration(
                  labelText: 'Varsayılan Gün Sayısı',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: levelsController,
                decoration: const InputDecoration(
                  labelText: 'Gerekli Onay Seviyesi (1-3)',
                ),
                keyboardType: TextInputType.number,
              ),
              SwitchListTile(
                title: const Text('Aktif'),
                value: active,
                onChanged: (value) => setDialogState(() => active = value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Vazgeç'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true) return;

    try {
      await LeaveTypesService().updateLeaveType(
        leaveType.id,
        LeaveTypeUpdate(
          defaultDays: int.tryParse(daysController.text),
          active: active,
          requiredLevels: int.tryParse(levelsController.text),
        ),
      );
      ref.invalidate(adminLeaveTypesProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Güncellenemedi: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLeaveTypes = ref.watch(adminLeaveTypesProvider);

    return Column(
      children: [
        AdminAppBar(
          title: 'İzin Türleri',
          primaryActionLabel: 'Yeni İzin Türü',
          onPrimaryAction: () => _createLeaveType(context, ref),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: asyncLeaveTypes.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Hata: $err')),
              data: (leaveTypes) => AdminDataTable<LeaveType>(
                items: leaveTypes,
                columns: const [
                  DataColumn(label: Text('Ad')),
                  DataColumn(label: Text('Varsayılan Gün')),
                  DataColumn(label: Text('Onay Seviyesi')),
                  DataColumn(label: Text('Durum')),
                  DataColumn(label: Text('')),
                ],
                buildRows: (items) => items.map((leaveType) {
                  return DataRow(
                    cells: [
                      DataCell(Text(leaveType.name)),
                      DataCell(Text(leaveType.defaultDays.toString())),
                      DataCell(Text(leaveType.requiredLevels.toString())),
                      DataCell(
                        Material(
                          color: Colors.transparent,
                          child: AdminStatusChip(
                            status: leaveType.active
                                ? StatusType.active
                                : StatusType.inactive,
                            label: leaveType.active ? 'Aktif' : 'Pasif',
                            onTap: () => _activation(context, ref, leaveType),
                          ),
                        ),
                      ),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          onPressed: () =>
                              _editLeaveType(context, ref, leaveType),
                        ),
                      ),
                    ],
                  );
                }).toList(),
                emptyStateTitle: 'İzin türü yok',
                emptyStateActionLabel: 'İzin Türü Oluştur',
                onEmptyStateAction: () => _createLeaveType(context, ref),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
