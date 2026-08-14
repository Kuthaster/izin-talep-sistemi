import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/auth_provider.dart';
import 'package:izin_talep_sistemi/providers/leave_request_provider.dart';
import 'package:izin_talep_sistemi/theme/theme_extensions.dart';
import 'package:izin_talep_sistemi/widgets/app_bottom_nav_bar.dart';
import 'package:izin_talep_sistemi/widgets/create_request_form.dart';
import 'package:izin_talep_sistemi/widgets/leave_requests_filter_sheet.dart';
import 'package:izin_talep_sistemi/widgets/profile_avatar_widget.dart';
import 'package:izin_talep_sistemi/widgets/profile_drawer.dart';
import 'package:izin_talep_sistemi/widgets/sections/main_approvals_section.dart';
import 'package:izin_talep_sistemi/widgets/sections/main_balance_section.dart';
import 'package:izin_talep_sistemi/widgets/sections/main_requests_section.dart';
import 'package:izin_talep_sistemi/widgets/sections/main_section.dart';

class MainShellScreen extends ConsumerStatefulWidget {
  const MainShellScreen({super.key});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  MainSection _selected = MainSection.mainRequests;

  bool _isManager(String authorityName) =>
      authorityName.startsWith('MANAGER_LEVEL');

  String _titleFor(MainSection section) {
    switch (section) {
      case MainSection.mainRequests:
        return 'İzin Taleplerim';
      case MainSection.mainBalance:
        return 'Bakiyem';
      case MainSection.mainApprovals:
        return 'Çalışan Talepleri';
    }
  }

  NavBarItem _navItemFor(MainSection section) {
    switch (section) {
      case MainSection.mainRequests:
        return const NavBarItem(
          icon: Icons.list_alt_outlined,
          activeIcon: Icons.list_alt,
          label: 'Taleplerim',
        );
      case MainSection.mainBalance:
        return const NavBarItem(
          icon: Icons.account_balance_outlined,
          activeIcon: Icons.account_balance_sharp,
          label: 'Bakiye',
        );
      case MainSection.mainApprovals:
        return const NavBarItem(
          icon: Icons.fact_check_outlined,
          activeIcon: Icons.fact_check,
          label: 'Onaylar',
        );
    }
  }

  Widget _bodyFor(MainSection section) {
    switch (section) {
      case MainSection.mainRequests:
        return const MainRequestsSection();
      case MainSection.mainBalance:
        return const MainBalanceSection();
      case MainSection.mainApprovals:
        return const MainApprovalsSection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value;
    final isManager = user != null && _isManager(user.roleAuthority.name);

    final availableSections = [
      MainSection.mainRequests,
      MainSection.mainBalance,
      if (isManager) MainSection.mainApprovals,
    ];

    final selected = availableSections.contains(_selected)
        ? _selected
        : availableSections.first;

    return Scaffold(
      endDrawer: const ProfileDrawer(),
      appBar: AppBar(
        elevation: 99,
        backgroundColor: context.colors.primary,
        centerTitle: true,
        title: Text(
          _titleFor(selected),
          style: TextStyle(color: context.colors.onPrimary),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: context.colors.onPrimary),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => LeaveRequestFilterSheet(
                initial: ref.read(leaveRequestFilterProvider),
                targetProvider: leaveRequestFilterProvider,
              ),
            ),
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const ProfileAvatarWidget(),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: availableSections.indexOf(selected),
        children: availableSections.map(_bodyFor).toList(),
      ),
      floatingActionButton: selected == MainSection.mainRequests
          ? FloatingActionButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const CreateRequestForm(),
              ),
              child: Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: AppBottomNavBar(
        items: availableSections.map(_navItemFor).toList(),
        currentIndex: availableSections.indexOf(selected),
        onTap: (i) => setState(() => _selected = availableSections[i]),
      ),
    );
  }
}
