import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class PricingCard extends StatefulWidget {
  final String title;
  final String price;
  final String description;
  final bool isPopular;

  const PricingCard({
    super.key,
    required this.title,
    required this.price,
    required this.description,
    this.isPopular = false,
  });

  @override
  State<PricingCard> createState() => _PricingCardState();
}

class _PricingCardState extends State<PricingCard> {
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
              color: Colors.black.withValues(alpha: _isHovered ? 0.1 : 0.05),
              blurRadius: _isHovered ? 40 : 20,
              offset: Offset(0, _isHovered ? 20 : 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Section (Dark/Gradient)
            Container(
              padding: const EdgeInsets.all(24),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF0F172A), // Dark Navy
                    const Color(0xFF1E293B), // Slightly lighter
                  ],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Hind Siliguri',
                          ),
                        ),
                      ),
                      if (widget.isPopular)
                        const Icon(Icons.star_rounded, color: Color(0xFFFBBF24), size: 20),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 11,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.price,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Hind Siliguri',
                    ),
                  ),
                ],
              ),
            ),
            
            // Features List
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildFeature('সকল লাইভ / আর্কাইভড কোর্স'),
                  _buildFeature('বিষয়ভিত্তিক মডেল টেস্ট'),
                  _buildFeature('বিষয়ভিত্তিক অনুশীলন'),
                  _buildFeature('প্রশ্নব্যাংক / জব সলিউশন'),
                  _buildFeature('সার্চ অপশন'),
                  _buildFeature('প্রিয় প্রশ্ন মার্ক অপশন'),
                  _buildFeature('প্রশ্ন রিপোর্ট এবং রিভিউ অপশন'),
                  
                  const SizedBox(height: 32),
                  
                  // Action Button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _isHovered ? const Color(0xFF0095FF) : const Color(0xFF0095FF).withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'বেছে নিন',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Hind Siliguri',
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
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

  Widget _buildFeature(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Color(0xFFE0F2FE),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: Color(0xFF0095FF), size: 12),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF475569),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
