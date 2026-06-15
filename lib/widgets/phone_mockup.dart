import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class PhoneMockup extends StatelessWidget {
  final bool isCentered;
  const PhoneMockup({super.key, this.isCentered = false});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final bool isMobile = screenWidth < 850;
    
    // Scale factor for mobile
    final double scale = isMobile ? (screenWidth / 600).clamp(0.5, 1.0) : 1.0;

    if (isCentered) {
      return Center(
        child: Transform.scale(
          scale: scale,
          child: SizedBox(
            width: 500,
            height: 600,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // ── Back Phone (Subject List) ──
                Positioned(
                  right: 20,
                  top: 80,
                  child: PhoneFrame(
                    width: 260,
                    height: 520,
                    child: _SubjectListView(),
                  ),
                ),
                // ── Front Phone (Main Dashboard) ──
                Positioned(
                  left: 20,
                  top: 0,
                  child: PhoneFrame(
                    width: 260,
                    height: 520,
                    child: _DashboardView(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Center(
      child: Transform.scale(
        scale: scale,
        child: Container(
          height: 600,
          width: 500,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ── Right/Back Phone (Subject List) ──
              Positioned(
                right: 70,
                top: 60,
                child: PhoneFrame(
                  width: 280,
                  height: 550,
                  child: _SubjectListView(),
                ),
              ),
              // ── Left/Front Phone (Main Dashboard) ──
              Positioned(
                left: isMobile ? 20 : -100,
                top: 0,
                child: PhoneFrame(
                  width: 280,
                  height: 550,
                  child: _DashboardView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneFrame extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  const PhoneFrame({required this.child, this.width = 280, this.height = 500});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
        border: Border.all(color: Colors.white, width: 8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Container(
          color: const Color(0xFFF8F9FA),
          child: child,
        ),
      ),
    );
  }
}

class _DashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'জব প্রস্তুতি',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black),
              ),
              Icon(Icons.notifications_none_rounded, color: Colors.black),
            ],
          ),
          const SizedBox(height: 20),
          // Live Exam Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'লাইভ এক্সাম',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black),
              ),
              Text(
                'সবগুলো',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.secondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Main Live Exam Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'জব প্রস্তুতি । ৪৫ তম বিসিএস',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'বাংলাদেশ বিষয়াবলী - ১০',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                      ),
                      const Text(
                        'প্রশ্ন ২০ টি - ৭ মিনিট',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.timer_outlined, size: 14, color: Colors.red),
                              SizedBox(width: 4),
                              Text('00:58:44', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700, fontSize: 12)),
                            ],
                          ),
                          const Flexible(
                            child: Text('5,200 already enrolled', style: TextStyle(fontSize: 9, color: Colors.grey), overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Routine Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'সম্মিলিত রুটিন এবং আর্কাইভ',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.secondary),
                ),
                Icon(Icons.chevron_right, size: 16, color: Colors.grey),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Subject Test Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'বিষয়ভিত্তিক পরীক্ষা',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.secondary),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'বাংলা, ইংরেজি, গণিত, ভূগোল সহ আরও ১৩ টি বিষয়ে পরীক্ষা দিন।',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.school, size: 40, color: AppColors.secondary),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Personal Practice
          const Text(
            'ব্যক্তিগত অনুশীলন',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _SmallCard(title: 'সামগ্রিক পরীক্ষা', icon: Icons.description_outlined, color: Colors.pink.shade100)),
              const SizedBox(width: 12),
              Expanded(child: _SmallCard(title: 'প্রশ্ন ব্যাংক', icon: Icons.chat_bubble_outline_rounded, color: Colors.purple.shade100)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  const _SmallCard({required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
            child: Icon(icon, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'বিষয়ভিত্তিক পরীক্ষা',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black),
          ),
          const SizedBox(height: 16),
          _SubjectItem(title: 'বাংলা', code: 'বাং', progress: 0.8),
          _SubjectItem(title: 'ইংরেজি', code: 'ইং', progress: 0.6),
          _SubjectItem(title: 'বাংলাদেশ বিষয়াবলী', code: 'বাবি', progress: 0.8),
          _SubjectItem(title: 'আন্তর্জাতিক বিষয়াবলী', code: 'আবি', progress: 0.8),
          _SubjectItem(title: 'ভূগোল', code: 'ভূ', progress: 0.6),
          _SubjectItem(title: 'সাধারণ বিজ্ঞান', code: 'সাবি', progress: 0.6),
        ],
      ),
    );
  }
}

class _SubjectItem extends StatelessWidget {
  final String title;
  final String code;
  final double progress;
  const _SubjectItem({required this.title, required this.code, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(4)),
            child: Text(code, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(child: Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
                    const SizedBox(width: 4),
                    const Icon(Icons.workspace_premium, size: 10, color: Colors.orange),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade100,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, size: 12, color: Colors.grey),
          const SizedBox(width: 2),
          Text('${(progress * 100).toInt()}%', style: const TextStyle(fontSize: 9, color: Colors.grey)),
        ],
      ),
    );
  }
}
