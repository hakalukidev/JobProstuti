import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'pricing_card.dart';

class PricingSlider extends StatefulWidget {
  const PricingSlider({super.key});

  @override
  State<PricingSlider> createState() => _PricingSliderState();
}

class _PricingSliderState extends State<PricingSlider> {
  PageController? _pageController;
  int _currentPage = 0;
  late Timer _timer;
  bool _isAutoPlaying = true;

  final List<Map<String, dynamic>> _plans = [
    {
      'title': '১ মাসের ফুল অ্যাপ এক্সেস',
      'price': '৳১৪৯',
      'desc': '৩০ দিনের জন্য বিসিএস, ব্যাংক, প্রাইমারি, শিক্ষক নিবন্ধন (NTRCA) সহ আপ্প এর স...',
      'isPopular': false,
    },
    {
      'title': '৩ মাসের ফুল অ্যাপ এক্সেস',
      'price': '৳২৯৯',
      'desc': '৯০ দিনের জন্য বিসিএস, ব্যাংক, প্রাইমারি, শিক্ষক নিবন্ধন (NTRCA) সহ আপ্প এর স...',
      'isPopular': false,
    },
    {
      'title': '৬ মাসের ফুল অ্যাপ এক্সেস',
      'price': '৳৪৯৯',
      'strike': '৳৭৯৯',
      'desc': '১৮০ দিনের জন্য বিসিএস, ব্যাংক, প্রাইমারি, শিক্ষক নিবন্ধন (NTRCA) সহ আপ্প এর স...',
      'isPopular': false,
    },
    {
      'title': '১ বছরের ফুল অ্যাপ এক্সেস',
      'price': '৳৭১৯',
      'desc': '১ বছরের জন্য বিসিএস, ব্যাংক, প্রাইমারি, শিক্ষক নিবন্ধন (NTRCA) সহ আপ্প এর স...',
      'isPopular': true,
    },
    {
      'title': '২ বছরের ফুল অ্যাপ এক্সেস',
      'price': '৳৯৯৯',
      'strike': '৳১২৯৯',
      'desc': '২ বছরের জন্য বিসিএস, ব্যাংক, প্রাইমারি, শিক্ষক নিবন্ধন (NTRCA) সহ আপ্প এর স...',
      'isPopular': false,
      'badge': Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(color: Colors.blue.shade700, borderRadius: BorderRadius.circular(4)),
        child: const Text('BCN', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
      ),
    },
    {
      'title': '১ বছরের Undergrad - Student Package [শুধুমাত্র বিসিএস]',
      'price': '৳৩৯৯',
      'strike': '৳৬৯৯',
      'desc': '১ বছরের জন্য শুধুমাত্র "বিসিএস প্রস্তুতি - Undergrad [Student Package]" কোর্স এ...',
      'isPopular': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (!_isAutoPlaying) return;
      if (_currentPage < _plans.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController != null && _pageController!.hasClients) {
        _pageController!.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOutQuart,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.sizeOf(context).width < 850;
    final double viewportFraction = isMobile ? 0.8 : (MediaQuery.sizeOf(context).width < 1100 ? 0.5 : 0.333);

    if (_pageController == null || _pageController!.viewportFraction != viewportFraction) {
      _pageController?.dispose();
      _pageController = PageController(viewportFraction: viewportFraction, initialPage: _currentPage);
    }

    return Column(
      children: [
        SizedBox(
          height: isMobile ? 650 : 680,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() => _currentPage = page);
            },
            itemCount: _plans.length,
            itemBuilder: (context, index) {
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isAutoPlaying = false;
                      _currentPage = index;
                    });
                    _pageController?.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                    );
                    // Resume auto-play after 10s of inactivity
                    Future.delayed(const Duration(seconds: 10), () {
                      if (mounted) setState(() => _isAutoPlaying = true);
                    });
                  },
                  child: AnimatedScale(
                    scale: _currentPage == index ? 1.0 : 0.95,
                    duration: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: PricingCard(
                        title: _plans[index]['title'],
                        price: _plans[index]['price'],
                        strikePrice: _plans[index]['strike'],
                        description: _plans[index]['desc'],
                        isPopular: _plans[index]['isPopular'],
                        badge: _plans[index]['badge'],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 30),
        // Clickable Selection Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_plans.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() => _isAutoPlaying = false);
                _pageController?.animateToPage(index,
                    duration: const Duration(milliseconds: 600), 
                    curve: Curves.easeInOut);
                Future.delayed(const Duration(seconds: 10), () {
                  if (mounted) setState(() => _isAutoPlaying = true);
                });
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 10,
                  width: _currentPage == index ? 24 : 10,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? const Color(0xFF0095FF) : Colors.white24,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
