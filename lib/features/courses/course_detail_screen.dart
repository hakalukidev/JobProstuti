import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../core/providers/auth_provider.dart';
import '../../repositories/course_repository.dart';
import '../../widgets/common/custom_appbar.dart';
import '../../widgets/common/custom_button.dart';

class CourseDetailScreen extends ConsumerWidget {
  final String courseId;
  const CourseDetailScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(courseDetailProvider(courseId));
    final isAuth = ref.watch(isAuthenticatedProvider);

    return Scaffold(
      appBar: const AppBarWidget(),
      body: courseAsync.when(
        data: (course) => CustomScrollView(
          slivers: [
            // Hero image
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: course.imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      height: 220,
                      color: AppColors.primarySurface,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      height: 220,
                      color: AppColors.primarySurface,
                      child: const Icon(Icons.menu_book, size: 60, color: AppColors.primary),
                    ),
                  ),
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                      ),
                    ),
                  ),
                  if (course.isFree)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: AppBadge(
                        label: 'বিনামূল্যে',
                        backgroundColor: AppColors.success,
                        textColor: Colors.white,
                      ),
                    ),
                ],
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBadge(label: course.category),
                    const SizedBox(height: 10),
                    Text(course.title, style: AppTextStyles.displaySmall),
                    const SizedBox(height: 8),
                    Text(
                      course.shortDescription,
                      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.mediumGray),
                    ),
                    const SizedBox(height: 16),

                    // Rating & enrollment
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppColors.warning, size: 18),
                        const SizedBox(width: 4),
                        Text('${course.rating.toStringAsFixed(1)} (${course.reviewCount} রিভিউ)', style: AppTextStyles.bodySmall),
                        const SizedBox(width: 16),
                        const Icon(Icons.people_outlined, size: 18, color: AppColors.mediumGray),
                        const SizedBox(width: 4),
                        Text('${course.enrollmentCount}+ শিক্ষার্থী', style: AppTextStyles.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Stats grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 3,
                      children: [
                        _StatTile(icon: Icons.quiz_outlined, label: '${course.totalQuestions}+ প্রশ্ন'),
                        _StatTile(icon: Icons.video_library_outlined, label: '${course.totalVideos}+ ভিডিও'),
                        _StatTile(icon: Icons.menu_book_outlined, label: '${course.totalLessons}+ পাঠ'),
                        _StatTile(icon: Icons.timer_outlined, label: '${(course.duration.inHours)}+ ঘণ্টা'),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Description
                    if (course.fullDescription.isNotEmpty) ...[
                      Text('কোর্স সম্পর্কে', style: AppTextStyles.headlineLarge),
                      const SizedBox(height: 10),
                      Text(course.fullDescription, style: AppTextStyles.bodyMedium),
                      const SizedBox(height: 24),
                    ],

                    // Features
                    if (course.features.isNotEmpty) ...[
                      Text('এই কোর্সে যা পাবেন', style: AppTextStyles.headlineLarge),
                      const SizedBox(height: 12),
                      ...course.features.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: AppColors.success, size: 18),
                            const SizedBox(width: 10),
                            Expanded(child: Text(f, style: AppTextStyles.bodyMedium)),
                          ],
                        ),
                      )),
                      const SizedBox(height: 24),
                    ],

                    // Syllabus
                    if (course.syllabus.isNotEmpty) ...[
                      Text('সিলেবাস', style: AppTextStyles.headlineLarge),
                      const SizedBox(height: 12),
                      ...course.syllabus.map((section) => _SyllabusSection(section: section)),
                      const SizedBox(height: 24),
                    ],

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
        loading: () => const LoadingWidget(fullScreen: true),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          fullScreen: true,
          onRetry: () => ref.invalidate(courseDetailProvider(courseId)),
        ),
      ),
      bottomNavigationBar: courseAsync.when(
        data: (course) => Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: AppShadows.elevated,
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (course.isFree)
                    Text('বিনামূল্যে', style: AppTextStyles.statNumber.copyWith(color: AppColors.success))
                  else
                    Row(
                      children: [
                        Text('৳${course.effectivePrice.toInt()}', style: AppTextStyles.statNumber),
                        if (course.hasDiscount) ...[
                          const SizedBox(width: 8),
                          Text(
                            '৳${course.price.toInt()}',
                            style: AppTextStyles.bodySmall.copyWith(
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  Text('সম্পূর্ণ কোর্স', style: AppTextStyles.bodySmall),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: GradientButton(
                  label: course.isEnrolled
                      ? 'কোর্সে যান →'
                      : (isAuth ? 'এনরোল করুন' : 'লগইন করে শুরু করুন'),
                  onPressed: () {
                    if (!isAuth) {
                      context.go(AppRoutes.login);
                      return;
                    }
                    if (course.isEnrolled) {
                      // Navigate to course content
                    } else {
                      context.go('/courses/$courseId/enroll');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  const _StatTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 8),
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _SyllabusSection extends StatefulWidget {
  final dynamic section;
  const _SyllabusSection({required this.section});

  @override
  State<_SyllabusSection> createState() => _SyllabusSectionState();
}

class _SyllabusSectionState extends State<_SyllabusSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final topics = widget.section.topics as List<dynamic>? ?? [];
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGray),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.section.title ?? '',
                      style: AppTextStyles.headlineSmall.copyWith(fontSize: 14),
                    ),
                  ),
                  Text(
                    '${topics.length} টপিক',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.mediumGray),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: AppColors.mediumGray,
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                ...topics.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 6, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Expanded(child: Text(t.toString(), style: AppTextStyles.bodySmall)),
                    ],
                  ),
                )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}