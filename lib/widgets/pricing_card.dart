import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class PricingCard extends StatefulWidget {
  final String title;
  final String price;
  final String? strikePrice;
  final String description;
  final bool isPopular;
  final Widget? badge;

  const PricingCard({
    super.key,
    required this.title,
    required this.price,
    this.strikePrice,
    required this.description,
    this.isPopular = false,
    this.badge,
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
              color: AppColors.secondary.withValues(alpha: _isHovered ? 0.15 : 0.05),
              blurRadius: _isHovered ? 50 : 20,
              offset: Offset(0, _isHovered ? 25 : 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Section (Green Gradient) - Fixed Height for Uniformity
            Container(
              height: 280, // Fixed height to match all cards
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryDark, 
                    AppColors.primary,
                  ],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Title Area with fixed height to handle multi-line consistency
                  SizedBox(
                    height: 80, 
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.badge != null) ...[
                                widget.badge!,
                                const SizedBox(height: 8),
                              ],
                              Text(
                                widget.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 19, 
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Hind Siliguri',
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (widget.isPopular)
                          const Icon(Icons.star_rounded, color: Color(0xFFFBBF24), size: 24),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.price,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 44,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Hind Siliguri',
                        ),
                      ),
                      if (widget.strikePrice != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          widget.strikePrice!,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 18,
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            
            // Features List - Scrollable to prevent overflow but mostly fixed in height
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      _buildFeature('সকল লাইভ / আর্কাইভড কোর্স'),
                      _buildFeature('বিষয়ভিত্তিক মডেল টেস্ট'),
                      _buildFeature('বিষয়ভিত্তিক অনুশীলন'),
                      _buildFeature('প্রশ্নব্যাংক / জব সলিউশন'),
                      _buildFeature('সার্চ অপশন'),
                      _buildFeature('প্রিয় প্রশ্ন মার্ক অপশন'),
                      _buildFeature('প্রশ্ন রিপোর্ট এবং রিভিউ অপশন'),
                    ],
                  ),
                ),
              ),
            ),

            // Action Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  color: _isHovered ? AppColors.secondary : const Color(0xFF0095FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'বেছে নিন',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Hind Siliguri',
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                  ],
                ),
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
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: AppColors.secondary, size: 12),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF475569),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
