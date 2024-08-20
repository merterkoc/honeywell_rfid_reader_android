import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  const CardButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    this.padding = const EdgeInsets.all(8),
    super.key,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(120, 120),
          maximumSize: const Size(120, 120),
        ),
        icon: Icon(icon),
        label: Text(label),
        onPressed: onPressed,
      ),
    );
  }
}
