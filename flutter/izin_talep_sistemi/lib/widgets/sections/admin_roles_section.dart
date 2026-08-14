import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/role.dart';
import 'package:izin_talep_sistemi/models/role_authority.dart';
import 'package:izin_talep_sistemi/models/role_update.dart';
import 'package:izin_talep_sistemi/providers/admin_appbar_provider.dart';
import 'package:izin_talep_sistemi/providers/role_provider.dart';
import 'package:izin_talep_sistemi/providers/role_service_provider.dart';
import 'package:izin_talep_sistemi/services/role_service.dart';

import 'package:izin_talep_sistemi/widgets/admin_data_table.dart';

class AdminRolesSection extends ConsumerStatefulWidget {
  const AdminRolesSection({super.key});

  @override
  ConsumerState<AdminRolesSection> createState() => _AdminRolesSectionState();
}

class _AdminRolesSectionState extends ConsumerState<AdminRolesSection> {
  RoleService get _roleService => ref.read(roleServiceProvider);

  Future<void> _editRole(BuildContext context, WidgetRef ref, Role role) async {
    final displayNameController = TextEditingController(
      text: role.displayName.toString(),
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            '${authorityLabel(role.name)} Kademesinin Adını Değiştir',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: displayNameController,
                decoration: const InputDecoration(labelText: 'Rol Adı'),
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
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true) return;

    try {
      await _roleService.updateRole(
        role.id,
        RoleUpdate(displayName: displayNameController.text),
      );

      ref.invalidate(rolesProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Güncellenemedi: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncRoles = ref.watch(rolesProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(adminAppBarProvider.notifier)
          .updateAppBar(title: 'Roller', hasSearch: false);
    });

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: asyncRoles.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Hata: $err')),
          data: (roles) => AdminDataTable<Role>(
            dataSpacing: 460,
            items: roles,
            columnLabels: const ['Ad', 'Yetki', ''],
            sortComparators: [
              (a, b) => a.displayName.compareTo(b.displayName),
              (a, b) => a.name.toString().compareTo(b.name.toString()),
            ],
            buildCells: (role) => [
              DataCell(Text(role.displayName)),
              DataCell(Text(authorityLabel(role.name))),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  tooltip: 'Düzenle',
                  onPressed: () => _editRole(context, ref, role),
                ),
              ),
            ],
            emptyStateTitle: 'Burada Hiçbir Şey Yok.',
          ),
        ),
      ),
    );
  }
}
