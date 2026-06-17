import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import 'login_screen.dart';
import '../app/theme.dart';
import '../widgets/section_badge.dart';
import '../widgets/play_store_button.dart';
import '../widgets/call_button.dart';
import '../widgets/phone_mockup.dart';
import '../widgets/stat_card.dart';
import '../widgets/feature_slider.dart';
import '../widgets/guideline_card.dart';
import '../widgets/course_card.dart';
import '../widgets/app_feature_card.dart';
import '../widgets/pricing_slider.dart';
import '../widgets/faq_item.dart';
import '../widgets/payment_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  
  // Section offsets - recalibrated for smoother landing
  final double _heroOffset = 0;
  final double _featuresOffset = 1300;
  final double _coursesOffset = 2300;
  final double _guidelineOffset = 4500;
  final double _pricingOffset = 5800;
  final double _ctaOffset = 7200;

  void _scrollToSection(double offset) {
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutQuart,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildMobileDrawer() {
    return Drawer(
      backgroundColor: AppColors.primaryDark,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF022C22)),
            child: const Center(child: _JobProstutiLogo()),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildDrawerItem('হোম', Icons.home_rounded, () => _scrollToSection(_heroOffset)),
                _buildDrawerItem('ফিচার', Icons.featured_play_list_rounded, () => _scrollToSection(_featuresOffset)),
                _buildDrawerItem('কোর্স', Icons.school_rounded, () => _scrollToSection(_coursesOffset)),
                _buildDrawerItem('গাইডলাইন', Icons.auto_stories_rounded, () => _scrollToSection(_guidelineOffset)),
                _buildDrawerItem('প্যাকেজ প্ল্যান', Icons.payments_rounded, () => _scrollToSection(_pricingOffset)),
                _buildDrawerItem('ডাউনলোড অ্যাপ', Icons.download_rounded, () => _scrollToSection(_ctaOffset)),
                const Divider(color: Colors.white10, height: 40),
                ListTile(
                  leading: const Icon(Icons.login_rounded, color: AppColors.accent),
                  title: const Text('সাইন ইন / আপ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70, size: 20),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final double horizontalPadding = isMobile ? 20 : 100;

    return Scaffold(
      drawer: isMobile ? _buildMobileDrawer() : null,
      body: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
          // ── Navbar (SliverAppBar) ──────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            elevation: 0,
            leading: isMobile ? Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ) : null,
            title: Row(
              children: [
                // ── Logo ──────────────────────────────────────────────────
                GestureDetector(
                  onTap: () => _scrollToSection(_heroOffset),
                  child: const MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: _JobProstutiLogo(),
                  ),
                ),

                if (!isMobile) ...[
                  const Spacer(),
                  const SizedBox(width: 32),
                  // ── Nav Links ─────────────────────────────────────────────
                  _NavLink('হোম', isActive: true, onTap: () => _scrollToSection(_heroOffset)),
                  const SizedBox(width: 24),
                  _NavLink('ফিচার', onTap: () => _scrollToSection(_featuresOffset)),
                  const SizedBox(width: 24),
                  _NavLink('কোর্স', onTap: () => _scrollToSection(_coursesOffset)),
                  const SizedBox(width: 24),
                  _NavLink('গাইডলাইন', onTap: () => _scrollToSection(_guidelineOffset)),
                  const SizedBox(width: 24),
                  _NavLink('প্যাকেজ প্ল্যান', onTap: () => _scrollToSection(_pricingOffset)),
                  const SizedBox(width: 24),
                  _NavLink('ডাউনলোড অ্যাপ', onTap: () => _scrollToSection(_ctaOffset)),
                  const SizedBox(width: 32),
                ],

                if (isMobile) const Spacer(),

                // ── Sign In Button ─────────────────────────────────────────
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      elevation: 0,
                    ),
                    child: Text(
                      isMobile ? 'লগইন' : 'সাইন ইন / আপ',
                      style: const TextStyle(
                        fontSize: 14,
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
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : (Responsive.isTablet(context) ? 60 : 170),
                vertical: isMobile ? 40 : 80,
              ),
              child: Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ── Left Side: Text and Buttons ──
                  Expanded(
                    flex: isMobile ? 0 : 3,
                    child: Column(
                      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                      children: [
                        Text(
                          'জব প্রস্তুতি\nঘরে বসেই চাকরির\nপূর্ণাঙ্গ প্রস্তুতি',
                          textAlign: isMobile ? TextAlign.center : TextAlign.start,
                          style: TextStyle(
                            fontSize: isMobile ? 36 : 56,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.1,
                            fontFamily: 'Hind Siliguri',
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'বিসিএস, ব্যাংক, প্রাইমারি, শিক্ষক নিবন্ধন (NTRCA), সহকারী\nজজ সহ সকল চাকরির প্রস্তুতি হবে এক অ্যাপেই।',
                          textAlign: isMobile ? TextAlign.center : TextAlign.start,
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 18,
                            color: Colors.white70,
                            height: 1.6,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children: const [
                            PlayStoreButton(),
                            CallButton(),
                          ],
                        ),
                        const SizedBox(height: 48),
                        Row(
                          mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
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
                            const Icon(Icons.star, color: AppColors.warning, size: 20),
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

                  if (isMobile) const SizedBox(height: 60),

                  // ── Right Side: Phone Mockup ──
                  Expanded(
                    flex: isMobile ? 0 : 2,
                    child: isMobile 
                      ? Transform.scale(scale: 0.8, child: const PhoneMockup())
                      : const PhoneMockup(),
                  ),
                ],
              ),
            ),
          ),

          // ── Stats Section ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 80),
              child: Column(
                children: [
                  const SectionBadge(title: 'পরিসংখ্যান'),
                  const SizedBox(height: 24),
                  Text(
                    'এক নজরে জব প্রস্তুতি',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 28 : 40, 
                      fontWeight: FontWeight.w900, 
                      color: const Color(0xFF0F172A),
                      fontFamily: 'Hind Siliguri',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '৯ লাখ+ চাকরী প্রত্যাশী বিশ্বাস রেখেছে জব প্রস্তুতির উপর',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF0EA5E9),
                      fontSize: isMobile ? 16 : 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 60),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = isMobile ? 1 : (Responsive.isTablet(context) ? 2 : 4);
                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        childAspectRatio: isMobile ? 1.5 : 1.1,
                        children: [
                          StatCard(
                            icon: Icon(Icons.school_rounded, color: AppColors.accent, size: 36),
                            number: '২০+',
                            label: 'লাইভ কোর্স',
                          ),
                          const StatCard(
                            icon: Icon(Icons.assignment_turned_in_rounded, color: Colors.orange, size: 36),
                            number: '১ লক্ষ+',
                            label: 'ব্যাখ্যাসহ প্রশ্ন',
                          ),
                          const StatCard(
                            icon: Icon(Icons.menu_book_rounded, color: Colors.blue, size: 36),
                            number: '৩০০+',
                            label: 'টপিক',
                          ),
                          StatCard(
                            icon: Icon(Icons.download_for_offline_rounded, color: AppColors.accent, size: 36),
                            number: '৯ লাখ+',
                            label: 'ডাউনলোড',
                          ),
                        ],
                      );
                    },
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
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 80),
              child: Column(
                children: [
                  const SectionBadge(title: 'কোর্স সমূহ'),
                  const SizedBox(height: 24),
                  Text(
                    'আমাদের কোর্স সমূহ',
                    style: TextStyle(
                      fontSize: isMobile ? 28 : 40,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0F172A),
                      fontFamily: 'Hind Siliguri',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'বিসিএস, ব্যাংক, প্রাইমারি, শিক্ষক নিবন্ধন, সহকারী জজ সহ সকল চাকরির প্রস্তুতি কোর্স',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      color: const Color(0xFF64748B),
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
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: isMobile ? 1 : (Responsive.isTablet(context) ? 2 : 3),
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                    childAspectRatio: 0.85,
                    children: const [
                      CourseCard(
                        imagePath: 'assets/images/course_1.jpg',
                        title: 'বিসিএস প্রস্তুতি ১২০ দিন',
                        description: 'বিসিএস প্রস্তুতি ১২০ দিন কোর্সটি ডিজাইন করা হয়েছে পুরাতন বা নতুন সবাইকে সবার জন্য...',
                        badge: '১২০ দিনের',
                        bannerTopText: '১২০ দিনের',
                        bannerTitle: 'বিসিএস প্রস্তুতি',
                        bannerSubtitle: 'টপিক ভিত্তিক মডেল টেস্ট',
                        bannerBadge: 'সর্বমোট ৬৮ টি পরীক্ষা',
                      ),
                      CourseCard(
                        imagePath: 'assets/images/course_5.jpg',
                        title: 'শিক্ষক নিবন্ধন প্রস্তুতি',
                        description: 'বিগত বছরের শিক্ষক নিবন্ধন পরীক্ষার ব্যাখ্যা সহ সমাধান এবং পূর্ণাঙ্গ রুটিন মাফিক প্রস্তুতি।',
                        badge: '১১ তম',
                        bannerTopText: '১১ তম',
                        bannerTitle: 'শিক্ষক নিবন্ধন প্রস্তুতি',
                        bannerSubtitle: 'কলেজ, স্কুল পর্যায়ের মডেল টেস্ট',
                      ),
                      CourseCard(
                        imagePath: 'assets/images/course_3.jpg',
                        title: 'প্রাইমারি প্রশ্ন ব্যাংক',
                        description: 'প্রাথমিক শিক্ষক নিয়োগ পরীক্ষার বিগত সকল বছরের ব্যাখ্যা সহ প্রশ্নে সাজানো প্রাইমারি প্রশ্ন ব্যাংক কোর্স।',
                        bannerTopText: 'বিগত বছরের',
                        bannerTitle: 'প্রাইমারি প্রশ্ন ব্যাংক',
                        bannerSubtitle: 'সকল প্রশ্নের সাথে বিস্তারিত ব্যাখ্যা',
                      ),
                      CourseCard(
                        imagePath: 'assets/images/course_4.jpg',
                        title: '৫০ নম্বরের ডেইলি টেস্ট',
                        description: '২০০ নম্বরের আনুপাতিক হারে ২০ মিনিটেই হবে পূর্ণাঙ্গ প্রস্তুতি নিশ্চিত করুন।',
                        bannerTitle: '৫০ নম্বরের',
                        bannerSubtitle: 'ডেইলি মডেল টেস্ট',
                      ),
                      CourseCard(
                        imagePath: 'assets/images/course_6.jpg',
                        title: 'ব্যাংক জব সলিউশন',
                        description: 'ব্যাখ্যাসহ সকল ব্যাংক জব সমাধান এবং বিগত বছরের প্রশ্নপত্রের বিস্তারিত বিশ্লেষণ।',
                        bannerTopText: 'ব্যাখ্যা সহ সকল',
                        bannerTitle: 'ব্যাংক জব',
                        bannerSubtitle: 'সলিউশন',
                      ),
                      CourseCard(
                        imagePath: 'assets/images/course_2.jpg',
                        title: 'শিক্ষক নিবন্ধন (NTRCA)',
                        description: 'কোর্সটি সাজানো হয়েছে যারা বছরব্যাপী শিক্ষক নিবন্ধন (NTRCA) এর প্রস্তুতি নিতে চাচ্ছে।',
                        bannerTopText: 'বিগত বছরের',
                        bannerTitle: 'শিক্ষক নিবন্ধন',
                        bannerSubtitle: 'পরীক্ষার ব্যাখ্যা সহ সমাধান',
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
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 80),
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
                    crossAxisCount: isMobile ? 1 : (Responsive.isTablet(context) ? 2 : 3),
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: isMobile ? 1.4 : 1.2,
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
              color: AppColors.primaryDark,
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 80),
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
                  Text(
                    'বিষয়ভিত্তিক গাইডলাইন',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 28 : 40,
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
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: isMobile ? 1 : (Responsive.isTablet(context) ? 2 : 3),
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                    childAspectRatio: isMobile ? 1.0 : 0.8,
                    children: const [
                      GuidelineCard(
                        title: 'বিসিএস বাংলা গাইডলাইন',
                        description: 'বাংলা ভাষা ও সাহিত্যের হিটম্যাপ বিশ্লেষণ, ৩৬ জন গুরুত্বপূর্ণ সাহিত্যিক ও প্রস্তুতি কৌশল।',
                        tags: ['বাংলা ভাষা', 'সাহিত্য', 'হিটম্যাপ'],
                        imagePath: '',
                        marks: '৩৫',
                        accentColor: Colors.orange,
                      ),
                      GuidelineCard(
                        title: 'বিসিএস ইংরেজি গাইডলাইন',
                        description: 'English Language & Literature-এর হিটম্যাপ, গুরুত্বপূর্ণ লেখক ও অধ্যয়ন কৌশল।',
                        tags: ['English', 'Literature', 'Grammar'],
                        imagePath: '',
                        marks: '৩৫',
                        accentColor: Colors.blue,
                      ),
                      GuidelineCard(
                        title: 'বাংলাদেশ বিষয়াবলী গাইডলাইন',
                        description: 'ইতিহাস, সংবিধান ও সাম্প্রতিক বাংলাদেশের সম্পূর্ণ টপিকভিত্তিক হিটম্যাপ।',
                        tags: ['ইতিহাস', 'সংবিধান', 'মুক্তিযুদ্ধ', 'অর্থনীতি', 'সাম্প্রতিক'],
                        imagePath: '',
                        marks: '৩০',
                        accentColor: Colors.green,
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
              color: AppColors.primaryDark, // Professional Green Background
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 80),
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
                  Text(
                    'সুলভ মূল্য, সব সময়',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 28 : 40, 
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
                  const PricingSlider(),
                ],
              ),
            ),
          ),

          // ── FAQ Section ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.background,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
              child: Column(
                children: [
                  const SectionBadge(title: 'সচরাচর জিজ্ঞাসা'),
                  const Text(
                    'সচরাচর জিজ্ঞাসাসমূহ',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.black),
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
              color: const Color(0xFF010A1A), // Deep navy from image
              padding: EdgeInsets.only(top: isMobile ? 60 : 100, bottom: 0, left: 24, right: 24),
              child: Column(
                children: [
                  // Blue Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.shade400, width: 1),
                    ),
                    child: const Text(
                      'জব প্রস্তুতি অ্যাপ',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'স্মার্ট প্রস্তুতি শুরু করুন আজই',
                    style: TextStyle(
                      fontSize: isMobile ? 32 : 48,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontFamily: 'Hind Siliguri',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Download our mobile app, start learning from today',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white60, fontSize: 16),
                  ),
                  const SizedBox(height: 48),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      const PlayStoreButton(),
                      // Phone Number Button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B).withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.phone_in_talk_rounded, color: Colors.white70, size: 20),
                            SizedBox(width: 12),
                            Text(
                              '০১৮৯৪-৪৪২৯৪৪',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80), 
                  // Overlapping Phone Mockups at bottom
                  SizedBox(
                    height: isMobile ? 400 : 520,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Transform.scale(
                          scale: isMobile ? 0.7 : 1.0,
                          child: const PhoneMockup(isCentered: true),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Blue Divider Line - Moved lower with more vertical presence
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              color: const Color(0xFF010A1A),
              child: Container(
                height: 1.5,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withValues(alpha: 0),
                      Colors.blue.withValues(alpha: 0.4),
                      Colors.blue.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Footer ────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF010A1A),
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 80),
              child: Column(
                children: [
                  Flex(
                    direction: isMobile ? Axis.vertical : Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column: Logo and Contact
                      Expanded(
                        flex: isMobile ? 0 : 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _JobProstutiLogo(),
                            const SizedBox(height: 24),
                            const Text(
                              'জব প্রস্তুতির আস্থার সঙ্গী — ৯ লক্ষ+\nশিক্ষার্থীর বিশ্বাস',
                              style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.6),
                            ),
                            const SizedBox(height: 32),
                            _FooterContactItem(icon: Icons.email_outlined, text: 'support@jobprostuti.com'),
                            _FooterContactItem(icon: Icons.phone_android_outlined, text: '01894-442944'),
                            _FooterContactItem(icon: Icons.location_on_outlined, text: '22-23 Station Road, Tejgaon,\nDhaka-1215'),
                          ],
                        ),
                      ),
                      
                      if (isMobile) const SizedBox(height: 48),

                      // Middle Column 1: Links
                      Expanded(
                        flex: isMobile ? 0 : 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('গুরুত্বপূর্ণ লিঙ্ক', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 20),
                            _FooterLink('About Us'),
                            _FooterLink('Blog'),
                            _FooterLink('FAQ'),
                            _FooterLink('Packages'),
                          ],
                        ),
                      ),

                      if (isMobile) const SizedBox(height: 40),

                      // Middle Column 2: Policies
                      Expanded(
                        flex: isMobile ? 0 : 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('নীতিমালা', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(height: 20),
                            _FooterLink('Privacy Policy'),
                            _FooterLink('Terms & Conditions'),
                            _FooterLink('Refund Policy'),
                          ],
                        ),
                      ),

                      if (isMobile) const SizedBox(height: 40),

                      // Right Column: Download and Social
                      Expanded(
                        flex: isMobile ? 0 : 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('অ্যাপ ডাউনলোড', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 20),
                            const PlayStoreButton(),
                            const SizedBox(height: 40),
                            const Text('আমাদের অনুসরণ করুন', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                _SocialIcon(Icons.facebook),
                                const SizedBox(width: 12),
                                _SocialIcon(Icons.group_rounded),
                                const SizedBox(width: 12),
                                _SocialIcon(Icons.chat_bubble_rounded),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                  // Payment Partners
                  const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PaymentChip(name: 'Visa'),
                        PaymentChip(name: 'Mastercard'),
                        PaymentChip(name: 'bKash'),
                        PaymentChip(name: 'Nagad'),
                        PaymentChip(name: 'Rocket'),
                        PaymentChip(name: 'Upay'),
                        PaymentChip(name: 'Mcash'),
                        PaymentChip(name: 'SureCash'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Divider(color: Colors.white10),
                  const SizedBox(height: 20),
                  const Text(
                    '© 2026 Job Prostuti. All rights reserved.',
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {}, // Link placeholder
                      child: const Text(
                        'Developed by hakaluki.dev',
                        style: TextStyle(color: Colors.blueAccent, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      )
    );
  }
}

class _FooterContactItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FooterContactItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue.shade400, size: 18),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: Colors.white60, fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  const _FooterLink(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text, style: const TextStyle(color: Colors.white60, fontSize: 14)),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  const _SocialIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.white70, size: 20),
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
            color: AppColors.accent,
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
                color: AppColors.accent,
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
  final VoidCallback onTap;
  const _NavLink(this.label, {this.isActive = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ),
    );
  }
}