import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/department_approver_assign.dart';
import 'package:izin_talep_sistemi/providers/admin_departments_provider.dart';
import 'package:izin_talep_sistemi/providers/admin_user_provider.dart';
import 'package:izin_talep_sistemi/providers/department_approver_provider.dart';
import 'package:izin_talep_sistemi/providers/department_approver_service_provider.dart';
import 'package:izin_talep_sistemi/providers/department_provider.dart';
import 'package:izin_talep_sistemi/services/department_approver_service.dart';
import 'package:izin_talep_sistemi/widgets/admin_app_bar.dart';

class ApproverChainSection extends ConsumerStatefulWidget {
  const ApproverChainSection({super.key});

  @override
  ConsumerState<ApproverChainSection> createState() =>
      _ApproverChainSectionState();
}

class _ApproverChainSectionState extends ConsumerState<ApproverChainSection> {
  int? _selectedDepartmentId;
  DepartmentApproverService get _departmentApproverService =>
      ref.read(departmentApproverServiceProvider);
  Future<void> _assignApprover(int departmentId, int level) async {
    final departments = ref.watch(departmentsProvider).value ?? [];
    final matchingDepartment = departments.firstWhere(
      (dept) => dept.id == departmentId,
    );
    final departmentName = matchingDepartment.name;

    final asyncUsers = ref.read(adminUsersProvider);
    final users = (asyncUsers.value ?? [])
        .where((user) => user.departmentName == departmentName)
        .toList();

    final selectedUserId = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Seviye $level Onaylayıcısı Seç'),
        children: users.map((user) {
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(context, user.id),
            child: Text('${user.firstName} ${user.lastName}'),
          );
        }).toList(),
      ),
    );

    if (selectedUserId == null) return;

    try {
      await _departmentApproverService.assignApprover(
        DepartmentApproverAssign(
          departmentId: departmentId,
          level: level,
          approverId: selectedUserId,
        ),
      );
      ref.invalidate(departmentApproversProvider(departmentId));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Atanamadı: $e')));
      }
    }
  }

  Future<void> _removeApprover(int departmentId, int level) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Onaylayıcıyı Kaldır'),
        content: Text(
          'Seviye $level onaylayıcısını kaldırmak istediğinize emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Kaldır'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _departmentApproverService.removeApprover(departmentId, level);
      ref.invalidate(departmentApproversProvider(departmentId));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Kaldırılamadı: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncDepartments = ref.watch(adminDepartmentsProvider);

    return Column(
      children: [
        const AdminAppBar(title: 'Onay Zinciri'),
        Expanded(
          child: asyncDepartments.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Hata: $err')),
            data: (departments) {
              return Row(
                children: [
                  SizedBox(
                    width: 220,
                    child: ListView(
                      children: departments.map((department) {
                        return ListTile(
                          title: Text(department.name),
                          selected: department.id == _selectedDepartmentId,
                          onTap: () => setState(
                            () => _selectedDepartmentId = department.id,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: _selectedDepartmentId == null
                        ? const Center(child: Text('Bir departman seçin'))
                        : _buildLevelsPanel(_selectedDepartmentId!),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLevelsPanel(int departmentId) {
    final asyncApprovers = ref.watch(departmentApproversProvider(departmentId));

    return asyncApprovers.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Hata: $err')),
      data: (approvers) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [1, 2, 3].map((level) {
              final approver = approvers
                  .where((a) => a.level == level)
                  .toList();
              final assigned = approver.isNotEmpty ? approver.first : null;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text('Seviye $level'),
                  subtitle: Text(assigned?.approverName ?? 'Atanmamış'),
                  trailing: assigned == null
                      ? TextButton(
                          onPressed: () => _assignApprover(departmentId, level),
                          child: const Text('Ata'),
                        )
                      : IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _removeApprover(departmentId, level),
                        ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
