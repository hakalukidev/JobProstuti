import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CourseCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String description;
  final String? badge;
  // Banner overlay properties
  final String? bannerTopText;
  final String? bannerTitle;
  final String? bannerSubtitle;
  final String? bannerBadge;

  const CourseCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    this.badge,
    this.bannerTopText,
    this.bannerTitle,
    this.bannerSubtitle,
    this.bannerBadge,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isHovered ? 0.08 : 0.03),
              blurRadius: _isHovered ? 40 : 20,
              offset: Offset(0, _isHovered ? 20 : 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Area with Text Overlay
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: AspectRatio(
                aspectRatio: 1.8, // Slightly wider for better text fit
                child: Container(
                  color: const Color(0xFF1E293B),
                  child: Stack(
                    children: [
                      // Image Background
                      Positioned.fill(
                        child: AnimatedScale(
                          scale: _isHovered ? 1.05 : 1.0,
                          duration: const Duration(milliseconds: 500),
                          child: widget.imagePath.isEmpty
                              ? Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.blue.shade900,
                                        Colors.blue.shade700,
                                      ],
                                    ),
                                  ),
                                )
                              : Opacity(
                                  opacity: 0.6, // Dim image to make overlay text pop
                                  child: Image.asset(
                                    widget.imagePath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      
                      // Programmatic Text Overlay (Matching Image style)
                      Positioned(
                        left: 16,
                        top: 0,
                        bottom: 0,
                        right: 80, // Leave room for the person in image
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.bannerTopText != null)
                              Text(
                                widget.bannerTopText!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            if (widget.bannerTitle != null)
                              Text(
                                widget.bannerTitle!,
                                style: const TextStyle(
                                  color: Color(0xFFFFD700), // Gold/Yellow
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Hind Siliguri',
                                  height: 1.2,
                                ),
                              ),
                            if (widget.bannerSubtitle != null)
                              Text(
                                widget.bannerSubtitle!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Hind Siliguri',
                                ),
                              ),
                            if (widget.bannerBadge != null)
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  widget.bannerBadge!,
                                  style: const TextStyle(
                                    color: Color(0xFF1E293B),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Corner Duration Badge
                      if (widget.badge != null)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              widget.badge!,
                              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Hind Siliguri',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Read more link
                  Row(
                    children: [
                      const Text(
                        'বিস্তারিত পড়ুন',
                        style: TextStyle(
                          color: Color(0xFF0095FF),
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 8),
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
