import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/role.dart';
import 'package:izin_talep_sistemi/models/role_authority.dart';
import 'package:izin_talep_sistemi/models/role_create.dart';
import 'package:izin_talep_sistemi/models/role_update.dart';
import 'package:izin_talep_sistemi/providers/admin_departments_provider.dart';
import 'package:izin_talep_sistemi/providers/role_provider.dart';
import 'package:izin_talep_sistemi/services/role_service.dart';

import 'package:izin_talep_sistemi/widgets/admin_app_bar.dart';
import 'package:izin_talep_sistemi/widgets/admin_data_table.dart';
import 'package:izin_talep_sistemi/widgets/admin_status_chip.dart';

class RolesSection extends ConsumerWidget {
  const RolesSection({super.key});

  Future<void> _createRole(BuildContext context, WidgetRef ref) async {
    try {
      final roleCreate = await showDialog<RoleCreate>(
        context: context,
        builder: (dialogContext) {
          final controller = TextEditingController();
          RoleAuthority? selectedAuthority;

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Rol oluştur.'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        labelText: 'Rol Adını Gir',
                      ),
                    ),
                    const SizedBox(height: 12),
                    SimpleDialog(
                      title: Text('Yetki seç'),
                      children: RoleAuthority.values.map((authority) {
                        return SimpleDialogOption(
                          child: Text(authority.name),
                          onPressed: () {
                            selectedAuthority = authority;
                            setState(() {});
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      final displayName = controller.text.trim();
                      if (displayName.isEmpty || selectedAuthority == null) {
                        return;
                      }

                      Navigator.pop(
                        dialogContext,
                        RoleCreate(
                          displayName: displayName,
                          name: selectedAuthority!,
                        ),
                      );
                    },
                    child: const Text('Kaydet'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (roleCreate == null) return;

      await RoleService().createRole(roleCreate);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Oluşturulamadı: $e')));
      }
    }
  }

  Future<void> _editRole(BuildContext context, WidgetRef ref, Role role) async {
    final displayNameController = TextEditingController(
      text: role.displayName.toString(),
    );
    bool active = role.active;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('${role.name} Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: displayNameController,
                decoration: const InputDecoration(labelText: 'Rol Adı'),
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
      await RoleService().updateRole(
        role.id,
        RoleUpdate(displayName: displayNameController.text, active: active),
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

  Future<void> _activation(
    BuildContext context,
    WidgetRef ref,
    Role role,
  ) async {
    bool active = !role.active;
    try {
      await RoleService().updateRole(
        role.id,
        RoleUpdate(displayName: null, active: active),
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
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRoles = ref.watch(rolesProvider);

    return Column(
      children: [
        AdminAppBar(
          title: 'Roller',
          primaryActionLabel: 'Yeni Rol',
          onPrimaryAction: () => _createRole(context, ref),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: asyncRoles.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Hata: $err')),
              data: (roles) => AdminDataTable<Role>(
                items: roles,
                columns: const [
                  DataColumn(label: Text('Ad')),
                  DataColumn(label: Text('Yetki')),
                  DataColumn(label: Text('Durum')),
                  DataColumn(label: Text('')),
                ],
                buildRows: (items) => items.map((role) {
                  return DataRow(
                    cells: [
                      DataCell(Text(role.displayName)),
                      DataCell(Text(role.name.toString())),
                      DataCell(
                        Material(
                          color: Colors.transparent,
                          child: AdminStatusChip(
                            status: role.active
                                ? StatusType.active
                                : StatusType.inactive,
                            label: role.active ? 'Aktif' : 'Pasif',
                            onTap: () => _activation(context, ref, role),
                          ),
                        ),
                      ),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          onPressed: () => _editRole(context, ref, role),
                        ),
                      ),
                    ],
                  );
                }).toList(),
                emptyStateTitle: 'Roller boş, bu ekranı nasıl görüyorsun?',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
