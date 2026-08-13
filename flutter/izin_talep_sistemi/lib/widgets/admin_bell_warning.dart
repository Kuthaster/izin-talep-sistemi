import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/approver_gap_provider.dart';
import 'package:izin_talep_sistemi/providers/departmentless_users_provider.dart';
import 'package:izin_talep_sistemi/providers/password_reset_requests.provider.dart';
import 'package:izin_talep_sistemi/providers/user_service.provider.dart';
import 'package:izin_talep_sistemi/theme/theme_extensions.dart';

class AdminBellWarning extends ConsumerWidget {
  const AdminBellWarning({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncGaps = ref.watch(approverGapsProvider);
    final asyncDepartmentless = ref.watch(departmentlessUsersProvider);
    final asyncResets = ref.watch(passwordResetRequestsProvider);

    final gaps = asyncGaps.value ?? [];
    final departmentless = asyncDepartmentless.value ?? [];
    final resets = asyncResets.value ?? [];
    final count = gaps.length + departmentless.length + resets.length;

    return PopupMenuButton<void>(
      tooltip: 'Uyarılar',
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(Icons.notifications_outlined, color: context.colors.primary),
          if (count > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  '$count',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      itemBuilder: (context) {
        if (count == 0) {
          return [
            const PopupMenuItem(enabled: false, child: Text('Aktif uyarı yok')),
          ];
        }

        final items = <PopupMenuEntry<void>>[];

        for (final gap in gaps) {
          items.add(
            PopupMenuItem(
              enabled: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${gap.departmentName}: Seviye ${gap.missingLevels.join(", ")} onaylayıcısı atanmamış',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (gaps.isNotEmpty && departmentless.isNotEmpty) {
          items.add(const PopupMenuDivider());
        }

        for (final user in departmentless) {
          items.add(
            PopupMenuItem(
              enabled: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.person_off_outlined,
                      color: Colors.orange,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${user.userName}: Departman atanmamış',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        for (final r in resets) {
          items.add(
            PopupMenuItem(
              onTap: () {
                Future.microtask(() async {
                  final temp = await ref
                      .read(userServiceProvider)
                      .issueTempPassword(r.userId);
                  ref.invalidate(passwordResetRequestsProvider);
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('${r.userName} için geçici şifre'),
                        content: SelectableText(
                          temp,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Kapat'),
                          ),
                        ],
                      ),
                    );
                  }
                });
              },
              child: ListTile(
                leading: const Icon(
                  Icons.lock_reset,
                  color: Colors.orange,
                  size: 18,
                ),
                title: Text('${r.userName}: Şifre sıfırlama talep etti'),
                subtitle: Text(r.email, style: const TextStyle(fontSize: 11)),
              ),
            ),
          );
        }
        return items;
      },
    );
  }
}
