import 'package:flutter/material.dart';
import 'package:izin_talep_sistemi/widgets/admin_sidebar.dart';
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

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> {
  AdminSection _currentSection = AdminSection.approvals;

  void _selectSection(AdminSection section) {
    setState(() => _currentSection = section);
  }

  Widget _buildContent() {
    switch (_currentSection) {
      case AdminSection.approvals:
        return const DepartmentsSection(); //const ApprovalsSection();
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
    return Scaffold(
      body: Row(
        children: [
          AdminSidebar(
            currentSection: _currentSection,
            onSectionSelected: _selectSection,
          ),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }
}
