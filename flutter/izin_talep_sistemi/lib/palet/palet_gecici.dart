import 'package:flutter/material.dart';

class PaletGecici extends StatelessWidget {
  const PaletGecici({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Each entry: label -> valueGetter
    final entries = <_ColorEntry>[
      _ColorEntry('primary', () => cs.primary, () => cs.onPrimary),
      _ColorEntry('secondary', () => cs.secondary, () => cs.onSecondary),
      _ColorEntry('tertiary', () => cs.tertiary, () => cs.onTertiary),
      _ColorEntry('error', () => cs.error, () => cs.onError),

      _ColorEntry(
        'primaryContainer',
        () => cs.primaryContainer,
        () => cs.onPrimaryContainer,
      ),
      _ColorEntry(
        'secondaryContainer',
        () => cs.secondaryContainer,
        () => cs.onSecondaryContainer,
      ),
      _ColorEntry(
        'tertiaryContainer',
        () => cs.tertiaryContainer,
        () => cs.onTertiaryContainer,
      ),

      _ColorEntry('surface', () => cs.surface, () => cs.onSurface),
      _ColorEntry(
        'surfaceVariant',
        () => cs.surfaceContainerHighest,
        () => cs.onSurfaceVariant,
      ),

      _ColorEntry('background', () => cs.surface, () => cs.onSurface),

      _ColorEntry(
        'inverseSurface',
        () => cs.inverseSurface,
        () => cs.onInverseSurface,
      ),
      _ColorEntry(
        'inversePrimary',
        () => cs.inversePrimary,
        () => cs.onPrimary,
      ),

      _ColorEntry('outline', () => cs.outline, () => cs.onSurface),
      _ColorEntry(
        'outlineVariant',
        () => cs.outlineVariant,
        () => cs.onSurface,
      ),
      _ColorEntry('shadow', () => cs.shadow, () => cs.onSurface),
      _ColorEntry('scrim', () => cs.scrim, () => cs.onSurface),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Theme Color Palette')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: entries.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final e = entries[i];
          final color = e.value();
          final onColor = e.onValue();

          return ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.transparent,
              child: Row(
                children: [
                  // Swatch block
                  Container(
                    width: 84,
                    height: 56,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      e.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: onColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.label,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'swatch: ${_hex(color)}\non: ${_hex(onColor)}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontFamily: 'monospace'),
                        ),

                        const SizedBox(height: 10),

                        // Contrast preview
                        Container(
                          height: 34,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black12),
                          ),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Sample text',
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _hex(Color c) {
    final v = c.value & 0xFFFFFFFF;
    return '#${v.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }
}

class _ColorEntry {
  final String label;
  final Color Function() value;
  final Color Function() onValue;

  _ColorEntry(this.label, this.value, this.onValue);
}
