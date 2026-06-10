import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'phone_mockup.dart';

class FeatureSlider extends StatefulWidget {
  const FeatureSlider({super.key});

  @override
  State<FeatureSlider> createState() => _FeatureSliderState();
}

class _FeatureSliderState extends State<FeatureSlider> {
  final PageController _pageController = PageController(viewportFraction: 0.32);
  int _currentPage = 0;
  late Timer _timer;
  bool _isAutoPlaying = true;

  final List<Map<String, String>> _features = [
    {
      'title': 'লাইভ পরীক্ষা',
      'desc': 'প্রতিদিন কোর্স ভিত্তিক লাইভ পরীক্ষা',
      'type': 'live_exam'
    },
    {
      'title': 'প্রস্তুতির পরিসংখ্যান',
      'desc': 'প্রস্তুতির সামগ্রিক পরিসংখ্যান',
      'type': 'stats'
    },
    {
      'title': 'কুইজ কুইজ',
      'desc': 'প্রস্তুতি হবে মজায় মজায়, প্রস্তুতি খেলায় খেলায়',
      'type': 'quiz'
    },
    {
      'title': 'ব্যাখ্যা সহ প্রিমিয়াম প্রশ্ন পত্র',
      'desc': 'বিস্তারিত ব্যাখ্যা সহ সাজানো প্রতিটি প্রশ্ন',
      'type': 'premium_questions'
    },
    {
      'title': 'পরীক্ষার মূল্যায়ন',
      'desc': 'পরীক্ষার মার্কস এর বিষয়ভিত্তিক মূল্যায়ন',
      'type': 'evaluation'
    },
    {
      'title': 'মেধা তালিকা',
      'desc': 'হাজারো প্রতিযোগীর সাথে যাচাই করা যাবে নিজের অবস্থান',
      'type': 'leaderboard'
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
      
      if (_currentPage < _features.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
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
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 600, // Reduced height
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _features.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _isAutoPlaying = false; 
                    _currentPage = index;
                  });
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                  );
                  Future.delayed(const Duration(seconds: 10), () {
                    if (mounted) setState(() => _isAutoPlaying = true);
                  });
                },
                child: _FeatureSlideCard(
                  title: _features[index]['title']!,
                  description: _features[index]['desc']!,
                  type: _features[index]['type']!,
                  isActive: _currentPage == index,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_features.length, (index) {
            return GestureDetector(
              onTap: () {
                 _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                  );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: _currentPage == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index ? AppColors.secondary : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _FeatureSlideCard extends StatefulWidget {
  final String title;
  final String description;
  final String type;
  final bool isActive;

  const _FeatureSlideCard({
    required this.title,
    required this.description,
    required this.type,
    required this.isActive,
  });

  @override
  State<_FeatureSlideCard> createState() => _FeatureSlideCardState();
}

class _FeatureSlideCardState extends State<_FeatureSlideCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isHovered || widget.isActive ? AppColors.secondary.withValues(alpha: 0.5) : const Color(0xFFE2E8F0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isHovered || widget.isActive ? 0.08 : 0.04),
              blurRadius: _isHovered || widget.isActive ? 30 : 15,
              offset: Offset(0, _isHovered || widget.isActive ? 15 : 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: const Color(0xFFFBFBFF),
                  child: Transform.scale(
                    scale: 0.95,
                    child: PhoneFrame(
                      width: 240,
                      height: 420,
                      child: _getMockContent(widget.type),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
                height: 1.3,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getMockContent(String type) {
    switch (type) {
      case 'live_exam': return const _MockLiveExam();
      case 'stats': return const _MockStats();
      case 'quiz': return const _MockQuiz();
      case 'premium_questions': return const _MockPremiumQuestions();
      case 'evaluation': return const _MockEvaluation();
      case 'leaderboard': return const _MockLeaderboard();
      default: return Container(color: Colors.white);
    }
  }
}

// --- High Fidelity Mock UI Components ---

class _MockHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  const _MockHeader(this.title, {this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.black)),
          if (icon != null) Icon(icon, size: 14, color: Colors.black),
        ],
      ),
    );
  }
}

class _MockLiveExam extends StatelessWidget {
  const _MockLiveExam();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _MockHeader('জব প্রস্তুতি', icon: Icons.notifications_none),
          const SizedBox(height: 4),
          const Text('লাইভ এক্সাম', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0095FF),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                  ),
                  child: const Text('জব প্রস্তুতি । ৪৫ তম বিসিএস', style: TextStyle(color: Colors.white, fontSize: 8)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('বাংলাদেশ বিষয়াবলী - ১০', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 10)),
                      const Text('প্রশ্ন ২০ টি - ৭ মিনিট', style: TextStyle(color: Colors.grey, fontSize: 7)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [Icon(Icons.timer_outlined, size: 10, color: Colors.red), SizedBox(width: 2), Text('00:58:44', style: TextStyle(color: Colors.red, fontSize: 8, fontWeight: FontWeight.bold))]),
                          const Text('5,200 already enrolled', style: TextStyle(color: Colors.grey, fontSize: 7)),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade100), borderRadius: BorderRadius.circular(8)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('সম্মিলিত রুটিন এবং আর্কাইভ', style: TextStyle(color: Colors.blue, fontSize: 8, fontWeight: FontWeight.bold)), Icon(Icons.chevron_right, size: 10, color: Colors.grey)]),
          ),
        ],
      ),
    );
  }
}

class _MockStats extends StatelessWidget {
  const _MockStats();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _MockHeader('প্রোফাইল'),
          Row(
            children: [
              CircleAvatar(radius: 12, backgroundColor: Colors.blue.shade100, child: const Icon(Icons.person, size: 12)),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 6, width: 50, color: Colors.grey.shade300),
                  const SizedBox(height: 2),
                  Container(height: 4, width: 70, color: Colors.grey.shade200),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade100), borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                   Container(height: 5, width: 40, color: Colors.grey.shade300),
                   Container(height: 5, width: 30, color: Colors.blue.shade300),
                ]),
                const SizedBox(height: 8),
                Container(height: 4, width: double.infinity, color: Colors.blue.shade100),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _MockQuiz extends StatelessWidget {
  const _MockQuiz();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const _MockHeader('লেভেল ১', icon: Icons.close),
          Container(height: 3, width: double.infinity, color: Colors.blue.shade100),
          const SizedBox(height: 15),
          Container(height: 8, width: 130, color: Colors.grey.shade300),
          const SizedBox(height: 15),
          ...List.generate(4, (index) => Container(
            height: 30,
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: index == 0 ? Colors.green : Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade200),
            ),
          )),
        ],
      ),
    );
  }
}

class _MockPremiumQuestions extends StatelessWidget {
  const _MockPremiumQuestions();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _MockHeader('Bangla - 14'),
          Container(height: 8, width: 100, color: Colors.grey.shade800),
          const SizedBox(height: 12),
          Container(height: 6, width: 70, color: Colors.green.shade100),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey.shade50,
            child: Column(
               children: List.generate(3, (index) => Container(height: 3, margin: const EdgeInsets.only(bottom: 3), color: Colors.grey.shade300)),
            ),
          )
        ],
      ),
    );
  }
}

class _MockEvaluation extends StatelessWidget {
  const _MockEvaluation();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const _MockHeader('মূল্যায়ন'),
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
            ),
            child: const Icon(Icons.bar_chart, size: 30, color: Colors.blue),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) => CircleAvatar(radius: 12, backgroundColor: Colors.blue.shade50)),
          )
        ],
      ),
    );
  }
}

class _MockLeaderboard extends StatelessWidget {
  const _MockLeaderboard();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const _MockHeader('বাংলা'),
          ...List.generate(5, (index) => Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Row(
              children: [
                CircleAvatar(radius: 8, backgroundColor: Colors.grey.shade100),
                const SizedBox(width: 6),
                Container(height: 5, width: 35, color: Colors.grey.shade200),
                const Spacer(),
                const Icon(Icons.workspace_premium, size: 12, color: Colors.orange),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
