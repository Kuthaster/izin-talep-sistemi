// widgets/sections/departments_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/admin_appbar_provider.dart';
import 'package:izin_talep_sistemi/providers/admin_departments_provider.dart';

import 'package:izin_talep_sistemi/models/department.dart';
import 'package:izin_talep_sistemi/models/department_update.dart';
import 'package:izin_talep_sistemi/providers/department_service_provider.dart';
import 'package:izin_talep_sistemi/services/department_service.dart';
import 'package:izin_talep_sistemi/widgets/admin_data_table.dart';

class DepartmentsSection extends ConsumerStatefulWidget {
  const DepartmentsSection({super.key});

  @override
  ConsumerState<DepartmentsSection> createState() => _DepartmentsSectionState();
}

class _DepartmentsSectionState extends ConsumerState<DepartmentsSection> {
  DepartmentService get _departmentService =>
      ref.read(departmentServiceProvider);

  Future<void> _createDepartment(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController();

    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Departman'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Departman Adı'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, nameController.text.trim()),
            child: const Text('Oluştur'),
          ),
        ],
      ),
    );

    if (name == null || name.isEmpty) return;

    try {
      await _departmentService.createDepartment(
        DepartmentUpdate(departmentName: name),
      );
      ref.invalidate(adminDepartmentsProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Oluşturulamadı: $e')));
      }
    }
  }

  Future<void> _editDepartment(
    BuildContext context,
    WidgetRef ref,
    Department department,
  ) async {
    final nameController = TextEditingController(text: department.name);

    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Departmanı Düzenle'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Departman Adı'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, nameController.text.trim()),
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );

    if (name == null || name.isEmpty || name == department.name) return;

    try {
      await _departmentService.updateDepartment(
        department.id,
        DepartmentUpdate(departmentName: name),
      );
      ref.invalidate(adminDepartmentsProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Güncellenemedi: $e')));
      }
    }
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    Department department,
  ) async {
    final id = department.id;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Departman Silme Onayı"),
          content: Text(
            "ID: ${department.id} • Departman Adı: ${department.name}/n"
            "Departmanı Silmek İstediğinizden Emin misiniz?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('İPTAL ET'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context, true);
              },
              child: const Text('DEPARTMANI SİL'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    try {
      await _departmentService.deleteDepartment(id);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('İşlem başarısız: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncDepartments = ref.watch(adminDepartmentsProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(adminAppBarProvider.notifier)
          .updateAppBar(
            title: 'Roller',
            primaryActionLabel: 'Yeni Rol Oluştur',
            onPrimaryAction: () => _createDepartment(context, ref),
          );
    });

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: asyncDepartments.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Hata: $err')),
              data: (departments) => AdminDataTable<Department>(
                dataSpacing: 500,
                items: departments,
                searchLabel: (department, query) =>
                    department.name.toLowerCase().contains(query.toLowerCase()),
                columnLabels: const ['ID', 'Ad', ''],
                sortComparators: [
                  (a, b) => a.id.compareTo(b.id),
                  (a, b) => a.name.compareTo(b.name),
                  (a, b) => 0,
                ],
                buildCells: (department) => [
                  DataCell(Text(department.id.toString())),
                  DataCell(
                    Text(department.name, style: TextStyle(fontSize: 15)),
                  ),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      onPressed: () =>
                          _editDepartment(context, ref, department),
                    ),
                  ),
                ],
                emptyStateTitle: 'Departman yok',
                emptyStateMessage: 'Henüz hiç departman oluşturulmamış.',
                emptyStateActionLabel: 'Departman Oluştur',
                onEmptyStateAction: () => _createDepartment(context, ref),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
