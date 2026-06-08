import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/section_badge.dart';
import '../widgets/play_store_button.dart';
import '../widgets/call_button.dart';
import '../widgets/phone_mockup.dart';
import '../widgets/stat_card.dart';
import '../widgets/feature_card.dart';
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
          // App Bar
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(6)),
                  child: const Text('JOB\nPROSTUTI', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800, height: 1.1)),
                ),
                const Spacer(),
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const Text('সাইন ইন / আপ'),
                  ),
                ),
              ],
            ),
          ),

          // Hero Section
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.navy,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('জব প্রস্তুতি\nঘরে বসেই চাকরির\nপূর্ণাঙ্গ প্রস্তুতি', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white, height: 1.25)),
                  const SizedBox(height: 16),
                  const Text('বিসিএস, ব্যাংক, প্রাইমারি, শিক্ষক নিবন্ধন (NTRCA), সহকারী জজ সহ সকল চাকরির প্রস্তুতি হবে এক অ্যাপেই।', style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.5)),
                  const SizedBox(height: 30),
                  Row(children: [const PlayStoreButton(), const SizedBox(width: 12), const CallButton()]),
                  const SizedBox(height: 30),
                  Row(children: const [Text('★', style: TextStyle(color: AppColors.gold)), SizedBox(width: 4), Text('4.3', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)), SizedBox(width: 8), Text('•', style: TextStyle(color: Colors.white54)), SizedBox(width: 8), Text('৯ লাখ+ ডাউনলোড', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))]),
                  const SizedBox(height: 30),
                  const PhoneMockup(),
                ],
              ),
            ),
          ),

          // Stats Section
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.lightBg,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
              child: Column(
                children: [
                  const SectionBadge(title: 'পরিসংখ্যান'),
                  const SizedBox(height: 8),
                  const Text('এক নজরে জব প্রস্তুতি', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  const Text('৯ লাখ+ চাকরী প্রত্যাশী বিশ্বাস রেখেছে', style: TextStyle(color: AppColors.textMuted)),
                  const SizedBox(height: 32),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: const [
                      StatCard(icon: '🎓', number: '২০+', label: 'লাইভ কোর্স'),
                      StatCard(icon: '📝', number: '১ লক্ষ+', label: 'ব্যাখ্যাসহ প্রশ্ন'),
                      StatCard(icon: '📚', number: '৩০০+', label: 'টপিক'),
                      StatCard(icon: '⬇️', number: '৯ লাখ+', label: 'ডাউনলোড'),
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
                  const SectionBadge(title: 'অ্যাপ ফিচার'),
                  const Text('এক অ্যাপ, সব সমাধান', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(child: FeatureCard(icon: '🏆', title: 'মেধা তালিকা', description: 'হাজারো প্রতিযোগীর সাথে যাচাই করা যাবে নিজের অবস্থান')),
                      const SizedBox(width: 16),
                      Expanded(child: FeatureCard(icon: '📖', title: 'লেকচার অ্যান্ড নোটস', description: 'গোছানো প্রস্তুতি নিশ্চিতে সাজানো প্রতিটি সেকশন')),
                      const SizedBox(width: 16),
                      Expanded(child: FeatureCard(icon: '🎯', title: 'কুইজ কুইজ', description: 'প্রস্তুতি হবে মজায় মজায়, প্রস্তুতি খেলায় খেলায়')),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Courses Section
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.lightBg,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
              child: Column(
                children: [
                  const SectionBadge(title: 'কোর্স সমূহ'),
                  const Text('আমাদের কোর্স সমূহ', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  const Text('বিসিএস, ব্যাংক, প্রাইমারি, শিক্ষক নিবন্ধন, সহকারী জজ সহ সকল চাকরির প্রস্তুতি কোর্স', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted)),
                  const SizedBox(height: 32),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                    children: const [
                      CourseCard(icon: '🏦', title: 'ব্যাংক প্রস্তুতি', duration: '৮০ দিন', description: '৮০ দিনের ব্যাংক প্রস্তুতি কোর্সটি সাজানো হয়েছে যারা ব্যাংক এর প্রস্তুতি নিতে চাইছে তাদের জন্য।'),
                      CourseCard(icon: '📋', title: 'বিসিএস প্রস্তুতি', duration: '১২০ দিন', description: 'বিসিএস প্রস্তুতি ১২০ দিন কোর্সটি ডিজাইন করা হয়েছে পুরাতন বা নতুন সবাইকে সবার জন্য...'),
                      CourseCard(icon: '❓', title: 'বিসিএস প্রশ্ন ব্যাংক', duration: 'সীমাহীন', description: 'পরিকল্পিত সমন্বিত প্রস্তুতির মাধ্যমে প্রস্তুতি নিলে বিসিএস পরীক্ষায় ভাল করা সম্ভব।'),
                      CourseCard(icon: '📊', title: 'ডেইলি মডেল টেস্ট', duration: 'প্রতিদিন', description: 'প্রতিদিন বিসিএস ২০০ নম্বরের পূর্ণাঙ্গ পরীক্ষার আনুপাতিকহারে ৫০ নম্বরের মডেল টেস্ট।'),
                      CourseCard(icon: '🎒', title: 'প্রাইমারি প্রস্তুতি', duration: '৮০ দিন', description: '৮০ দিনের প্রাইমারি প্রস্তুতি কোর্সটি সাজানো হয়েছে যারা প্রাইমারি এর প্রস্তুতি নিতে চাইছে।'),
                      CourseCard(icon: '💼', title: 'ব্যাংক জব সলিউশন', duration: 'সীমাহীন', description: 'ব্যাংক প্রিলি পরীক্ষার বিগত সকল বছরের ব্যাখ্যা সহ প্রশ্মে সাজানো ব্যাংক জব সলিউশন সেকশন।'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('সব কোর্স দেখুন'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
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
                  const SectionBadge(title: 'ফিচার সমূহ'),
                  const Text('আমাদের ফিচার সমূহ', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const Text('এক অ্যাপেই চাকরির প্রস্তুতির সকল ফিচার', style: TextStyle(color: AppColors.textMuted)),
                  const SizedBox(height: 32),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.9,
                    children: const [
                      AppFeatureCard(icon: '📡', title: 'প্রতিযোগিতামূলক লাইভ পরীক্ষা', description: 'হাজারো প্রতিযোগীর সাথে ঘরে বসেই লাইভ পরীক্ষা দিয়ে যাচাই করা যাবে নিজের প্রস্তুতি'),
                      AppFeatureCard(icon: '📄', title: 'বিষয়ভিত্তিক মডেল টেস্ট', description: 'বিষয়ভিত্তিক পার্সোনালাইসড আনলিমিটেড মডেল টেস্ট। নিজেই সেট করা যাবে পরীক্ষার সময় এবং নম্বর'),
                      AppFeatureCard(icon: '📚', title: 'অধ্যায়ভিত্তিক অনুশীলন', description: '৩০০+ টপিক সাব-টপিকের উপর পড়াশোনা ও রিভিশনের সুযোগ'),
                      AppFeatureCard(icon: '💬', title: 'ব্যাখ্যা সহ প্রিমিয়াম প্রশ্নব্যাংক', description: '১ লক্ষের অধিক ব্যাখ্যাসহ প্রিমিয়াম প্রশ্ন। প্রতিদিনেই যুক্ত হচ্ছে নতুন নতুন সব প্রশ্ন।'),
                      AppFeatureCard(icon: '📋', title: 'পূর্ণাঙ্গ প্রশ্নব্যাংক', description: 'চাকরী পরীক্ষার পর দ্রুততম সময়ে ব্যাখ্যাসহ সমাধান আপলোড। বারবার জব সলিউশন কেনা থেকে মুক্তি'),
                      AppFeatureCard(icon: '🗺️', title: 'কমপ্লিট গাইডলাইন', description: '৩৫ - ৪৫ বিসিএস প্রশ্ন এনালাইসি, সাবজেক্ট ভিত্তিক পূর্ণাঙ্গ গাইডলাইন'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Pricing Section
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.navy,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
              child: Column(
                children: [
                  const Text('সুলভ মূল্য, সব সময়', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  const Text('সুলভ মূলে সেরা প্রস্তুতি নিশ্চিতে সাজানো আমাদের সব প্রিমিয়াম প্যাকেজ', textAlign: TextAlign.center, style: TextStyle(color: Colors.white60)),
                  const SizedBox(height: 32),
                  Row(
                    children: const [
                      Expanded(child: PricingCard(title: '৩ মাসের ফুল অ্যাপ এক্সেস', price: '৳২৯৯', isPopular: false)),
                      SizedBox(width: 16),
                      Expanded(child: PricingCard(title: '৬ মাসের ফুল অ্যাপ এক্সেস ⭐', price: '৳৪৯৯', isPopular: true)),
                      SizedBox(width: 16),
                      Expanded(child: PricingCard(title: '১ বছরের ফুল অ্যাপ এক্সেস ⭐', price: '৳৭৯৯', isPopular: false)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // FAQ Section
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.lightBg,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
              child: Column(
                children: [
                  const SectionBadge(title: 'সচরাচর জিজ্ঞাসা'),
                  const Text('সচরাচর জিজ্ঞাসাসমূহ', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark)),
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

          // CTA Section
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.navyDark,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              child: Column(
                children: [
                  const SectionBadge(title: 'জব প্রস্তুতি অ্যাপ'),
                  const SizedBox(height: 16),
                  const Text('স্মার্ট প্রস্তুতি শুরু করুন আজই', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  const Text('Download our mobile app, start learning from today', style: TextStyle(color: Colors.white60)),
                  const SizedBox(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: const [PlayStoreButton(), SizedBox(width: 12), CallButton()]),
                ],
              ),
            ),
          ),

          // Footer
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.navy,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text('© 2026 Job Prostuti. All rights reserved.', style: TextStyle(color: Colors.white38, fontSize: 12)),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    children: const [PaymentChip(name: 'Visa'), PaymentChip(name: 'Mastercard'), PaymentChip(name: 'bKash'), PaymentChip(name: 'Nagad'), PaymentChip(name: 'Rocket')],
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