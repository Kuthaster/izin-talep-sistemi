import 'package:flutter/material.dart';
import 'package:izin_talep_sistemi/theme/theme_extensions.dart';

class NavBarItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  const NavBarItem({required this.icon, required this.label, this.activeIcon});
}

class AppBottomNavBar extends StatelessWidget {
  final List<NavBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(color: scheme.primary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(items.length, (i) {
            final selected = i == currentIndex;
            final item = items[i];
            return Expanded(
              child: _NavButton(
                icon: selected ? (item.activeIcon ?? item.icon) : item.icon,
                label: item.label,
                selected: selected,
                baseColor: scheme.onInverseSurface,
                highlightColor: scheme.tertiary,
                onTap: () => onTap(i),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color baseColor;
  final Color highlightColor;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.baseColor,
    required this.highlightColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: selected ? highlightColor : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: baseColor, size: 22),
            const SizedBox(height: 1),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: baseColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
