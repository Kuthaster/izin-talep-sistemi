import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/screens/admin_shell_screen.dart';
import 'package:izin_talep_sistemi/theme/theme_extensions.dart';
import 'package:izin_talep_sistemi/ultilities/logout.dart';
import 'package:izin_talep_sistemi/widgets/primary_icon_button.dart';

class AdminSidebar extends ConsumerStatefulWidget {
  static const double expandedWidth = 250;
  static const double collapsedWidth = 64;

  final bool initiallyExpanded;
  final AdminSection currentSection;
  final Function(AdminSection) onSectionSelected;

  const AdminSidebar({
    super.key,
    this.initiallyExpanded = true,
    required this.currentSection,
    required this.onSectionSelected,
  });

  @override
  ConsumerState<AdminSidebar> createState() => _AdminSidebarState();
}

class _AdminSidebarState extends ConsumerState<AdminSidebar> {
  late bool _collapsed;

  @override
  void initState() {
    super.initState();
    _collapsed = !widget.initiallyExpanded;
  }

  void _toggle() => setState(() => _collapsed = !_collapsed);

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final targetWidth = _collapsed
        ? AdminSidebar.collapsedWidth
        : AdminSidebar.expandedWidth;

    return Material(
      color: scheme.primary,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: AdminSidebar.expandedWidth,
              end: targetWidth,
            ),
            duration: const Duration(milliseconds: 160),
            curve: Curves.decelerate,
            builder: (context, w, _) {
              return ClipRect(
                child: SizedBox(
                  width: w,
                  child: _SidebarContent(
                    ref: ref,
                    collapsed: _collapsed,
                    currentSection: widget.currentSection,
                    onSectionSelected: widget.onSectionSelected,
                  ),
                ),
              );
            },
          ),

          _ChevronHandle(
            collapsed: _collapsed,
            expandedWidth: AdminSidebar.expandedWidth,
            collapsedWidth: AdminSidebar.collapsedWidth,
            onTap: _toggle,
          ),
        ],
      ),
    );
  }
}

class _SidebarContent extends StatelessWidget {
  final WidgetRef ref;
  final bool collapsed;
  final AdminSection currentSection;
  final Function(AdminSection) onSectionSelected;

  const _SidebarContent({
    required this.ref,
    required this.collapsed,
    required this.currentSection,
    required this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;

    return SizedBox(
      width: AdminSidebar.expandedWidth,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 8),
            alignment: Alignment.center,
            child: collapsed
                ? Text(
                    "A",
                    style: TextStyle(
                      color: scheme.onInverseSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    'ADMIN',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: scheme.onInverseSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _NavItem(
                  collapsed: collapsed,
                  label: 'İzinler',
                  section: AdminSection.adminApprovals,
                  icon: Icons.check_circle_outline,
                  isActive: currentSection == AdminSection.adminApprovals,
                  onTap: () => onSectionSelected(AdminSection.adminApprovals),
                ),
                _NavItem(
                  collapsed: collapsed,
                  label: 'Kullanıcılar',
                  section: AdminSection.adminUsers,
                  icon: Icons.people_outline,
                  isActive: currentSection == AdminSection.adminUsers,
                  onTap: () => onSectionSelected(AdminSection.adminUsers),
                ),
                _NavItem(
                  collapsed: collapsed,
                  label: 'Departmanlar',
                  section: AdminSection.adminDepartments,
                  icon: Icons.business_outlined,
                  isActive: currentSection == AdminSection.adminDepartments,
                  onTap: () => onSectionSelected(AdminSection.adminDepartments),
                ),
                _NavItem(
                  collapsed: collapsed,
                  label: 'İzin Türleri',
                  section: AdminSection.adminLeaveTypes,
                  icon: Icons.calendar_today_outlined,
                  isActive: currentSection == AdminSection.adminLeaveTypes,
                  onTap: () => onSectionSelected(AdminSection.adminLeaveTypes),
                ),
                _NavItem(
                  collapsed: collapsed,
                  label: 'Roller',
                  section: AdminSection.adminRoles,
                  icon: Icons.person,
                  isActive: currentSection == AdminSection.adminRoles,
                  onTap: () => onSectionSelected(AdminSection.adminRoles),
                ),
                _NavItem(
                  collapsed: collapsed,
                  label: 'Bakiyeler',
                  section: AdminSection.adminBalances,
                  icon: Icons.pie_chart_outline,
                  isActive: currentSection == AdminSection.adminBalances,
                  onTap: () => onSectionSelected(AdminSection.adminBalances),
                ),
                _NavItem(
                  collapsed: collapsed,
                  label: 'Denetim Kayıtları',
                  section: AdminSection.adminBalanceAudits,
                  icon: Icons.receipt_long_rounded,
                  isActive: currentSection == AdminSection.adminBalanceAudits,
                  onTap: () =>
                      onSectionSelected(AdminSection.adminBalanceAudits),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: scheme.onInverseSurface)),
            ),
            child: collapsed
                ? Tooltip(
                    message: 'Çıkış Yap',
                    child: PrimaryIconButton(
                      onPressed: () => logout(context, ref),
                      icon: Icons.logout,
                    ),
                  )
                : SizedBox(
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
    );
  }
}

class _NavItem extends StatelessWidget {
  final bool collapsed;
  final String label;
  final AdminSection section;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.collapsed,
    required this.label,
    required this.section,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    final tile = Container(
      margin: EdgeInsets.symmetric(horizontal: collapsed ? 8 : 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? scheme.tertiary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: collapsed
          ? IconButton(
              icon: Icon(
                icon,
                color: isActive
                    ? scheme.onPrimaryFixedVariant
                    : scheme.onInverseSurface,
              ),
              onPressed: onTap,
            )
          : ListTile(
              leading: Icon(
                icon,
                color: isActive
                    ? scheme.onPrimaryFixedVariant
                    : scheme.onInverseSurface,
              ),
              title: Text(
                label,
                style: TextStyle(
                  color: isActive ? scheme.onInverseSurface : scheme.onPrimary,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              onTap: onTap,
              hoverColor: Colors.transparent,
            ),
    );

    return collapsed ? Tooltip(message: label, child: tile) : tile;
  }
}

class _ChevronHandle extends StatelessWidget {
  final bool collapsed;
  final double expandedWidth;
  final double collapsedWidth;
  final VoidCallback onTap;

  const _ChevronHandle({
    required this.collapsed,
    required this.expandedWidth,
    required this.collapsedWidth,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final y = (MediaQuery.sizeOf(context).height - 80) / 2;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      left: collapsed ? collapsedWidth - 24 : expandedWidth - 24,
      top: y,
      child: Material(
        color: context.colors.tertiary,
        shape: const RoundedRectangleBorder(),
        elevation: 10,
        child: InkWell(
          customBorder: const RoundedRectangleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 24,
            height: 36,
            child: Icon(
              collapsed
                  ? Icons.chevron_right_outlined
                  : Icons.chevron_left_outlined,
              size: 16,
              color: context.colors.onTertiary,
            ),
          ),
        ),
      ),
    );
  }
}
