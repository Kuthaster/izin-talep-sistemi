import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izin_talep_sistemi/screens/profile_screen.dart';
import 'package:izin_talep_sistemi/widgets/profile_avatar_widget.dart';

class AdminAppBar extends ConsumerWidget {
  final String title;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final List<Widget>? additionalActions;

  const AdminAppBar({
    super.key,
    required this.title,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.additionalActions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          if (primaryActionLabel != null && onPrimaryAction != null)
            ElevatedButton.icon(
              onPressed: onPrimaryAction,
              icon: const Icon(Icons.add),
              label: Text(primaryActionLabel!),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const Spacer(flex: 15),

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
