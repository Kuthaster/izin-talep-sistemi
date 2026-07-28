import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextAnim extends ConsumerStatefulWidget {
  final String textInput;
  final bool isAnimated;
  final Duration caretBlinkDuration;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? caretColor;
  final Color? textColor;

  const TextAnim({
    super.key,
    required this.textInput,
    this.isAnimated = true,
    this.caretBlinkDuration = const Duration(milliseconds: 500),
    this.fontSize = 20,
    this.fontWeight = FontWeight.bold,
    this.caretColor,
    this.textColor,
  });

  @override
  ConsumerState<TextAnim> createState() => _TextAnimState();
}

class _TextAnimState extends ConsumerState<TextAnim>
    with SingleTickerProviderStateMixin {
  late AnimationController _caretController;

  @override
  void initState() {
    super.initState();

    _caretController = AnimationController(
      vsync: this,
      duration: widget.caretBlinkDuration,
    );
    _caretController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _caretController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actualTextColor =
        widget.textColor ?? Theme.of(context).colorScheme.onSurface;
    final actualCaretColor =
        widget.caretColor ?? Theme.of(context).colorScheme.onSurface;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.textInput,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
            color: widget.textColor,
          ),
        ),
        FadeTransition(
          opacity: _caretController.drive(CurveTween(curve: Curves.easeInOut)),
          child: Text(
            '_',
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight,
              color: widget.caretColor,
            ),
          ),
        ),
      ],
    );
  }
}
