import 'package:flutter/material.dart';

class GuidelineCard extends StatefulWidget {
  final String title;
  final String description;
  final List<String> tags;
  final String imagePath;
  final String marks;
  final Color? accentColor;

  const GuidelineCard({
    super.key,
    required this.title,
    required this.description,
    required this.tags,
    required this.imagePath,
    this.marks = '৩৫',
    this.accentColor,
  });

  @override
  State<GuidelineCard> createState() => _GuidelineCardState();
}

class _GuidelineCardState extends State<GuidelineCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.sizeOf(context).width < 850;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          // ... (keep gradient and other styles)
          // Premium Deep Forest Green Gradient to match app but with more depth
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF022C22), // App primary Dark
              const Color(0xFF05211A), // Darker hue
              const Color(0xFF011611), // Deepest forest green
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered
                ? (widget.accentColor ?? const Color(0xFF10B981)).withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.05),
            width: 1.5,
          ),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: (widget.accentColor ?? const Color(0xFF10B981)).withValues(alpha: 0.15),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── High Fidelity Programmatic Banner (Matching Image 3) ──
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: AspectRatio(
                    aspectRatio: isMobile ? 2.2 : 1.8,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFDF7F2), // Exact cream bg from image
                      ),
                      child: Stack(
                        children: [
                          // Left Side Gold Leaf Ornament (Matching Image 3)
                          Positioned(
                            left: -10,
                            top: -10,
                            bottom: -10,
                            width: 60,
                            child: Opacity(
                              opacity: 0.15,
                              child: Transform.rotate(
                                angle: -0.2,
                                child: const Icon(Icons.eco_rounded, size: 100, color: Color(0xFFB45309)), // Amber/Gold leaf
                              ),
                            ),
                          ),
                          
                          // Decorative blue curve on the left
                          Positioned(
                            left: 0, top: 0, bottom: 0, width: 40,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    const Color(0xFF0F172A).withValues(alpha: 0.05),
                                    const Color(0xFF0F172A).withValues(alpha: 0.0),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Main Banner Content
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 12, 16, 12),
                            child: Row(
                              children: [
                                // Left Column: Branding and Title
                                Expanded(
                                  flex: 6,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Brand Logo: JOB PROSTUTI
                                      Row(
                                        children: [
                                          Column(
                                            children: List.generate(3, (i) => Container(
                                              width: 12, height: 2, margin: const EdgeInsets.only(bottom: 1.5),
                                              color: const Color(0xFF0F172A),
                                            )),
                                          ),
                                          const SizedBox(width: 6),
                                          const Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('JOB', style: TextStyle(color: Color(0xFF0F172A), fontSize: 14, fontWeight: FontWeight.w900, height: 1)),
                                              Text('PROSTUTI', style: TextStyle(color: Color(0xFF0F172A), fontSize: 7, fontWeight: FontWeight.w700, letterSpacing: 1)),
                                            ],
                                          )
                                        ],
                                      ),
                                      const Spacer(),
                                      // Title
                                      Text(
                                        widget.title,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF0F172A),
                                          height: 1.1,
                                          fontFamily: 'Hind Siliguri',
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      // Dark badge sub-header (Exact styling from Image 3)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0F172A),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: const Text(
                                          'টপিকভিত্তিক প্রশ্ন বিশ্লেষণ (৩৫-৪৫ বিসিএস)',
                                          style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const Spacer(),
                                      // Bottom row of tiny icons
                                      Row(
                                        children: [
                                          _bannerSmallIcon(Icons.insights_rounded, 'টপিকভিত্তিক\nবিশ্লেষণ'),
                                          const SizedBox(width: 12),
                                          _bannerSmallIcon(Icons.track_changes_rounded, 'গুরুত্ব\nরেটিং'),
                                          const SizedBox(width: 12),
                                          _bannerSmallIcon(Icons.assignment_turned_in_rounded, 'পড়ার\nঅগ্রাধিকার'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Right Side Visuals
                                Expanded(
                                  flex: 4,
                                  child: Stack(
                                    alignment: Alignment.centerRight,
                                    children: [
                                      // Subject Specific Icon (Large decorative)
                                      Opacity(
                                        opacity: 0.05,
                                        child: _getLargeSubjectIcon(widget.title, size: 120),
                                      ),
                                      // Main Visual
                                      Positioned(
                                        right: 0,
                                        child: _getLargeSubjectIcon(widget.title, size: 70, isBold: true),
                                      ),
                                      
                                      // The "Key to Success" Circular Stamp (Bottom Right of banner)
                                      Positioned(
                                        bottom: 0, right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF0F172A),
                                            shape: BoxShape.circle,
                                            border: Border.all(color: const Color(0xFFFBBF24), width: 1.5),
                                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4)],
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Text('সফলতার', style: TextStyle(color: Colors.white, fontSize: 4, fontWeight: FontWeight.bold)),
                                              Icon(Icons.vpn_key_rounded, color: Color(0xFFFBBF24), size: 10),
                                              Text('চাবিকাঠি', style: TextStyle(color: Colors.white, fontSize: 4, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Marks Badge (Top Right)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1B4B).withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${widget.marks} মার্ক',
                      style: const TextStyle(
                        color: Color(0xFF38BDF8),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Card Content Body ─────────────────────
            Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Row(
                      children: widget.tags
                          .map((tag) => Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 8 : 12, 
                                  vertical: isMobile ? 4 : 6
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: (widget.accentColor ?? const Color(0xFF10B981)).withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isMobile ? 10 : 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  SizedBox(height: isMobile ? 12 : 20),

                  Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 18 : 20,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Hind Siliguri',
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    widget.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: isMobile ? 13 : 14,
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: isMobile ? 16 : 28),

                  // Fixed "Guideline" Link
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'গাইডলাইন দেখুন',
                          style: TextStyle(
                            color: const Color(0xFF38BDF8),
                            fontSize: isMobile ? 14 : 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: isMobile ? 16 : 18, color: const Color(0xFF38BDF8)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bannerSmallIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: const Color(0xFF0F172A).withValues(alpha: 0.6)),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 6, color: Color(0xFF0F172A), fontWeight: FontWeight.bold, height: 1.1),
        ),
      ],
    );
  }

  Widget _getLargeSubjectIcon(String title, {double size = 80, bool isBold = false}) {
    final color = isBold ? const Color(0xFF0F172A) : const Color(0xFF0F172A).withValues(alpha: 0.1);
    if (title.contains('বাংলা')) {
      return Text('অ', style: TextStyle(fontSize: size, fontWeight: FontWeight.w900, color: color));
    } else if (title.contains('ইংরেজি')) {
      return Text('ABC', style: TextStyle(fontSize: size * 0.7, fontWeight: FontWeight.w900, color: color));
    } else {
      return Text('অ', style: TextStyle(fontSize: size, fontWeight: FontWeight.w900, color: color));
    }
  }
}
