import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/auth_provider.dart';
import 'package:izin_talep_sistemi/screens/admin_shell_screen.dart';

class AdminSidebar extends ConsumerWidget {
  final AdminSection currentSection;
  final Function(AdminSection) onSectionSelected;

  const AdminSidebar({super.key, required this.currentSection,required this.onSectionSelected,});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Container(
      width: 250,
      color: const Color.fromARGB(255, 5, 57, 110),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            child: const Text(
              'ADMIN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                _buildNavItem(
                  context,
                  label: 'İzinler',
                  section: AdminSection.approvals,
                  icon: Icons.check_circle_outline,
                ),
                _buildNavItem(
                  context,
                  label: 'Kullanıcılar',
                  section: AdminSection.users,
                  icon: Icons.people_outline,
                ),
                _buildNavItem(
                  context,
                  label: 'Departmanlar',
                  section: AdminSection.departments,
                  icon: Icons.business_outlined,
                ),
                _buildNavItem(
                  context,
                  label: 'İzin Türleri',
                  section: AdminSection.leaveTypes,
                  icon: Icons.calendar_today_outlined,
                ),
                _buildNavItem(
                  context,
                  label: 'Onaylayıcı Zinciri',
                  section: AdminSection.approverChain,
                  icon: Icons.account_tree_outlined,
                ),
              ],
            ),
          ),
          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
              top: BorderSide(color: Color(0xFF34495E)),
            )),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: const Icon(Icons.logout, color: Colors.white70),
                label: const Text(
                  'Çıkış Yap',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required String label,
    required AdminSection section,
    required IconData icon,
  }) {
    final isActive = currentSection == section;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF3498DB) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white70,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () => onSectionSelected(section),
        hoverColor: Colors.transparent,
      ),
    );
  }
}
