import 'package:flutter/material.dart';
import '../app/theme.dart';

class PaymentChip extends StatelessWidget {
  final String name;
  const PaymentChip({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(
        name,
        style: AppTextStyles.bodySmall.copyWith(color: Colors.white70, fontWeight: FontWeight.bold),
      ),
    );
  }
}
