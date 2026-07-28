import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/models/department.dart';
import 'package:izin_talep_sistemi/models/role.dart';
import 'package:izin_talep_sistemi/models/role_authority.dart';
import 'package:izin_talep_sistemi/models/user_create.dart';
import 'package:izin_talep_sistemi/models/user_response.dart';
import 'package:izin_talep_sistemi/models/user_update.dart';
import 'package:izin_talep_sistemi/providers/admin_departments_provider.dart';
import 'package:izin_talep_sistemi/providers/admin_user_provider.dart';
import 'package:izin_talep_sistemi/providers/department_provider.dart';
import 'package:izin_talep_sistemi/providers/role_provider.dart';
import 'package:izin_talep_sistemi/services/user_service.dart';
import 'package:izin_talep_sistemi/widgets/admin_app_bar.dart';
import 'package:izin_talep_sistemi/widgets/admin_data_table.dart';
import 'package:izin_talep_sistemi/widgets/admin_status_chip.dart';

class UsersSection extends ConsumerWidget {
  const UsersSection({super.key});

  Future<void> _createUser(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Role>> rolesAsync,
    AsyncValue<List<Department>> departmentsAsync,
  ) async {
    try {
      final userCreate = await showDialog<UserCreate>(
        context: context,
        builder: (dialogContext) {
          final firstNameController = TextEditingController();
          final lastNameController = TextEditingController();
          final emailController = TextEditingController();
          final rawPasswordController = TextEditingController();
          int? selectedDepartmentId;
          int? selectedRoleId;
          bool obscurePassword = true;

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Kullanıcı oluştur.'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: firstNameController,
                      decoration: const InputDecoration(labelText: 'Ad'),
                    ),
                    TextField(
                      controller: lastNameController,
                      decoration: const InputDecoration(labelText: 'Soyad'),
                    ),
                    TextField(
                      controller: lastNameController,
                      decoration: const InputDecoration(labelText: 'Soyad'),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'e-posta'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextField(
                      controller: rawPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Şifre',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: obscurePassword
                              ? Icon(Icons.visibility_off_sharp)
                              : Icon(Icons.visibility_sharp),
                          tooltip: 'Şifre görünürlüğünü aç/kapa',
                        ),
                      ),
                      obscureText: obscurePassword,
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      title: Text(
                        selectedRoleId == null
                            ? 'Rol seç'
                            : (rolesAsync.value ?? [])
                                  .firstWhere((r) => r.id == selectedRoleId)
                                  .displayName,
                      ),
                      trailing: const Icon(Icons.arrow_drop_down),
                      onTap: () async {
                        final id = await _pickRole(
                          context,
                          rolesAsync.value ?? [],
                        );
                        if (id != null) setState(() => selectedRoleId = id);
                      },
                    ),
                    ListTile(
                      title: Text(
                        selectedDepartmentId == null
                            ? 'Departman seç'
                            : (departmentsAsync.value ?? [])
                                  .firstWhere(
                                    (d) => d.id == selectedDepartmentId,
                                  )
                                  .name,
                      ),
                      trailing: const Icon(Icons.arrow_drop_down),
                      onTap: () async {
                        final id = await _pickDepartment(
                          context,
                          departmentsAsync.value ?? [],
                        );
                        if (id != null) {
                          setState(() => selectedDepartmentId = id);
                        }
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      final firstName = firstNameController.text.trim();
                      final lastName = lastNameController.text.trim();
                      final email = emailController.text.trim();
                      final rawPassword = rawPasswordController.text.trim();
                      if (firstName.isEmpty ||
                          lastName.isEmpty ||
                          email.isEmpty ||
                          rawPassword.isEmpty ||
                          selectedDepartmentId == null ||
                          selectedRoleId == null) {
                        return;
                      }

                      Navigator.pop(
                        dialogContext,
                        UserCreate(
                          firstName: firstName,
                          lastName: lastName,
                          email: email,
                          rawPassword: rawPassword,
                          departmentId: selectedDepartmentId!,
                          roleId: selectedRoleId!,
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

      if (userCreate == null) return;

      await UserService().createUser(userCreate);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Oluşturulamadı: $e')));
      }
    }
  }

  Future<void> _editUser(
    BuildContext context,
    WidgetRef ref,
    UserResponse user,
    AsyncValue<List<Role>> rolesAsync,
    AsyncValue<List<Department>> departmentsAsync,
  ) async {
    final firstNameController = TextEditingController(text: user.firstName);
    final lastNameController = TextEditingController(text: user.lastName);
    final emailController = TextEditingController(text: user.email);
    int? selectedDepartmentId;
    int? selectedRoleId;
    bool active = user.active;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Kullanıcıyı Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'Ad'),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Soyad'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'E-Posta'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),

              ListTile(
                title: Text(
                  selectedRoleId == null
                      ? 'Rol seç'
                      : (rolesAsync.value ?? [])
                            .firstWhere((r) => r.id == selectedRoleId)
                            .displayName,
                ),
                trailing: const Icon(Icons.arrow_drop_down),
                onTap: () async {
                  final id = await _pickRole(context, rolesAsync.value ?? []);
                  if (id != null) setState(() => selectedRoleId = id);
                },
              ),
              ListTile(
                title: Text(
                  selectedDepartmentId == null
                      ? 'Departman seç'
                      : (departmentsAsync.value ?? [])
                            .firstWhere((d) => d.id == selectedDepartmentId)
                            .name,
                ),
                trailing: const Icon(Icons.arrow_drop_down),
                onTap: () async {
                  final id = await _pickDepartment(
                    context,
                    departmentsAsync.value ?? [],
                  );
                  if (id != null) setState(() => selectedDepartmentId = id);
                },
              ),
              SwitchListTile(
                title: Text(active ? 'Aktif' : 'Pasif'),
                value: active,
                onChanged: (value) => setState(() => active = value),
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
      await UserService().updateUser(
        user.id,
        UserUpdate(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          email: emailController.text,
          departmentId: selectedDepartmentId,
          roleId: selectedRoleId,
          active: active,
        ),
      );

      ref.invalidate(rolesProvider);
      ref.invalidate(departmentsProvider);
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
    final asyncUsers = ref.watch(adminUsersProvider);
    final rolesAsync = ref.watch(rolesProvider);
    final departmentsAsync = ref.watch(adminDepartmentsProvider);
    return Column(
      children: [
        AdminAppBar(
          title: 'Kullanıcılar',
          primaryActionLabel: 'Yeni Kullanıcı',
          onPrimaryAction: () =>
              _createUser(context, ref, rolesAsync, departmentsAsync),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: asyncUsers.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Hata: $err')),
              data: (users) => AdminDataTable<UserResponse>(
                items: users,
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Ad')),
                  DataColumn(label: Text('Soyad')),
                  DataColumn(label: Text('E-Posta')),
                  DataColumn(label: Text('Departman')),
                  DataColumn(label: Text('Rol')),
                  DataColumn(label: Text('Yetki')),
                  DataColumn(label: Text('Durum')),
                  DataColumn(label: Text('')),
                ],
                buildRows: (items) => items.map((user) {
                  return DataRow(
                    cells: [
                      DataCell(Text(user.id.toString())),
                      DataCell(Text(user.firstName)),
                      DataCell(Text(user.lastName)),
                      DataCell(Text(user.email)),
                      DataCell(Text(user.departmentName.toString())),
                      DataCell(Text(user.roleDisplayName.toString())),
                      DataCell(
                        Text(authorityLabel(user.roleAuthority).toString()),
                      ),
                      DataCell(
                        Material(
                          color: Colors.transparent,
                          child: AdminStatusChip(
                            status: user.active
                                ? StatusType.active
                                : StatusType.inactive,
                            label: user.active ? 'Aktif' : 'Pasif',
                          ),
                        ),
                      ),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          onPressed: () => _editUser(
                            context,
                            ref,
                            user,
                            rolesAsync,
                            departmentsAsync,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
                emptyStateTitle: 'Hiç Bir Kullanıcı Bulunamadı????',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<int?> _pickRole(BuildContext context, List<Role> roles) {
  return showDialog<int>(
    context: context,
    builder: (context) => SimpleDialog(
      title: const Text('Rol seç'),
      children: [
        SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: roles.length,
            itemBuilder: (context, index) {
              final role = roles[index];
              return SimpleDialogOption(
                onPressed: () => Navigator.pop(context, role.id),
                child: Text(
                  '${role.displayName} (${authorityLabel(role.name)})',
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

Future<int?> _pickDepartment(
  BuildContext context,
  List<Department> departments,
) {
  return showDialog<int>(
    context: context,
    builder: (context) => SimpleDialog(
      title: const Text('Departman seç'),
      children: [
        SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: departments.length,
            itemBuilder: (context, index) {
              final department = departments[index];
              return SimpleDialogOption(
                onPressed: () => Navigator.pop(context, department.id),
                child: Text(department.name),
              );
            },
          ),
        ),
      ],
    ),
  );
}
