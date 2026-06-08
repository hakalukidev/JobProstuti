import 'package:flutter/material.dart';

class CallButton extends StatelessWidget {
  const CallButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white54, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text('📞 ০১৮৯৪-৪৪২৯৪৪', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
    );
  }
}