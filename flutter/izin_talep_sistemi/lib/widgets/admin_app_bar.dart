import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/admin_appbar_provider.dart';
import 'package:izin_talep_sistemi/theme/theme_extensions.dart';
import 'package:izin_talep_sistemi/widgets/admin_bell_warning.dart';
import 'package:izin_talep_sistemi/widgets/profile_avatar_widget.dart';

class AdminAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final List<Widget>? additionalActions;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final bool hasSearch;

  const AdminAppBar({
    super.key,
    required this.title,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.additionalActions,
    this.searchController,
    this.onSearchChanged,
    this.hasSearch = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBarState = ref.watch(adminAppBarProvider);
    return AppBar(
      elevation: 1,
      automaticallyImplyActions: false,
      automaticallyImplyLeading: false,
      title: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 12,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: context.colors.primary,
              ),
            ),
            if (primaryActionLabel != null && onPrimaryAction != null)
              IconButton(
                onPressed: onPrimaryAction,
                icon: const Icon(Icons.add),
                color: context.colors.secondary,
              ),

            if (hasSearch == true)
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    onChanged: (value) {
                      appBarState.onSearchChanged?.call(value);
                      ref
                          .read(adminAppBarProvider.notifier)
                          .updateSearchQuery(value);
                    },
                    style: TextStyle(color: context.colors.onSurface),
                    decoration: InputDecoration(
                      hintText: 'Ara',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: context.colors.surface,
                      hoverColor: context.colors.surfaceContainerHigh,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(width: 1.8),
                      ),
                      isDense: false,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
              ),
            Spacer(flex: 4),
          ],
        ),
      ),
      actions: [
        const AdminBellWarning(),

        Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const ProfileAvatarWidget(),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          },
        ),
      ],
    );
  }
}
