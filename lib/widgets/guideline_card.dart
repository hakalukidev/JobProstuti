import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class GuidelineCard extends StatefulWidget {
  final String title;
  final String description;
  final List<String> tags;
  final String imagePath;

  const GuidelineCard({
    super.key,
    required this.title,
    required this.description,
    required this.tags,
    required this.imagePath,
  });

  @override
  State<GuidelineCard> createState() => _GuidelineCardState();
}

class _GuidelineCardState extends State<GuidelineCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A).withValues(alpha: 0.5), // Dark navy body
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered ? AppColors.secondary : Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image Placeholder
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade900, Colors.blue.shade600],
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.description_rounded, color: Colors.white24, size: 50),
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags Row
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.tags.map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B).withValues(alpha: 0.8), // Darker tag bg
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 16),
                  
                  // Title
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Hind Siliguri',
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  // Description
                  Text(
                    widget.description,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Link
                  Row(
                    children: [
                      Text(
                        'গাইডলাইন দেখুন',
                        style: TextStyle(
                          color: _isHovered ? AppColors.secondary : const Color(0xFF0095FF),
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: _isHovered ? AppColors.secondary : const Color(0xFF0095FF),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
