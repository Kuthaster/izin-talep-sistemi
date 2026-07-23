// widgets/sections/departments_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/admin_departments_provider.dart';

import 'package:izin_talep_sistemi/models/department.dart';
import 'package:izin_talep_sistemi/models/department_update.dart';
import 'package:izin_talep_sistemi/services/department_service.dart';
import 'package:izin_talep_sistemi/widgets/admin_app_bar.dart';
import 'package:izin_talep_sistemi/widgets/admin_data_table.dart';

class DepartmentsSection extends ConsumerWidget {
  const DepartmentsSection({super.key});

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
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Vazgeç')),
          TextButton(
            onPressed: () => Navigator.pop(context, nameController.text.trim()),
            child: const Text('Oluştur'),
          ),
        ],
      ),
    );

    if (name == null || name.isEmpty) return;

    try {
      await DepartmentService().createDepartment(Department(id: 0, name: name));
      ref.invalidate(adminDepartmentsProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Oluşturulamadı: $e')));
      }
    }
  }

  Future<void> _editDepartment(BuildContext context, WidgetRef ref, Department department) async {
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
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Vazgeç')),
          TextButton(
            onPressed: () => Navigator.pop(context, nameController.text.trim()),
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );

    if (name == null || name.isEmpty || name == department.name) return;

    try {
      await DepartmentService().updateDepartment(department.id, DepartmentUpdate(departmentName: name));
      ref.invalidate(adminDepartmentsProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Güncellenemedi: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDepartments = ref.watch(adminDepartmentsProvider);

    return Column(
      children: [
        AdminAppBar(
          title: 'Departmanlar',
          primaryActionLabel: 'Yeni Departman',
          onPrimaryAction: () => _createDepartment(context, ref),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: asyncDepartments.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Hata: $err')),
              data: (departments) => AdminDataTable<Department>(
                items: departments,
                columns: const [
                  DataColumn(label: Text('ID',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Ad',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('')),
                ],
                buildRows: (items) => items.map((department) {
                  return DataRow(cells: [
                    DataCell(Text(department.id.toString())),
                    DataCell(Text(department.name, style: TextStyle(fontSize: 15),)),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        onPressed: () => _editDepartment(context, ref, department),
                      ),
                    ),
                  ]);
                }).toList(),
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