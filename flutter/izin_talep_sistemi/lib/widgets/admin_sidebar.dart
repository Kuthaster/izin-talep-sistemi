import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/screens/admin_shell_screen.dart';
import 'package:izin_talep_sistemi/ultilities/logout.dart';

class AdminSidebar extends ConsumerStatefulWidget {
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
  static const double _expandedWidth = 250;
  static const double _collapsedWidth = 64;

  late bool _collapsed;

  @override
  void initState() {
    super.initState();
    _collapsed = !widget.initiallyExpanded;
  }

  void _toggle() {
    setState(() => _collapsed = !_collapsed);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final width = _collapsed ? _collapsedWidth : _expandedWidth;

    return Material(
      color: scheme.primary,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.decelerate,
            width: width,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 26,
                    horizontal: 8,
                  ),
                  alignment: Alignment.center,
                  child: _collapsed
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
                      _buildNavItem(
                        context,
                        label: 'İzinler',
                        section: AdminSection.adminApprovals,
                        icon: Icons.check_circle_outline,
                      ),
                      _buildNavItem(
                        context,
                        label: 'Kullanıcılar',
                        section: AdminSection.adminUsers,
                        icon: Icons.people_outline,
                      ),
                      _buildNavItem(
                        context,
                        label: 'Departmanlar',
                        section: AdminSection.adminDepartments,
                        icon: Icons.business_outlined,
                      ),
                      _buildNavItem(
                        context,
                        label: 'İzin Türleri',
                        section: AdminSection.adminLeaveTypes,
                        icon: Icons.calendar_today_outlined,
                      ),
                      _buildNavItem(
                        context,
                        label: 'Onaylayıcı Zinciri',
                        section: AdminSection.adminApproverChain,
                        icon: Icons.account_tree_outlined,
                      ),
                      _buildNavItem(
                        context,
                        label: 'Roller',
                        section: AdminSection.adminRoles,
                        icon: Icons.person,
                      ),
                      _buildNavItem(
                        context,
                        label: 'Bakiyeler',
                        section: AdminSection.adminBalances,
                        icon: Icons.pie_chart_outline,
                      ),
                    ],
                  ),
                ),

                // Bottom part
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).colorScheme.onInverseSurface,
                      ),
                    ),
                  ),
                  child: _collapsed
                      ? Tooltip(
                          message: 'Çıkış Yap',
                          child: IconButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                scheme.tertiary,
                              ),
                              overlayColor: WidgetStateProperty.all(
                                scheme.secondary,
                              ),
                            ),
                            onPressed: () => logout(context, ref),
                            icon: Icon(
                              Icons.logout,
                              color: scheme.onInverseSurface,
                            ),
                          ),
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                scheme.tertiary,
                              ),
                              overlayColor: WidgetStateProperty.all(
                                scheme.secondary,
                              ),
                            ),
                            onPressed: () => logout(context, ref),
                            icon: Icon(
                              Icons.logout,
                              color: scheme.onInverseSurface,
                            ),
                            label: Text(
                              'Çıkış Yap',
                              style: TextStyle(color: scheme.onInverseSurface),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            left: width - 14,
            top: (MediaQuery.sizeOf(context).height - 80) / 2,
            child: Material(
              color: scheme.tertiary,
              shape: const CircleBorder(),
              elevation: 3,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _toggle,
                hoverColor: scheme.secondary.withValues(alpha: 0.3),
                splashColor: scheme.secondary,
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: Icon(
                    _collapsed
                        ? Icons.chevron_right_outlined
                        : Icons.chevron_left_outlined,
                    color: scheme.onInverseSurface,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required String label,
    required AdminSection section,
    required IconData icon,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final isActive = widget.currentSection == section;

    final tile = Container(
      margin: EdgeInsets.symmetric(
        horizontal: _collapsed ? 8 : 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isActive ? scheme.tertiary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: _collapsed
          ? IconButton(
              icon: Icon(
                icon,
                color: isActive
                    ? scheme.onPrimaryFixedVariant
                    : scheme.onInverseSurface,
              ),
              onPressed: () => widget.onSectionSelected(section),
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
              onTap: () => widget.onSectionSelected(section),
              hoverColor: Colors.transparent,
            ),
    );

    return _collapsed ? Tooltip(message: label, child: tile) : tile;
  }
}
