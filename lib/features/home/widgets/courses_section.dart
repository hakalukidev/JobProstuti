import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../app/theme.dart';
import '../../../repositories/course_repository.dart';
import '../../../widgets/common/custom_button.dart';
import '../../../widgets/common/responsive_layout.dart';
import '../../../widgets/course/course_card.dart';

class CoursesSection extends ConsumerWidget {
  const CoursesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(allCoursesProvider);
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 72,
        horizontal: isMobile ? 20 : 40,
      ),
      child: MaxWidthBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('আমাদের কোর্সসমূহ', style: AppTextStyles.displaySmall),
                    const SizedBox(height: 6),
                    Text(
                      'সেরা শিক্ষকদের সাথে প্রস্তুতি নিন',
                      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mediumGray),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => context.go(AppRoutes.courses),
                  child: const Text('সব কোর্স দেখুন →'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            coursesAsync.when(
              data: (courses) {
                final displayed = courses.take(6).toList();
                if (isMobile) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayed.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, i) => CourseCard(course: displayed[i]),
                  );
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ResponsiveLayout.isDesktop(context) ? 3 : 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: displayed.length,
                  itemBuilder: (_, i) => CourseCard(course: displayed[i]),
                );
              },
              loading: () {
                if (isMobile) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, __) => const CourseCardSkeleton(),
                  );
                }
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.78,
                  children: List.generate(6, (_) => const CourseCardSkeleton()),
                );
              },
              error: (e, _) => AppErrorWidget(message: e.toString()),
            ),
            const SizedBox(height: 32),
            Center(
              child: PrimaryButton(
                label: 'সকল কোর্স দেখুন',
                onPressed: () => context.go(AppRoutes.courses),
                width: 220,
              ),
            ),
          ],
        ),
      ),
    );
  }
}