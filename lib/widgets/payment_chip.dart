import 'package:flutter/material.dart';

class PaymentChip extends StatelessWidget {
  final String name;
  const PaymentChip({required this.name, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(
        name,
        style: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
