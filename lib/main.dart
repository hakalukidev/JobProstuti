import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Prostuti',
      theme: ThemeData(
        fontFamily: 'Hind Siliguri',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1a5ff3)),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
          color: Colors.white,
          iconTheme: IconThemeData(color: Color(0xFF0f1e4a)),
          titleTextStyle: TextStyle(
            color: Color(0xFF0f1e4a),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Navbar
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1a5ff3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'JOB\nPROSTUTI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1a5ff3),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('সাইন ইন / আপ'),
                  ),
                ),
              ],
            ),
          ),

          // Hero Section
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF0f1e4a),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'জব প্রস্তুতি\nঘরে বসেই চাকরির\nপূর্ণাঙ্গ প্রস্তুতি',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'বিসিএস, ব্যাংক, প্রাইমারি, শিক্ষক নিবন্ধন (NTRCA), সহকারী জজ সহ সকল চাকরির প্রস্তুতি হবে এক অ্যাপেই।',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      _buildPlayStoreButton(),
                      const SizedBox(width: 12),
                      _buildCallButton(),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Text('★', style: TextStyle(color: Color(0xFFf59e0b))),
                      const SizedBox(width: 4),
                      const Text(
                        '4.3',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      const Text('•', style: TextStyle(color: Colors.white54)),
                      const SizedBox(width: 8),
                      const Text(
                        '৯ লাখ+ ডাউনলোড',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildPhoneMockup(),
                ],
              ),
            ),
          ),

          // Stats Section
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFFf5f7ff),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
              child: Column(
                children: [
                  _buildSectionBadge('পরিসংখ্যান'),
                  const SizedBox(height: 8),
                  const Text(
                    'এক নজরে জব প্রস্তুতি',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0f1e4a)),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '৯ লাখ+ চাকরী প্রত্যাশী বিশ্বাস রেখেছে',
                    style: TextStyle(color: Color(0xFF5a6a8a)),
                  ),
                  const SizedBox(height: 32),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _buildStatCard('🎓', '২০+', 'লাইভ কোর্স'),
                      _buildStatCard('📝', '১ লক্ষ+', 'ব্যাখ্যাসহ প্রশ্ন'),
                      _buildStatCard('📚', '৩০০+', 'টপিক'),
                      _buildStatCard('⬇️', '৯ লাখ+', 'ডাউনলোড'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Features Section
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
              child: Column(
                children: [
                  _buildSectionBadge('অ্যাপ ফিচার'),
                  const Text(
                    'এক অ্যাপ, সব সমাধান',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0f1e4a)),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(child: _buildFeatureCard('🏆', 'মেধা তালিকা', 'হাজারো প্রতিযোগীর সাথে যাচাই করা যাবে নিজের অবস্থান')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildFeatureCard('📖', 'লেকচার অ্যান্ড নোটস', 'গোছানো প্রস্তুতি নিশ্চিতে সাজানো প্রতিটি সেকশন')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildFeatureCard('🎯', 'কুইজ কুইজ', 'প্রস্তুতি হবে মজায় মজায়, প্রস্তুতি খেলায় খেলায়')),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Courses Section
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFFf5f7ff),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
              child: Column(
                children: [
                  _buildSectionBadge('কোর্স সমূহ'),
                  const Text(
                    'আমাদের কোর্স সমূহ',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0f1e4a)),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'বিসিএস, ব্যাংক, প্রাইমারি, শিক্ষক নিবন্ধন, সহকারী জজ সহ সকল চাকরির প্রস্তুতি কোর্স',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF5a6a8a)),
                  ),
                  const SizedBox(height: 32),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                    children: [
                      _buildCourseCard('🏦', 'ব্যাংক প্রস্তুতি', '৮০ দিন', '৮০ দিনের ব্যাংক প্রস্তুতি কোর্সটি সাজানো হয়েছে যারা ব্যাংক এর প্রস্তুতি নিতে চাইছে তাদের জন্য।'),
                      _buildCourseCard('📋', 'বিসিএস প্রস্তুতি', '১২০ দিন', 'বিসিএস প্রস্তুতি ১২০ দিন কোর্সটি ডিজাইন করা হয়েছে পুরাতন বা নতুন সবাইকে সবার জন্য...'),
                      _buildCourseCard('❓', 'বিসিএস প্রশ্ন ব্যাংক', 'সীমাহীন', 'পরিকল্পিত সমন্বিত প্রস্তুতির মাধ্যমে প্রস্তুতি নিলে বিসিএস পরীক্ষায় ভাল করা সম্ভব।'),
                      _buildCourseCard('📊', 'ডেইলি মডেল টেস্ট', 'প্রতিদিন', 'প্রতিদিন বিসিএস ২০০ নম্বরের পূর্ণাঙ্গ পরীক্ষার আনুপাতিকহারে ৫০ নম্বরের মডেল টেস্ট।'),
                      _buildCourseCard('🎒', 'প্রাইমারি প্রস্তুতি', '৮০ দিন', '৮০ দিনের প্রাইমারি প্রস্তুতি কোর্সটি সাজানো হয়েছে যারা প্রাইমারি এর প্রস্তুতি নিতে চাইছে।'),
                      _buildCourseCard('💼', 'ব্যাংক জব সলিউশন', 'সীমাহীন', 'ব্যাংক প্রিলি পরীক্ষার বিগত সকল বছরের ব্যাখ্যা সহ প্রশ্মে সাজানো ব্যাংক জব সলিউশন সেকশন।'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('সব কোর্স দেখুন'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1a5ff3),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // App Features Grid
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
              child: Column(
                children: [
                  _buildSectionBadge('ফিচার সমূহ'),
                  const Text(
                    'আমাদের ফিচার সমূহ',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0f1e4a)),
                  ),
                  const Text(
                    'এক অ্যাপেই চাকরির প্রস্তুতির সকল ফিচার',
                    style: TextStyle(color: Color(0xFF5a6a8a)),
                  ),
                  const SizedBox(height: 32),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.9,
                    children: [
                      _buildAppFeatureCard('📡', 'প্রতিযোগিতামূলক লাইভ পরীক্ষা', 'হাজারো প্রতিযোগীর সাথে ঘরে বসেই লাইভ পরীক্ষা দিয়ে যাচাই করা যাবে নিজের প্রস্তুতি'),
                      _buildAppFeatureCard('📄', 'বিষয়ভিত্তিক মডেল টেস্ট', 'বিষয়ভিত্তিক পার্সোনালাইসড আনলিমিটেড মডেল টেস্ট। নিজেই সেট করা যাবে পরীক্ষার সময় এবং নম্বর'),
                      _buildAppFeatureCard('📚', 'অধ্যায়ভিত্তিক অনুশীলন', '৩০০+ টপিক সাব-টপিকের উপর পড়াশোনা ও রিভিশনের সুযোগ'),
                      _buildAppFeatureCard('💬', 'ব্যাখ্যা সহ প্রিমিয়াম প্রশ্নব্যাংক', '১ লক্ষের অধিক ব্যাখ্যাসহ প্রিমিয়াম প্রশ্ন। প্রতিদিনেই যুক্ত হচ্ছে নতুন নতুন সব প্রশ্ন।'),
                      _buildAppFeatureCard('📋', 'পূর্ণাঙ্গ প্রশ্নব্যাংক', 'চাকরী পরীক্ষার পর দ্রুততম সময়ে ব্যাখ্যাসহ সমাধান আপলোড। বারবার জব সলিউশন কেনা থেকে মুক্তি'),
                      _buildAppFeatureCard('🗺️', 'কমপ্লিট গাইডলাইন', '৩৫ - ৪৫ বিসিএস প্রশ্ন এনালাইসি, সাবজেক্ট ভিত্তিক পূর্ণাঙ্গ গাইডলাইন'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Pricing Section
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF0f1e4a),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
              child: Column(
                children: [
                  const Text(
                    'সুলভ মূল্য, সব সময়',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'সুলভ মূলে সেরা প্রস্তুতি নিশ্চিতে সাজানো আমাদের সব প্রিমিয়াম প্যাকেজ',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white60),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(child: _buildPricingCard('৩ মাসের ফুল অ্যাপ এক্সেস', '৳২৯৯', false)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildPricingCard('৬ মাসের ফুল অ্যাপ এক্সেস ⭐', '৳৪৯৯', true)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildPricingCard('১ বছরের ফুল অ্যাপ এক্সেস ⭐', '৳৭৯৯', false)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // FAQ Section
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFFf5f7ff),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
              child: Column(
                children: [
                  _buildSectionBadge('সচরাচর জিজ্ঞাসা'),
                  const Text(
                    'সচরাচর জিজ্ঞাসাসমূহ',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0f1e4a)),
                  ),
                  const SizedBox(height: 32),
                  _buildFaqItem(
                    'জব প্রস্তুতি অ্যাপটি কি? কাদের জন্য এই অ্যাপ?',
                    'জব প্রস্তুতি একটি চাকরি পরীক্ষার প্রস্তুতি প্ল্যাটফর্ম যেখানে বিসিএস, ব্যাংক, প্রাইমারি সহ সকল সরকারি চাকরির জন্য প্রস্তুতি নেওয়া যায়। যেকোনো চাকরি প্রত্যাশী এই অ্যাপ ব্যবহার করতে পারবেন।',
                  ),
                  const SizedBox(height: 12),
                  _buildFaqItem(
                    'আমি এখনও ছাত্র, আমি কিভাবে জব প্রস্তুতি শুরু করব?',
                    'ছাত্র অবস্থা থেকেই প্রস্তুতি শুরু করা যায়। আমাদের গাইডলাইন সেকশন ও টপিক-ভিত্তিক অনুশীলন দিয়ে শুরু করুন এবং ধীরে ধীরে মডেল টেস্ট ও লাইভ পরীক্ষায় অংশগ্রহণ করুন।',
                  ),
                  const SizedBox(height: 12),
                  _buildFaqItem(
                    'জব প্রস্তুতি অ্যাপ কিভাবে ইউজ করলে সবচেয়ে ভাল করতে পারব?',
                    'প্রতিদিন নিয়মিত ডেইলি মডেল টেস্ট দিন, টপিক-ভিত্তিক অনুশীলন করুন এবং লাইভ পরীক্ষায় অংশ নিন। মেধা তালিকায় নিজের অবস্থান দেখে দুর্বলতা চিহ্নিত করুন।',
                  ),
                ],
              ),
            ),
          ),

          // CTA Section
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF091232),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              child: Column(
                children: [
                  _buildSectionBadge('জব প্রস্তুতি অ্যাপ'),
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
                    children: [
                      _buildPlayStoreButton(),
                      const SizedBox(width: 12),
                      _buildCallButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Footer
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF0f1e4a),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    '© 2026 Job Prostuti. All rights reserved.',
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    children: [
                      _buildPaymentChip('Visa'),
                      _buildPaymentChip('Mastercard'),
                      _buildPaymentChip('bKash'),
                      _buildPaymentChip('Nagad'),
                      _buildPaymentChip('Rocket'),
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

  Widget _buildSectionBadge(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF1a5ff3), width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFF1a5ff3),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(color: Color(0xFF1a5ff3), fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayStoreButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.play_arrow, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('GET IT ON', style: TextStyle(color: Colors.white70, fontSize: 9)),
              Text('Google Play', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCallButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white54, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        '📞 ০১৮৯৪-৪৪২৯৪৪',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildPhoneMockup() {
    return Center(
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 30, offset: const Offset(0, 10))],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('জব প্রস্তুতি', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('🔔', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1a5ff3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('জব প্রস্তুতি | ৪৫ তম পরীক্ষা', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFe0e8f5)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('বাংলাদেশ বিষয়াবলী - ১০', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                            Text('প্রশ্ন ৩০ টি · ৭ মিনিট', style: TextStyle(color: Color(0xFF5a6a8a), fontSize: 10)),
                          ],
                        ),
                        Text('⏱ 00:58:44', style: TextStyle(color: Color(0xFF1a5ff3), fontSize: 11, fontWeight: FontWeight.w600)),
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

  Widget _buildStatCard(String icon, String number, String label) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFe0e8f5)),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(number, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0f1e4a))),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Color(0xFF5a6a8a), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String icon, String title, String description) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFe0e8f5)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFf5f7ff),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 48))),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0f1e4a))),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: Color(0xFF5a6a8a), fontSize: 12, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(String icon, String title, String duration, String description) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFe0e8f5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF0f1e4a), Color(0xFF1a5ff3)]),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 40))),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0f1e4a))),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFf5f7ff),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(duration, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Color(0xFF1a5ff3))),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF5a6a8a), fontSize: 11)),
                const SizedBox(height: 8),
                const Text('বিস্তারিত পড়ুন →', style: TextStyle(color: Color(0xFF1a5ff3), fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppFeatureCard(String icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFe0e8f5)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFf5f7ff),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0f1e4a)), textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(description, style: const TextStyle(color: Color(0xFF5a6a8a), fontSize: 11, height: 1.4), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildPricingCard(String title, String price, bool isPopular) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isPopular ? const Color(0xFF1a5ff3).withOpacity(0.15) : Colors.white.withOpacity(0.06),
        border: Border.all(color: isPopular ? const Color(0xFF1a5ff3) : Colors.white.withOpacity(0.15)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (isPopular) const Text('⭐ জনপ্রিয়', style: TextStyle(color: Color(0xFFf59e0b), fontSize: 11)),
          const SizedBox(height: 12),
          Text(price, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildPriceFeature('সকল লাইভ / আর্কাইভড কোর্স'),
          _buildPriceFeature('বিষয়ভিত্তিক মডেল টেস্ট'),
          _buildPriceFeature('বিষয়ভিত্তিক অনুশীলন'),
          _buildPriceFeature('প্রশ্নব্যাংক / জব সলিউশন'),
          _buildPriceFeature('সার্চ অপশন'),
          _buildPriceFeature('প্রিয় প্রশ্ন মার্ক অপশন'),
        ],
      ),
    );
  }

  Widget _buildPriceFeature(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check, color: Color(0xFF22c55e), size: 14),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 11))),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFe0e8f5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0f1e4a))),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(answer, style: const TextStyle(color: Color(0xFF5a6a8a), fontSize: 13, height: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentChip(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(name, style: const TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w600)),
    );
  }
}