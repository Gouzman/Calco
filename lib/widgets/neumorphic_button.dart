import 'package:flutter/material.dart';

class NeuButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  final double size;

  const NeuButton({
    super.key,
    required this.label,
    required this.color,
    required this.onTap,
    this.size = 70,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            // Ombre forte (NE PAS éclaircir)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.8),
              offset: const Offset(4, 4),
              blurRadius: 10,
            ),
            // Highlight très discret
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.05),
              offset: const Offset(-4, -4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(fontSize: 22, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
