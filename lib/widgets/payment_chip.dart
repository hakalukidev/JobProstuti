import 'package:flutter/material.dart';

class PaymentChip extends StatelessWidget {
  final String name;
  const PaymentChip({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(name, style: const TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w600)),
    );
  }
}