import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/admin_appbar_provider.dart';
import 'package:izin_talep_sistemi/widgets/profile_drawer.dart';
import 'package:izin_talep_sistemi/widgets/admin_app_bar.dart';
import 'package:izin_talep_sistemi/widgets/admin_sidebar.dart';
import 'package:izin_talep_sistemi/widgets/sections/admin_approvals_section.dart';
import 'package:izin_talep_sistemi/widgets/sections/admin_balance_audits_section.dart';
import 'package:izin_talep_sistemi/widgets/sections/admin_balances_section.dart';
import 'package:izin_talep_sistemi/widgets/sections/admin_departments_section.dart';
import 'package:izin_talep_sistemi/widgets/sections/admin_leave_types_section.dart';
import 'package:izin_talep_sistemi/widgets/sections/admin_roles_section.dart';
import 'package:izin_talep_sistemi/widgets/sections/admin_users_section.dart';

enum AdminSection {
  adminApprovals,
  adminUsers,
  adminDepartments,
  adminLeaveTypes,
  adminRoles,
  adminBalances,
  adminBalanceAudits,
}

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => AdminScreenState();
}

class AdminScreenState extends ConsumerState<AdminScreen> {
  AdminSection _currentSection = AdminSection.adminApprovals;

  void _selectSection(AdminSection section) {
    setState(() => _currentSection = section);
  }

  Widget _buildContent() {
    switch (_currentSection) {
      case AdminSection.adminApprovals:
        return const AdminApprovalsSection();
      case AdminSection.adminUsers:
        return const AdminUsersSection();
      case AdminSection.adminDepartments:
        return const AdminDepartmentsSection();
      case AdminSection.adminLeaveTypes:
        return const AdminLeaveTypesSection();
      case AdminSection.adminRoles:
        return const AdminRolesSection();
      case AdminSection.adminBalances:
        return const AdminBalanceSection();
      case AdminSection.adminBalanceAudits:
        return const AdminBalanceAuditsSection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBarState = ref.watch(adminAppBarProvider);

    return Scaffold(
      endDrawer: ProfileDrawer(),
      body: Row(
        children: [
          AdminSidebar(
            currentSection: _currentSection,
            onSectionSelected: _selectSection,
          ),
          Expanded(
            child: Column(
              children: [
                AdminAppBar(
                  title: appBarState.title,
                  primaryActionLabel: appBarState.primaryActionLabel,
                  onPrimaryAction: appBarState.onPrimaryAction,
                  additionalActions: appBarState.additionalActions,
                  onSearchChanged: appBarState.onSearchChanged,
                  hasSearch: appBarState.hasSearch,
                ),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
