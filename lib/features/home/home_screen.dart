import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/common/custom_appbar.dart';
import 'widgets/hero_section.dart';
import 'widgets/stats_section.dart';
import 'widgets/courses_section.dart';
import 'widgets/features_section.dart';
import 'widgets/resources_section.dart';
import 'widgets/pricing_section.dart';
import 'widgets/faq_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const AppBarWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            HeroSection(),
            StatsSection(),
            CoursesSection(),
            FeaturesSection(),
            ResourcesSection(),
            PricingSection(),
            FaqSection(),
            AppFooter(),
          ],
        ),
      ),
    );
  }
}