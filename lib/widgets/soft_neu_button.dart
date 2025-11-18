import 'package:flutter/material.dart';

class SoftNeuButton extends StatelessWidget {
  final String label;
  final Color color;
  final double size;
  final VoidCallback onTap;
  final Color textColor;

  const SoftNeuButton({
    super.key,
    required this.label,
    required this.color,
    required this.textColor,
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
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-4, -4),
              blurRadius: 6,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              offset: const Offset(4, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
