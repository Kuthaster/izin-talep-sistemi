import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/screens/profile_screen.dart';
import 'package:izin_talep_sistemi/widgets/profile_avatar_widget.dart';

class AdminAppBar extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
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

          Expanded(
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 16),

                SizedBox(
                  width: 320,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Ara',
                      prefixIcon: Icon(Icons.search),
                      fillColor: Theme.of(
                        context,
                      ).colorScheme.inverseSurface, //TODO COLORTEST
                      hoverColor: Theme.of(context).colorScheme.tertiary,
                      focusColor: Theme.of(context).colorScheme.secondary,
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    onChanged: onSearchChanged,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
            child: ProfileAvatarWidget(),
          ),
        ],
      ),
    );
  }
}
