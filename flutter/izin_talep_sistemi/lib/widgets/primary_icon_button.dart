import 'package:flutter/material.dart';
import 'package:izin_talep_sistemi/theme/theme_extensions.dart';

class PrimaryIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  const PrimaryIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;

    return IconButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(scheme.tertiary),
        foregroundColor: WidgetStateProperty.all(scheme.onTertiary),
        overlayColor: WidgetStateProperty.all(scheme.secondary),
      ),
      tooltip: tooltip,
      icon: Icon(icon),
      onPressed: onPressed,
    );
  }
}
