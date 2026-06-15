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
  final PageController _pageController = PageController(viewportFraction: 0.333);
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
      'title': 'কোর্স ক্যাটাগরি',
      'desc': 'বিসিএস, ব্যাংক, প্রাইমারি সহ সকল চাকরির প্রস্তুতি কোর্স',
      'type': 'categories'
    },
    {
      'title': 'পরীক্ষার রুটিন',
      'desc': 'রুটিন অনুসারে সাজানো প্রতিটি কোর্স',
      'type': 'routine'
    },
    {
      'title': 'বিষয়ভিত্তিক অনুশীলন / পরীক্ষা',
      'desc': 'টপিক সাব টপিক অনুসারে সাজানো প্রতিটি বিষয়',
      'type': 'subject_test'
    },
    {
      'title': 'কুইজ কুইজ',
      'desc': 'প্রস্তুতি হবে মজায় মজায়, প্রস্তুতি খেলায় খেলায়',
      'type': 'quiz'
    },
    {
      'title': 'পরীক্ষার মূল্যায়ন',
      'desc': 'পরীক্ষার মার্কস এর বিষয়ভিত্তিক মূল্যায়ন',
      'type': 'evaluation'
    },
    {
      'title': 'ব্যাখ্যা সহ প্রিমিয়াম প্রশ্ন পত্র',
      'desc': 'বিস্তারিত ব্যাখ্যা সহ সাজানো প্রতিটি প্রশ্ন',
      'type': 'premium_paper'
    },
    {
      'title': 'লেকচার অ্যান্ড নোটস',
      'desc': 'গোছানো প্রস্তুতি নিশ্চিতে সাজানো প্রতিটি সেকশন',
      'type': 'lecture_notes'
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
          height: 650, 
          child: PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (int page) {
              setState(() => _currentPage = page);
            },
            itemCount: _features.length,
            itemBuilder: (context, index) {
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
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
                  child: AnimatedScale(
                    scale: _currentPage == index ? 1.0 : 0.9,
                    duration: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: _FeatureSlideCard(
                        title: _features[index]['title']!,
                        description: _features[index]['desc']!,
                        type: _features[index]['type']!,
                        isActive: _currentPage == index,
                      ),
                    ),
                  ),
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
                setState(() => _isAutoPlaying = false);
                _pageController.animateToPage(index, 
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
                  height: 8,
                  width: _currentPage == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? AppColors.secondary : Colors.grey.shade300,
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
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered || widget.isActive ? AppColors.secondary : const Color(0xFFE2E8F0),
            width: _isHovered || widget.isActive ? 2.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isHovered || widget.isActive ? 0.08 : 0.03),
              blurRadius: _isHovered || widget.isActive ? 30 : 15,
              offset: Offset(0, _isHovered || widget.isActive ? 15 : 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: const Color(0xFFFBFBFF),
                  child: Center(
                    child: Transform.scale(
                      scale: 0.95, 
                      child: PhoneFrame(
                        width: 280, 
                        height: 520, 
                        child: _getMockContent(widget.type),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E293B),
                fontFamily: 'Hind Siliguri',
              ),
            ),
            const SizedBox(height: 4),
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
    // FIXED: Removed all 'const' keywords to prevent compilation errors
    switch (type) {
      case 'live_exam': return SingleChildScrollView(child: _MockLiveExam());
      case 'categories': return SingleChildScrollView(child: _MockCategories());
      case 'routine': return SingleChildScrollView(child: _MockRoutine());
      case 'subject_test': return SingleChildScrollView(child: _MockSubjectTest());
      case 'quiz': return SingleChildScrollView(child: _MockQuiz());
      case 'evaluation': return SingleChildScrollView(child: _MockEvaluation());
      case 'premium_paper': return SingleChildScrollView(child: _MockPremiumPaper());
      case 'lecture_notes': return SingleChildScrollView(child: _MockLectureNotes());
      case 'leaderboard': return SingleChildScrollView(child: _MockLeaderboard());
      default: return Container(color: Colors.white);
    }
  }
}

// --- High Fidelity Mock UI Components ---

class _MockSubjectTest extends StatelessWidget {
  const _MockSubjectTest();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [Icon(Icons.arrow_back, size: 14), SizedBox(width: 8), Text('বিষয়ভিত্তিক পরীক্ষা', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))]),
          const SizedBox(height: 16),
          _SubjectItem('বাং', 'বাংলা', Colors.blue.shade50, Colors.blue, hasCrown: true),
          _SubjectItem('ইং', 'ইংরেজি', Colors.red.shade50, Colors.red, hasCrown: true),
          _SubjectItem('বাবি', 'বাংলাদেশ বিষয়াবলী', Colors.green.shade50, Colors.green),
          _SubjectItem('আবি', 'আন্তর্জাতিক বিষয়াবলী', Colors.purple.shade50, Colors.purple),
          _SubjectItem('ভূ', 'ভূগোল', Colors.cyan.shade50, Colors.cyan),
        ],
      ),
    );
  }

  Widget _SubjectItem(String code, String title, Color bgColor, Color textColor, {bool hasCrown = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(8), 
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 30, 
            height: 30,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4)), 
            child: Center(child: Text(code, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor))), 
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Row(
                  children: [
                    Flexible(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis)), 
                    if (hasCrown) ...[
                      const SizedBox(width: 3),
                      const Icon(Icons.workspace_premium, size: 12, color: Colors.orange),
                    ]
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4, 
                        decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(2)),
                        child: Align(alignment: Alignment.centerLeft, child: Container(width: 50, decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(2)))),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text('৮০%', style: TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold)), 
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 12, color: Colors.grey),
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
          const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Flexible(child: Text('বিসিএস প্রস্তুতি', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15), overflow: TextOverflow.ellipsis)), Icon(Icons.notifications_none, size: 14)]),
          const SizedBox(height: 12),
          const Text('লাইভ এক্সাম', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade100)),
            child: Column(
              children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), width: double.infinity, decoration: const BoxDecoration(color: Color(0xFF0095FF), borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))), child: const Text('বিসিএস প্রস্তুতি । ৪৫ তম বিসিএস', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(child: Text('বাংলাদেশ বিষয়াবলী - ১০', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12), overflow: TextOverflow.ellipsis)),
                      const Text('প্রশ্ন ২০ টি - ৭ মিনিট', style: TextStyle(color: Colors.grey, fontSize: 9)),
                      const SizedBox(height: 12),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Icon(Icons.timer_outlined, size: 12, color: Colors.red), SizedBox(width: 4), Text('00:58:44', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold))]), const Flexible(child: Text('5,200 enrolled', style: TextStyle(color: Colors.grey, fontSize: 9), overflow: TextOverflow.ellipsis))]),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Flexible(child: Text('লেভেল ১', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14), overflow: TextOverflow.ellipsis)),
              Icon(Icons.close, size: 16),
            ],
          ),
          const SizedBox(height: 10),
          const Center(child: Text('1 of 20', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(2)),
                  child: Align(alignment: Alignment.centerLeft, child: Container(width: 40, decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(2)))),
                ),
              ),
              const SizedBox(width: 8),
              const Text('20s', style: TextStyle(fontSize: 10, color: Colors.teal, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          const Flexible(child: Text('বাংলাদেশের রাজধানী নিম্নের কোনটি?', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis)),
          const SizedBox(height: 12),
          _QuizOption('ঢাকা', isSelected: true),
          _QuizOption('বরিশাল'),
          _QuizOption('খুলনা'),
          _QuizOption('সিলেট'),
        ],
      ),
    );
  }

  Widget _QuizOption(String text, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF64C800) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isSelected ? const Color(0xFF64C800) : Colors.grey.shade100),
      ),
      child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87)),
    );
  }
}

class _MockEvaluation extends StatelessWidget {
  const _MockEvaluation();
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: const [
                Icon(Icons.arrow_back, size: 12),
                SizedBox(width: 4),
                Flexible(child: Text('৪৫ বিসিএস চূড়ান্ত মডেল টেস্ট - ০৫', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: Column(
              children: [
                const Flexible(child: Text('৪৫ বিসিএস চূড়ান্ত মডেল টেস্ট - ০৫', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10), overflow: TextOverflow.ellipsis)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StatItem('পরীক্ষার্থী', '872'),
                    _StatItem('উত্তীর্ণ', '89', sub: '[10%]'),
                    _StatItem('পজিশন', '10', hasCheck: true),
                    _StatItem('কাট মার্ক', '118.0'),
                    _StatItem('সর্বোচ্চ', '156.0'),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Expanded(flex: 2, child: Text('#', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold))),
                    Expanded(flex: 3, child: Text('মোট', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold))),
                    Expanded(flex: 3, child: Text('সঠিক', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.teal))),
                    Expanded(flex: 3, child: Text('ভুল', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.red))),
                    Expanded(flex: 3, child: Text('মার্কস', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.blue))),
                  ],
                ),
                const SizedBox(height: 8),
                _ResultRow('ফলাফল', '200', '157', '34', '140.0', '78%', '17%', '70%'),
                _ResultRow('আন্তর্জাতিক', '20', '17', '2', '16.00', '85%', '10%', '80%'),
                _ResultRow('বাংলাদেশ', '30', '25', '5', '22.50', '83%', '17%', '75%'),
              ],
            ),
          )
        ],
    );
  }

  Widget _StatItem(String label, String value, {String? sub, bool hasCheck = false}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 5, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: Text(value, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900), overflow: TextOverflow.ellipsis)),
            if (hasCheck) const Icon(Icons.check_circle, size: 8, color: Colors.teal),
          ],
        ),
        if (sub != null) Text(sub, style: const TextStyle(fontSize: 5, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _ResultRow(String title, String total, String correct, String wrong, String marks, String pCorrect, String pWrong, String pMarks) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(title, style: const TextStyle(fontSize: 7, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
          Expanded(flex: 3, child: Text(total, style: const TextStyle(fontSize: 7, fontWeight: FontWeight.w900))),
          Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(correct, style: const TextStyle(fontSize: 7, fontWeight: FontWeight.w900, color: Colors.teal)), Text(pCorrect, style: const TextStyle(fontSize: 5, color: Colors.grey))])),
          Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(wrong, style: const TextStyle(fontSize: 7, fontWeight: FontWeight.w900, color: Colors.red)), Text(pWrong, style: const TextStyle(fontSize: 5, color: Colors.grey))])),
          Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(marks, style: const TextStyle(fontSize: 7, fontWeight: FontWeight.w900, color: Colors.blue)), Text(pMarks, style: const TextStyle(fontSize: 5, color: Colors.grey))])),
        ],
      ),
    );
  }
}

class _MockLectureNotes extends StatelessWidget {
  const _MockLectureNotes();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [Icon(Icons.arrow_back, size: 14), SizedBox(width: 8), Text('লেকচার এন্ড নোটস', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))]),
          const SizedBox(height: 16),
          _NoteItem('High Frequency Vocabulary', '18 Mar 2024'),
          _NoteItem('BCS Guideline', '02 Jan 2024'),
          _NoteItem('Routine (PDF)', '18 Apr 2024'),
          _NoteItem('46 BCS Final Model Test PDF', '19 Apr 2024'),
          _NoteItem('Daily Star Editorial', '19 Apr 2024'),
        ],
      ),
    );
  }

  Widget _NoteItem(String title, String updateDate) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF), 
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1E293B))),
                const SizedBox(height: 4),
                Text('Last Update: $updateDate', style: const TextStyle(fontSize: 9, color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}

class _MockCategories extends StatelessWidget {
  const _MockCategories();
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Flexible(child: Text('বিসিএস প্রস্তুতি', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.black), overflow: TextOverflow.ellipsis)),
              Row(
                children: [
                  Icon(Icons.search, size: 13, color: Colors.black54),
                  SizedBox(width: 6),
                  Icon(Icons.notifications_none, size: 13, color: Colors.black54),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('কোর্স ক্যাটাগরি', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 10)),
              Text('সকল কোর্স', style: TextStyle(color: Colors.blue, fontSize: 9, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 2.2,
            children: [
              _CategoryItem('বিসিএস', Colors.red.shade50, Colors.red),
              _CategoryItem('ব্যাংক', Colors.green.shade50, Colors.green),
              _CategoryItem('প্রাইমারি', Colors.orange.shade50, Colors.orange),
              _CategoryItem('জব সলিউশন', Colors.blue.shade50, Colors.blue),
              _CategoryItem('শিক্ষক নিয়োগ', Colors.purple.shade50, Colors.purple),
              _CategoryItem('PSC & Others', Colors.teal.shade50, Colors.teal),
            ],
          ),
          const SizedBox(height: 12),
          const Text('প্র্যাকটিস', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 10)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('বিষয়ভিত্তিক পরীক্ষা', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.blue)),
                      SizedBox(height: 2),
                      Text('যত খুশি পরীক্ষা দিন...', style: TextStyle(fontSize: 7, color: Colors.grey)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward, size: 10, color: Colors.blue),
              ],
            ),
          )
        ],
    );
  }

  Widget _CategoryItem(String title, Color bgColor, Color iconColor) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.grey.shade100)),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          Container(width: 18, height: 18, decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle), child: Icon(Icons.school, size: 9, color: iconColor)),
          const SizedBox(width: 4),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 7, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}

class _MockPremiumPaper extends StatelessWidget {
  const _MockPremiumPaper();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(Icons.arrow_back, size: 16), Text('Bangla - 14', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), Icon(Icons.more_horiz, size: 16)]),
          const SizedBox(height: 16),
          const Text('১০) জসীমউদ্দীনের শ্রেষ্ঠ কাহিনী কাব্য কোনটি?', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Colors.black)),
          const SizedBox(height: 12),
          _OptionItem('ক) নকশী কাঁথার মাঠ', isCorrect: true),
          _OptionItem('খ) সোজন বাদিয়ার ঘাট'),
          _OptionItem('গ) সকিনা'),
          _OptionItem('ঘ) রাখালী'),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(12, 12, 36, 12),
                decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10)),
                child: const Text(
                  'ব্যাখ্যা : নকশী কাঁথার মাঠ ১৯২৯ খ্রিষ্টাব্দে প্রকাশিত বাংলা সাহিত্যের একটি অনবদ্য আখ্যানকাব্য। নকশী কাঁথার মাঠ কাব্যোপন্যাসটি রুপাই ও সাজু নামক দুই গ্রামীণ যুবক-যুবতীর অভিনব প্রেমের করুণ কাহিনী। সোজন বাদিয়ার ঘাট বাংলা সাহিত্যের অন্যতম কবি জসীম উদ্দীনের অত্যন্ত সুপরিচিত একটি কাব্যগ্রন্থ। গ্রাম বাংলার অপূর্ব অনবদ্য রূপকল্প এই কাব্যগ্রন্থটি ১৯৩৩ সালে প্রথম প্রকাশিত হয়। সোজন বাদিয়ার...',
                  style: TextStyle(fontSize: 10, color: Colors.black87, height: 1.5),
                ),
              ),
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Color(0xFFE1F0FF), shape: BoxShape.circle),
                  child: const Icon(Icons.cloud_download_rounded, size: 18, color: Color(0xFF0F172A)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _OptionItem(String text, {bool isCorrect = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isCorrect ? Colors.green.shade200 : Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Icon(isCorrect ? Icons.radio_button_checked : Icons.radio_button_off, size: 14, color: isCorrect ? Colors.green : Colors.grey.shade300),
          const SizedBox(width: 10),
          Text(text, style: TextStyle(fontSize: 11, color: isCorrect ? Colors.green.shade700 : Colors.black54, fontWeight: isCorrect ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}

class _MockQuestionBank extends StatelessWidget {
  const _MockQuestionBank();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [Icon(Icons.arrow_back, size: 16), SizedBox(width: 8), Text('প্রশ্ন ব্যাংক', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))]),
          const SizedBox(height: 16),
          ...['বিসিএস প্রশ্নব্যাংক', 'ব্যাংক প্রশ্নব্যাংক', 'প্রাইমারি প্রশ্নব্যাংক'].map((t) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade100)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(t, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)), const Icon(Icons.chevron_right, size: 14, color: Colors.grey)]),
          )).toList(),
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
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [Icon(Icons.arrow_back, size: 16), SizedBox(width: 8), Text('বাংলা', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))]),
          const SizedBox(height: 8),
          const Text('সর্বমোট নাম্বার: ২০  |  পরীক্ষার্থী: ১২০  |  পাস: ৮০', style: TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _LeaderboardItem('Meraj', '1st', Colors.purple, isMe: false),
          _LeaderboardItem('Hasan (you)', '2nd', Colors.blue, isMe: true),
          _LeaderboardItem('Rahat', '3rd', Colors.blue.shade200, isMe: false),
          _LeaderboardItem('Anis', '4th', Colors.transparent, isMe: false),
          _LeaderboardItem('Sabbir', '4th', Colors.transparent, isMe: false),
        ],
      ),
    );
  }

  Widget _LeaderboardItem(String name, String rank, Color badgeColor, {required bool isMe}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(10), 
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Flexible(child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black), overflow: TextOverflow.ellipsis)),
                const SizedBox(height: 2),
                const Text('প্রাপ্ত মার্কস: ২০', style: TextStyle(fontSize: 7, color: Colors.grey, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          if (rank != '4th')
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: badgeColor.withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(0, 2))],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [badgeColor.withValues(alpha: 0.7), badgeColor],
                ),
              ),
              child: Center(child: Text(rank, style: const TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold))),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(rank, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
        ],
      ),
    );
  }
}

class _MockRoutine extends StatelessWidget {
  const _MockRoutine();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(Icons.arrow_back, size: 14), Text('পরীক্ষার রুটিন', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), Icon(Icons.info_outline, size: 14)]),
          const SizedBox(height: 16),
          Row(
            children: ['রুটিন', 'আর্কাইভ', 'ফলাফল'].map((t) => Container(margin: const EdgeInsets.only(right: 6), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: t == 'রুটিন' ? Colors.blue : Colors.blue.shade50, borderRadius: BorderRadius.circular(10)), child: Text(t, style: TextStyle(color: t == 'রুটিন' ? Colors.white : Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)))).toList(),
          ),
          const SizedBox(height: 20),
          const Text('২৩ এপ্রিল ২০২৪, মঙ্গলবার', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade100)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Weekly BCS Exam - 19', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 6),
                Row(children: const [Icon(Icons.circle, size: 6, color: Colors.green), SizedBox(width: 6), Text('Running', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold))]),
                const SizedBox(height: 12),
                Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(6)), child: const Text('পরীক্ষা দিন', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))), const SizedBox(width: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(6)), child: const Text('সিলেবাস', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)))]),
              ],
            ),
          )
        ],
      ),
    );
  }
}
