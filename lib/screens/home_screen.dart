import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/section_badge.dart';
import '../widgets/play_store_button.dart';
import '../widgets/call_button.dart';
import '../widgets/phone_mockup.dart';
import '../widgets/stat_card.dart';
import '../widgets/feature_card.dart';
import '../widgets/feature_slider.dart';
import '../widgets/guideline_card.dart';
import '../widgets/course_card.dart';
import '../widgets/app_feature_card.dart';
import '../widgets/pricing_card.dart';
import '../widgets/faq_item.dart';
import '../widgets/payment_chip.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Navbar (SliverAppBar) ──────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            elevation: 0,
            title: Row(
              children: [
                // ── Logo ──────────────────────────────────────────────────
                const _JobProstutiLogo(),

                const Spacer(),

                const SizedBox(width: 32),

                // ── Nav Links ─────────────────────────────────────────────
                const _NavLink('হোম', isActive: true),
                const SizedBox(width: 24),
                const _NavLink('ফিচার'),
                const SizedBox(width: 24),
                const _NavLink('প্যাকেজ প্ল্যান'),
                const SizedBox(width: 24),
                const _NavLink('ব্লগ'),
                const SizedBox(width: 24),
                const _NavLink('ডাউনলোড অ্যাপ'),

                const SizedBox(width: 32),

                // ── Sign In Button ─────────────────────────────────────────
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'সাইন ইন / আপ',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Hero Section ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.primaryDark,
              padding: const EdgeInsets.only(left: 170, right: 20, top: 30, bottom: 80),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── Left Side: Text and Buttons ──
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'জব প্রস্তুতি\nঘরে বসেই চাকরির\nপূর্ণাঙ্গ প্রস্তুতি',
                          style: TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.1,
                            fontFamily: 'Hind Siliguri',
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'বিসিএস, ব্যাংক, প্রাইমারি, শিক্ষক নিবন্ধন (NTRCA), সহকারী\nজজ সহ সকল চাকরির প্রস্তুতি হবে এক অ্যাপেই।',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            height: 1.6,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Row(
                          children: const [
                            PlayStoreButton(),
                            SizedBox(width: 16),
                            CallButton(),
                          ],
                        ),
                        const SizedBox(height: 48),
                        Row(
                          children: [
                            // Avatar overlap group
                            SizedBox(
                              width: 100,
                              height: 40,
                              child: Stack(
                                children: [
                                  Positioned(left: 0, child: _UserAvatar(index: 0)),
                                  Positioned(left: 25, child: _UserAvatar(index: 1)),
                                  Positioned(left: 50, child: _UserAvatar(index: 2)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.star, color: AppColors.accent, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              '৪.৩',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: Colors.white24,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              '৯ লাখ+ ডাউনলোড',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Removed large spacer to pull mockup closer to text
                  // ── Right Side: Phone Mockup ──
                  const Expanded(
                    flex: 2,
                    child: PhoneMockup(),
                  ),
                ],
              ),
            ),
          ),

          // ── Stats Section ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 80),
              child: Column(
                children: [
                  const SectionBadge(title: 'পরিসংখ্যান'),
                  const SizedBox(height: 24),
                  const Text(
                    'এক নজরে জব প্রস্তুতি',
                    style: TextStyle(
                      fontSize: 40, 
                      fontWeight: FontWeight.w900, 
                      color: Color(0xFF0F172A),
                      fontFamily: 'Hind Siliguri',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '৯ লাখ+ চাকরী প্রত্যাশী বিশ্বাস রেখেছে জব প্রস্তুতির উপর',
                    style: TextStyle(
                      color: Color(0xFF0EA5E9), // Blue text from screenshot
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: Icon(Icons.school_rounded, color: AppColors.secondary, size: 36),
                          number: '২০+',
                          label: 'লাইভ কোর্স',
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: StatCard(
                          icon: Icon(Icons.assignment_turned_in_rounded, color: Colors.orange, size: 36),
                          number: '১ লক্ষ+',
                          label: 'ব্যাখ্যাসহ প্রশ্ন',
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: StatCard(
                          icon: Icon(Icons.menu_book_rounded, color: Colors.blue, size: 36),
                          number: '৩০০+',
                          label: 'টপিক',
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: StatCard(
                          icon: Icon(Icons.download_for_offline_rounded, color: AppColors.secondary, size: 36),
                          number: '৯ লাখ+',
                          label: 'ডাউনলোড',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Features Section ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 80),
              child: Column(
                children: [
                  const SectionBadge(title: 'অ্যাপ ফিচার'),
                  const SizedBox(height: 24),
                  const Text(
                    'এক অ্যাপ, সব সমাধান',
                    style: TextStyle(
                      fontSize: 40, 
                      fontWeight: FontWeight.w900, 
                      color: Color(0xFF0F172A),
                      fontFamily: 'Hind Siliguri',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'সহজ সুন্দর ডিজাইনে প্রস্তুতি হবে ঘরে বসেই',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Small blue underline like in the screenshot
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Color(0xFF0095FF),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 60),
                  const FeatureSlider(),
                ],
              ),
            ),
          ),

          // ── Courses Section ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFFF8FAFC),
              padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 80),
              child: Column(
                children: [
                  const SectionBadge(title: 'কোর্স সমূহ'),
                  const SizedBox(height: 24),
                  const Text(
                    'আমাদের কোর্স সমূহ',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                      fontFamily: 'Hind Siliguri',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'বিসিএস, ব্যাংক, প্রাইমারি, শিক্ষক নিবন্ধন, সহকারী জজ সহ সকল চাকরির প্রস্তুতি কোর্স',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0095FF),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Row(
                    children: const [
                      Expanded(
                        child: CourseCard(
                          imagePath: '',
                          title: 'বিসিএস প্রস্তুতি ১২০ দিন',
                          description: 'বিসিএস প্রস্তুতি ১২০ দিন কোর্সটি ডিজাইন করা হয়েছে পুরাতন বা নতুন সবাইকে সবার জন্য...',
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        child: CourseCard(
                          imagePath: '',
                          title: 'বিসিএস প্রস্তুতি ৬ মাস',
                          description: 'চাকরির বা অনার্স ৩য় বর্ষ বা ফাইনাল ইয়ারের ছাত্র, তবে ‘বিসিএস প্রস্তুতি ৬ মাস’ কোর্সটি আপনার জন্যই।',
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        child: CourseCard(
                          imagePath: '',
                          title: 'প্রাইমারি প্রশ্ন ব্যাংক',
                          description: 'প্রাথমিক শিক্ষক নিয়োগ পরীক্ষার বিগত সকল বছরের ব্যাখ্যা সহ প্রশ্নে সাজানো প্রাইমারি প্রশ্ন ব্যাংক কোর্স।',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: const [
                      Expanded(
                        child: CourseCard(
                          imagePath: '',
                          title: 'ব্যাংক জব সলিউশন',
                          description: 'ব্যাংক প্রিলি পরীক্ষার বিগত সকল বছরের ব্যাখ্যা সহ প্রশ্নে সাজানো ব্যাংক জব সলিউশন সেকশন।',
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        child: CourseCard(
                          imagePath: '',
                          title: 'সকল জব সলিউশন',
                          description: 'ব্যাখ্যাসহ প্রতিদিন আপডেটেড জব সলিউশন মাসে মাসে জব সলিউশন কেনার দিন শেষ...',
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        child: CourseCard(
                          imagePath: '',
                          title: 'শিক্ষক নিবন্ধন (NTRCA) প্রস্তুতি | ৭০ দিন',
                          description: 'কোর্সটি সাজানো হয়েছে যারা বছরব্যাপী শিক্ষক নিবন্ধন (NTRCA) এর প্রস্তুতি নিতে চাচ্ছে তাদের জন্য।',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  // "See All Courses" Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Text(
                        'সব কোর্স দেখুন',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      label: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0095FF),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── App Features Grid ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 80),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0095FF),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 60),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1.4,
                    children: const [
                      AppFeatureCard(
                        icon: Icons.podcasts_rounded,
                        title: 'প্রতিযোগিতামূলক লাইভ পরীক্ষা',
                        description: 'হাজারো প্রতিযোগীর সাথে ঘরে বসেই লাইভ পরীক্ষা দিয়ে যাচাই করা যাবে নিজের প্রস্তুতি',
                      ),
                      AppFeatureCard(
                        icon: Icons.menu_book_rounded,
                        title: 'বিষয়ভিত্তিক মডেল টেস্ট',
                        description: 'বিষয়ভিত্তিক পার্সোনালাইসড আনলিমিটেড মডেল টেস্ট। নিজেই সেট করা যাবে পরীক্ষার সময় এবং নম্বর',
                      ),
                      AppFeatureCard(
                        icon: Icons.auto_stories_rounded,
                        title: 'অধ্যায়ভিত্তিক অনুশীলন',
                        description: '৩০০+ টপিক সাব টপিকের উপর পড়াশোনা ও রিভিশনের সুযোগ',
                      ),
                      AppFeatureCard(
                        icon: Icons.contact_support_outlined,
                        title: 'ব্যাখ্যা সহ প্রিমিয়াম প্রশ্নব্যাংক',
                        description: '১ লক্ষের অধিক ব্যাখ্যাসহ প্রিমিয়াম প্রশ্ন। প্রতিদিনেই যুক্ত হচ্ছে নতুন নতুন সব প্রশ্ন।',
                      ),
                      AppFeatureCard(
                        icon: Icons.assignment_outlined,
                        title: 'পূর্ণাঙ্গ প্রশ্নব্যাংক',
                        description: 'চাকরী পরীক্ষার পর দ্রুততম সময়ে ব্যাখ্যাসহ সমাধান আপলোড। বারবার জব সলিউশন কেনা থেকে মুক্তি',
                      ),
                      AppFeatureCard(
                        icon: Icons.alt_route_rounded,
                        title: 'কমপ্লিট বিসিএস গাইডলাইন',
                        description: '৩৫ - ৪৫ বিসিএস প্রশ্ন এনালাইসি, সাবজেক্ট ভিত্তিক পূর্ণাঙ্গ গাইডলাইন',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Guideline Section ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF020617), // Near black navy for separation
              padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 80),
              child: Column(
                children: [
                  // Free Resource Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.shade400, width: 1),
                    ),
                    child: const Text(
                      'ফ্রি রিসোর্স',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'বিষয়ভিত্তিক গাইডলাইন',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontFamily: 'Hind Siliguri',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'বিসিএস ৩৫-৪৫ পর্যন্ত টপিকভিত্তিক প্রশ্ন বিশ্লেষণ ও হিটম্যাপ — সম্পূর্ণ ফ্রি',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () {},
                    label: const Text('সব গাইডলাইন দেখুন'),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFFBBF24), // Gold/Amber
                      textStyle: const TextStyle(fontWeight: FontWeight.w700, decoration: TextDecoration.underline),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Row(
                    children: const [
                      Expanded(
                        child: GuidelineCard(
                          title: 'বিসিএস বাংলা গাইডলাইন',
                          description: 'বাংলা ভাষা ও সাহিত্যের হিটম্যাপ বিশ্লেষণ, ৪৬ জন গুরুত্বপূর্ণ সাহিত্যিক ও প্রস্তুতি কৌশল।',
                          tags: ['বাংলা ভাষা', 'সাহিত্য'],
                          imagePath: '',
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        child: GuidelineCard(
                          title: 'বিসিএস ইংরেজি গাইডলাইন',
                          description: 'English Language & Literature এর হিটম্যাপ, গুরুত্বপূর্ণ লেখক ও অধ্যায়ন কৌশল।',
                          tags: ['English Language', 'Literature'],
                          imagePath: '',
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        child: GuidelineCard(
                          title: 'বাংলাদেশ বিষয়াবলী গাইডলাইন',
                          description: 'ইতিহাস, সংবিধান ও সাম্প্রতিক বাংলাদেশের সম্পূর্ণ টপিকভিত্তিক হিটম্যাপ।',
                          tags: ['ইতিহাস', 'সংবিধান', 'মুক্তিযুদ্ধ', 'অর্থনীতি', 'সাম্প্রতিক'],
                          imagePath: '',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Horizontal Blue Divider
          SliverToBoxAdapter(
            child: Container(
              height: 1,
              width: double.infinity,
              color: Colors.blue.withValues(alpha: 0.3),
            ),
          ),

          // ── Pricing Section ───────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF0F172A), // Deep Navy Blue for separation
              padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 80),
              child: Column(
                children: [
                  // Package Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.shade400, width: 1),
                    ),
                    child: const Text(
                      'প্যাকেজ',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'সুলভ মূল্য, সব সময়',
                    style: TextStyle(
                      fontSize: 40, 
                      fontWeight: FontWeight.w900, 
                      color: Colors.white,
                      fontFamily: 'Hind Siliguri',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'সুলভ মূল্যে সেরা প্রস্তুতি নিশ্চিতে সাজানো আমাদের সব প্রিমিয়াম প্যাকেজ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0095FF),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Row(
                    children: const [
                      Expanded(
                        child: PricingCard(
                          title: '১ মাসের ফুল অ্যাপ এক্সেস',
                          price: '৳১৪৯',
                          description: '৩০ দিনের জন্য বিসিএস, ব্যাংক, প্রাইমারি, শিক্ষক নিবন্ধন (NTRCA) সহ আপ্প এর স...',
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        child: PricingCard(
                          title: '৩ মাসের ফুল অ্যাপ এক্সেস',
                          price: '৳২৯৯',
                          description: '৯০ দিনের জন্য বিসিএস, ব্যাংক, প্রাইমারি, শিক্ষক নিবন্ধন (NTRCA) সহ আপ্প এর স...',
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        child: PricingCard(
                          title: '৬ মাসের ফুল অ্যাপ এক্সেস',
                          price: '৳৪৯৯',
                          description: '১৮০ দিনের জন্য বিসিএস, ব্যাংক, প্রাইমারি, শিক্ষক নিবন্ধন (NTRCA) সহ আপ্প এর স...',
                          isPopular: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── FAQ Section ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.lightBg,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
              child: Column(
                children: [
                  const SectionBadge(title: 'সচরাচর জিজ্ঞাসা'),
                  const Text(
                    'সচরাচর জিজ্ঞাসাসমূহ',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  const SizedBox(height: 32),
                  const FaqItem(
                    question: 'জব প্রস্তুতি অ্যাপটি কি? কাদের জন্য এই অ্যাপ?',
                    answer: 'জব প্রস্তুতি একটি চাকরি পরীক্ষার প্রস্তুতি প্ল্যাটফর্ম যেখানে বিসিএস, ব্যাংক, প্রাইমারি সহ সকল সরকারি চাকরির জন্য প্রস্তুতি নেওয়া যায়। যেকোনো চাকরি প্রত্যাশী এই অ্যাপ ব্যবহার করতে পারবেন।',
                  ),
                  const SizedBox(height: 12),
                  const FaqItem(
                    question: 'আমি এখনও ছাত্র, আমি কিভাবে জব প্রস্তুতি শুরু করব?',
                    answer: 'ছাত্র অবস্থা থেকেই প্রস্তুতি শুরু করা যায়। আমাদের গাইডলাইন সেকশন ও টপিক-ভিত্তিক অনুশীলন দিয়ে শুরু করুন এবং ধীরে ধীরে মডেল টেস্ট ও লাইভ পরীক্ষায় অংশগ্রহণ করুন।',
                  ),
                  const SizedBox(height: 12),
                  const FaqItem(
                    question: 'জব প্রস্তুতি অ্যাপ কিভাবে ইউজ করলে সবচেয়ে ভাল করতে পারব?',
                    answer: 'প্রতিদিন নিয়মিত ডেইলি মডেল টেস্ট দিন, টপিক-ভিত্তিক অনুশীলন করুন এবং লাইভ পরীক্ষায় অংশ নিন। মেধা তালিকায় নিজের অবস্থান দেখে দুর্বলতা চিহ্নিত করুন।',
                  ),
                ],
              ),
            ),
          ),

          // ── CTA Section ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.navyDark,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              child: Column(
                children: [
                  const SectionBadge(title: 'জব প্রস্তুতি অ্যাপ'),
                  const SizedBox(height: 16),
                  const Text(
                    'স্মার্ট প্রস্তুতি শুরু করুন আজই',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Download our mobile app, start learning from today',
                    style: TextStyle(color: Colors.white60),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      PlayStoreButton(),
                      SizedBox(width: 12),
                      CallButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Footer ────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.navy,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    '© 2026 Job Prostuti. All rights reserved.',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    children: const [
                      PaymentChip(name: 'Visa'),
                      PaymentChip(name: 'Mastercard'),
                      PaymentChip(name: 'bKash'),
                      PaymentChip(name: 'Nagad'),
                      PaymentChip(name: 'Rocket'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final int index;
  const _UserAvatar({required this.index});

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.blue.shade300,
      Colors.pink.shade300,
      Colors.orange.shade300,
    ];
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: colors[index % colors.length],
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryDark, width: 2),
      ),
      child: const Icon(Icons.person, size: 24, color: Colors.white),
    );
  }
}

// ── Logo Widget ───────────────────────────────────────────────────────────────
//
// Design concept: Minimalist professional icon with stacked typography.
// Features a "menu_book" icon in a rounded indigo container representing
// growth and learning, paired with a clean bold wordmark.
//
class _JobProstutiLogo extends StatelessWidget {
  const _JobProstutiLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.menu_book_rounded,
            color: AppColors.secondary,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Job Prostuti',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                height: 1.1,
              ),
            ),
            Text(
              'LEARN & GROW',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                height: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final bool isActive;
  const _NavLink(this.label, {this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
        color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.8),
      ),
    );
  }
}