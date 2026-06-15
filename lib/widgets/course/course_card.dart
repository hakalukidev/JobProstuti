import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../models/course_model.dart';
import '../common/custom_button.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final bool isCompact;

  const CourseCard({super.key, required this.course, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/courses/${course.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.card,
          border: Border.all(color: AppColors.lightGray),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: course.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: AppColors.primarySurface,
                      child: const Center(
                        child: Icon(Icons.menu_book, color: AppColors.primary, size: 40),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.primarySurface,
                      child: const Center(
                        child: Icon(Icons.menu_book, color: AppColors.primary, size: 40),
                      ),
                    ),
                  ),
                ),
                // Free / Live badge
                Positioned(
                  top: 10,
                  left: 10,
                  child: Row(
                    children: [
                      if (course.isFree)
                        AppBadge(
                          label: 'বিনামূল্যে',
                          backgroundColor: AppColors.success,
                          textColor: AppColors.white,
                        ),
                      if (course.isLive) ...[
                        if (course.isFree) const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'লাইভ',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (course.hasDiscount)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        '${course.discountPercent}% ছাড়',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  AppBadge(label: course.category),
                  const SizedBox(height: 8),

                  // Title
                  Text(
                    course.title,
                    style: AppTextStyles.headlineSmall.copyWith(fontSize: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  if (!isCompact) ...[
                    Text(
                      course.shortDescription,
                      style: AppTextStyles.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),

                    // Stats row
                    Row(
                      children: [
                        _StatChip(
                          icon: Icons.people_outline,
                          label: '${course.enrollmentCount}+ শিক্ষার্থী',
                        ),
                        const SizedBox(width: 8),
                        _StatChip(
                          icon: Icons.quiz_outlined,
                          label: '${course.totalQuestions}+ প্রশ্ন',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Price row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      course.isFree
                          ? Text(
                        'বিনামূল্যে',
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: AppColors.success,
                          fontSize: 16,
                        ),
                      )
                          : Row(
                        children: [
                          Text(
                            '৳${course.effectivePrice.toInt()}',
                            style: AppTextStyles.headlineSmall.copyWith(
                              color: AppColors.primary,
                              fontSize: 16,
                            ),
                          ),
                          if (course.hasDiscount) ...[
                            const SizedBox(width: 6),
                            Text(
                              '৳${course.price.toInt()}',
                              style: AppTextStyles.bodySmall.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.mediumGray,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (!isCompact)
                        Text(
                          '★ ${course.rating.toStringAsFixed(1)}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.warning,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),

                  if (course.isEnrolled && course.progressPercent != null) ...[
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: course.progressPercent! / 100,
                        backgroundColor: AppColors.lightGray,
                        valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${course.progressPercent}% সম্পন্ন',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.mediumGray),
        const SizedBox(width: 3),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}