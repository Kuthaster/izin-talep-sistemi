import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/role.dart';
import 'package:izin_talep_sistemi/models/role_authority.dart';
import 'package:izin_talep_sistemi/models/role_create.dart';
import 'package:izin_talep_sistemi/models/role_update.dart';
import 'package:izin_talep_sistemi/providers/admin_appbar_provider.dart';
import 'package:izin_talep_sistemi/providers/role_provider.dart';
import 'package:izin_talep_sistemi/providers/role_service_provider.dart';
import 'package:izin_talep_sistemi/services/role_service.dart';

import 'package:izin_talep_sistemi/widgets/admin_data_table.dart';
import 'package:izin_talep_sistemi/widgets/admin_status_chip.dart';

class RolesSection extends ConsumerStatefulWidget {
  const RolesSection({super.key});

  @override
  ConsumerState<RolesSection> createState() => _RolesSectionState();
}

class _RolesSectionState extends ConsumerState<RolesSection> {
  RoleService get _roleService => ref.read(roleServiceProvider);

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
                          child: Text(authorityLabel(authority)),
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

      await _roleService.createRole(roleCreate);
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
      await _roleService.updateRole(
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

  Future<void> _delete(BuildContext context, WidgetRef ref, Role role) async {
    final id = role.id;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Rolü Silme Onayı"),
          content: Text(
            "ID: ${role.id} • Rol Adı: ${role.displayName}/n"
            "Yetki: ${authorityLabel(role.name)}/n"
            "İzin Türünü Silmek İstediğinizden Emin misiniz?",
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
              child: const Text('İZİN TÜRÜNÜ SİL'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    try {
      await _roleService.deleteRole(id);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('İşlem başarısız: $e')));
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
      await _roleService.updateRole(
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
  Widget build(BuildContext context) {
    final asyncRoles = ref.watch(rolesProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(adminAppBarProvider.notifier)
          .updateAppBar(
            title: 'Roller',
            primaryActionLabel: 'Yeni Rol Oluştur',
            onPrimaryAction: () => _createRole(context, ref),
            hasSearch: true,
          );
    });

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: asyncRoles.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Hata: $err')),
              data: (roles) => AdminDataTable<Role>(
                dataSpacing: 290,
                items: roles,
                searchLabel: (role, query) => role.displayName
                    .toLowerCase()
                    .contains(query.toLowerCase()),
                columnLabels: const ['Ad', 'Yetki', 'Durum', ''],
                sortComparators: [
                  (a, b) => a.displayName.compareTo(b.displayName),
                  (a, b) => a.name.toString().compareTo(b.name.toString()),
                ],

                buildCells: (role) => [
                  DataCell(Text(role.displayName)),
                  DataCell(Text(authorityLabel(role.name))),
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
                emptyStateTitle: 'Roller boş, bu ekranı nasıl görüyorsun?',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
