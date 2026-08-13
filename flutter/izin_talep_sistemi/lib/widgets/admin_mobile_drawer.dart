import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/screens/admin_shell_screen.dart';
import 'package:izin_talep_sistemi/theme/theme_extensions.dart';
import 'package:izin_talep_sistemi/ultilities/logout.dart';

class AdminMobileDrawer extends ConsumerWidget {
  final AdminSection currentSection;
  final ValueChanged<AdminSection> onSectionSelected;

  const AdminMobileDrawer({
    super.key,
    required this.currentSection,
    required this.onSectionSelected,
  });

  static const List<(AdminSection, String, IconData)> _items = [
    (AdminSection.adminApprovals, 'İzinler', Icons.check_circle_outline),
    (AdminSection.adminUsers, 'Kullanıcılar', Icons.people_outline),
    (AdminSection.adminDepartments, 'Departmanlar', Icons.business_outlined),
    (
      AdminSection.adminLeaveTypes,
      'İzin Türleri',
      Icons.calendar_today_outlined,
    ),
    (AdminSection.adminRoles, 'Roller', Icons.person),
    (AdminSection.adminBalances, 'Bakiyeler', Icons.pie_chart_outline),
    (
      AdminSection.adminBalanceAudits,
      'Denetim Kayıtları',
      Icons.receipt_long_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = context.colors;

    return Drawer(
      backgroundColor: scheme.primary,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'ADMIN',
                style: TextStyle(
                  color: scheme.onInverseSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: _items.map((item) {
                  final section = item.$1;
                  final label = item.$2;
                  final icon = item.$3;
                  final isActive = currentSection == section;
                  return ListTile(
                    leading: Icon(
                      icon,
                      color: isActive
                          ? scheme.onPrimaryFixedVariant
                          : scheme.onInverseSurface,
                    ),
                    title: Text(
                      label,
                      style: TextStyle(
                        color: isActive
                            ? scheme.onInverseSurface
                            : scheme.onPrimary,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    selected: isActive,
                    selectedTileColor: scheme.tertiary,
                    onTap: () => onSectionSelected(section),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => logout(context, ref),
                  icon: const Icon(Icons.logout),
                  label: const Text('Çıkış Yap'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
