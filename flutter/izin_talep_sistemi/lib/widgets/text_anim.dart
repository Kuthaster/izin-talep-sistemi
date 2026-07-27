import 'package:flutter/material.dart';

class TextAnim extends StatefulWidget {
  final String text;
  const TextAnim({super.key, required this.text});

  @override
  State<TextAnim> createState() => _TextAnimState();
}

class _TextAnimState extends State<TextAnim>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorAnim = ColorTween(
      begin: const Color.fromARGB(255, 255, 104, 11),
      end: const Color.fromARGB(255, 120, 8, 218),
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));

    return AnimatedBuilder(
      animation: colorAnim,
      builder: (context, _) => Text(
        widget.text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colorAnim.value,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
