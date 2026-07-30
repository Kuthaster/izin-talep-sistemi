import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/admin_appbar_provider.dart';
import 'package:izin_talep_sistemi/screens/profile_drawer.dart';
import 'package:izin_talep_sistemi/widgets/admin_app_bar.dart';
import 'package:izin_talep_sistemi/widgets/admin_sidebar.dart';
import 'package:izin_talep_sistemi/widgets/sections/approvals_section.dart';
import 'package:izin_talep_sistemi/widgets/sections/approver_chain_section.dart';
import 'package:izin_talep_sistemi/widgets/sections/departments_section.dart';
import 'package:izin_talep_sistemi/widgets/sections/leave_types_section.dart';
import 'package:izin_talep_sistemi/widgets/sections/roles_section.dart';
import 'package:izin_talep_sistemi/widgets/sections/users_section.dart';

enum AdminSection {
  approvals,
  users,
  departments,
  leaveTypes,
  approverChain,
  roles,
}

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => AdminScreenState();
}

class AdminScreenState extends ConsumerState<AdminScreen> {
  AdminSection _currentSection = AdminSection.approvals;

  void _selectSection(AdminSection section) {
    setState(() => _currentSection = section);
  }

  Widget _buildContent() {
    switch (_currentSection) {
      case AdminSection.approvals:
        return const ApprovalsSection();
      case AdminSection.users:
        return const UsersSection();
      case AdminSection.departments:
        return const DepartmentsSection();
      case AdminSection.leaveTypes:
        return const LeaveTypesSection();
      case AdminSection.approverChain:
        return const ApproverChainSection();
      case AdminSection.roles:
        return const RolesSection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBarState = ref.watch(adminAppBarProvider);

    return Scaffold(
      appBar: AdminAppBar(
        title: appBarState.title,
        primaryActionLabel: appBarState.primaryActionLabel,
        onPrimaryAction: appBarState.onPrimaryAction,
        additionalActions: appBarState.additionalActions,
        onSearchChanged: appBarState.onSearchChanged,
      ),
      drawer: Drawer(
        child: AdminSidebar(
          currentSection: _currentSection,
          onSectionSelected: _selectSection,
        ),
      ),
      endDrawer: ProfileDrawer(),
      body: Stack(
        children: [
          Column(children: [Expanded(child: (_buildContent()))]),
          Positioned(
            left: 0,
            top: ((MediaQuery.sizeOf(context).height - 80) / 2),
            child: Builder(
              builder: (context) => GestureDetector(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Container(
                  width: 25,
                  height: 40,

                  child: Icon(
                    Icons.arrow_right_outlined,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
