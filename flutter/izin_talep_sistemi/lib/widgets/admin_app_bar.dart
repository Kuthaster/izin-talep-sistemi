import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/providers/admin_appbar_provider.dart';
import 'package:izin_talep_sistemi/widgets/profile_avatar_widget.dart';

class AdminAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final List<Widget>? additionalActions;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;

  const AdminAppBar({
    super.key,
    required this.title,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.additionalActions,
    this.searchController,
    this.onSearchChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBarState = ref.watch(adminAppBarProvider);

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 1,
      automaticallyImplyActions: false,
      automaticallyImplyLeading: false,
      title: Expanded(
        child: Row(
          children: [
            if (primaryActionLabel != null && onPrimaryAction != null)
              ElevatedButton.icon(
                onPressed: onPrimaryAction,
                icon: const Icon(Icons.add),
                label: Text(primaryActionLabel!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  foregroundColor: Theme.of(context).colorScheme.scrim,
                ),
              ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                onChanged: (value) {
                  appBarState.onSearchChanged?.call(value);
                  ref
                      .read(adminAppBarProvider.notifier)
                      .updateSearchQuery(value);
                },
                decoration: InputDecoration(
                  hintText: 'Ara',
                  prefixIcon: const Icon(Icons.search),
                  fillColor: Theme.of(context).colorScheme.inverseSurface,
                  hoverColor: Theme.of(context).colorScheme.tertiary,
                  focusColor: Theme.of(context).colorScheme.secondary,
                  border: const OutlineInputBorder(),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      actions: [
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
