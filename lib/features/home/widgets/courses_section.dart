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
    final isDesktop = ResponsiveLayout.isDesktop(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primarySurface.withValues(alpha: 0.5),
            AppColors.background,
            AppColors.background,
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 48 : 80,
        horizontal: isMobile ? 20 : 40,
      ),
      child: MaxWidthBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top accent bar
            Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Eyebrow badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'কোর্স',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'আমাদের কোর্সসমূহ',
                        style: AppTextStyles.displayMedium.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.auto_stories,
                            size: 16,
                            color: AppColors.mediumGray,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'সেরা শিক্ষকদের সাথে প্রস্তুতি নিন',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.mediumGray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!isMobile)
                  FilledButton.icon(
                    onPressed: () => context.go(AppRoutes.courses),
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text('সব কোর্স দেখুন'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 36),

            // Course grid
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
                    crossAxisCount: isDesktop ? 3 : 2,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: 0.75,
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
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isDesktop ? 3 : 2,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 24,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: 6,
                  itemBuilder: (_, __) => const CourseCardSkeleton(),
                );
              },
              error: (e, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: AppErrorWidget(message: e.toString()),
              ),
            ),

            // Mobile CTA
            if (isMobile) ...[
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => context.go(AppRoutes.courses),
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text('সকল কোর্স দেখুন'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
