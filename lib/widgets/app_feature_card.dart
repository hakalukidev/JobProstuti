import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class AppFeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  const AppFeatureCard({
    super.key, required this.icon, required this.title, required this.description,
  });

  @override
  State<AppFeatureCard> createState() => _AppFeatureCardState();
}

class _AppFeatureCardState extends State<AppFeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: _isHovered ? Colors.white : const Color(0xFFF0F7FF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _isHovered ? const Color(0xFF0095FF) : const Color(0xFFD1E9FF),
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: const Color(0xFF0095FF).withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Circle
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFE1F0FF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                size: 26,
                color: const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                fontFamily: 'Hind Siliguri',
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            // Description
            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF475569),
                fontSize: 13,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
